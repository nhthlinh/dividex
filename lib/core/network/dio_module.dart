import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Future<Dio> dio() async {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw Exception('.env config is missing BASE_URL');
    }

    final locale = HiveService.getSettings().localeCode;

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept-Language': locale},
    );

    final dio = Dio(options);

    /// Log request/response
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = HiveService.getToken();
          
          // BỎ QUA nếu là request refresh
          if (options.path.contains('/auth/refresh')) {
            return handler.next(options);
          }
          options.headers['Authorization'] = 'Bearer ${token?.accessToken?.trim()}';
          handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.data['error_code'] == 401 || response.data['error_code'] == 403) {
            try {
              final refreshToken = HiveService.getToken()?.refreshToken;
              debugPrint('🔁 Refresh token: $refreshToken');

              // Gọi refresh token bằng chính `dio`
              final refreshResponse = await dio.post(
                '/auth/refresh',
                data: {
                  'refresh_token': refreshToken
                },
                options: Options(),
              );

              final newAccessToken = refreshResponse.data['data']['accessToken'];
              final newRefreshToken = refreshResponse.data['data']['refreshToken'];

              // Lưu vào Hive
              await HiveService.saveToken(TokenLocalModel(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken, // Giữ nguyên refresh token
              ));

              // Gắn token mới & retry request cũ
              final requestOptions = response.requestOptions;
              requestOptions.headers['Authorization'] =
                  'Bearer ${newAccessToken.trim()}';

              final retriedResponse = await dio.fetch(requestOptions);
              return handler.resolve(retriedResponse);
            } catch (e) {
              return handler.next(response);
            }
          }
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          if (err.response?.statusCode == 401) {
            try {
              final refreshToken = HiveService.getToken()?.refreshToken;
              debugPrint('🔁 Refresh token: $refreshToken');

              // Gọi refresh token bằng chính `dio`
              final refreshResponse = await dio.post(
                '/auth/refresh',
                data: {
                  'refresh_token': refreshToken
                },
                options: Options(),
              );

              final newAccessToken = refreshResponse.data['data']['accessToken'];
              final newRefreshToken = refreshResponse.data['data']['refreshToken'];
              debugPrint('✅ Got new token: $newAccessToken');

              // Lưu vào Hive
              await HiveService.saveToken(TokenLocalModel(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken, // Giữ nguyên refresh token
              ));

              // Gắn token mới & retry request cũ
              final requestOptions = err.requestOptions;
              requestOptions.headers['Authorization'] =
                  'Bearer ${newAccessToken.trim()}';

              final response = await dio.fetch(requestOptions);
              return handler.resolve(response);
            } catch (e) {
              debugPrint('❌ Refresh token failed: $e');
              return handler.next(err);
            }
          }

          return handler.next(err);
        },
      ),
    );

    return dio;
  }
}
