import 'dart:async';

import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/services/device_info_service.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
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

    try {
      final deviceInfo = await DeviceInfoService.getDeviceInfo(includeLocation: true);
      options.headers.addAll({
        'X-Platform': deviceInfo['platform'],
        'X-Device-Model': deviceInfo['device_model'],
        'X-OS-Version': deviceInfo['os_version'],
        'X-Device-ID': deviceInfo['device_id'],
        'X-App-Version': deviceInfo['app_version'],
        'X-Location': deviceInfo['location'] != null
            ? '${deviceInfo['location']['lat']},${deviceInfo['location']['lng']}'
            : '',
      });
    } catch (e) {
      debugPrint('Failed to get device info: $e');
    }

    /// Log request/response
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    bool isRefreshing = false;
    final List<Function(String)> refreshQueue = [];

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = HiveService.getToken();
          debugPrint(
            "Interceptor token: ${token?.accessToken}, refresh: ${token?.refreshToken}",
          );

          // BỎ QUA nếu là request refresh
          if (options.path.contains('/auth/refresh') ||
              options.path.contains(
                'https://split-expense-s3.s3.amazonaws.com',
              )) {
            return handler.next(options);
          }
          options.headers['Authorization'] =
              'Bearer ${token?.accessToken?.trim()}';

          handler.next(options);
        },
        onError: (DioException err, handler) async {
          final response = err.response;

          if (response != null) {
            final errorCode = response.data['error_code'];
            final messageCode = response.data['message_code'];

            // ===> THÊM CHECK NÀY
            if ((errorCode == 403 ||
                    messageCode == "INVALID_OR_EXPIRED_TOKEN") &&
                response.requestOptions.path.contains('/auth/refresh')) {
              final context = navigatorKey.currentContext!;
              await HiveService.clearToken(); // Xóa token khỏi local storage
              await HiveService.clearUser(); // Xóa dữ liệu người dùng khỏi local storage
              context.read<AuthBloc>().add(AuthCheckRequested());
              context.goNamed(AppRouteNames.splash2);

              refreshQueue.clear();
              isRefreshing = false;
              return handler.next(err); // dừng ở đây
            }

            // Trường hợp token hết hạn
            final isTokenExpired =
                (errorCode == 403 && messageCode == "INVALID_OR_EXPIRED_TOKEN");

            // print(
            //   "isTokenExpired: $isTokenExpired, isRefreshing: $isRefreshing",
            // );

            if (isTokenExpired && !isRefreshing) {
              isRefreshing = true;
              final refreshToken = HiveService.getToken()?.refreshToken;

              try {
                final refreshResponse = await dio.post(
                  '/auth/refresh',
                  data: {'refresh_token': refreshToken},
                );

                final statusCode = refreshResponse.statusCode;

                // ===> CHỈ XỬ LÝ NẾU REFRESH OK
                if (statusCode == 200 && refreshResponse.data['data'] != null) {
                  final newAccessToken =
                      refreshResponse.data['data']['access_token'];
                  final newRefreshToken =
                      refreshResponse.data['data']['refresh_token'];

                  await HiveService.saveToken(
                    TokenLocalModel(
                      accessToken: newAccessToken,
                      refreshToken: newRefreshToken,
                    ),
                  );

                  for (final queued in refreshQueue) {
                    queued(newAccessToken);
                  }
                  refreshQueue.clear();
                  isRefreshing = false;

                  final requestOptions = response.requestOptions;
                  requestOptions.headers['Authorization'] =
                      'Bearer ${newAccessToken.trim()}';
                  final retriedResponse = await dio.fetch(requestOptions);
                  return handler.resolve(retriedResponse);
                }
              } catch (e) {
                // network error cũng logout
                final context = navigatorKey.currentContext!;
                await HiveService.clearToken(); // Xóa token khỏi local storage
                await HiveService.clearUser(); // Xóa dữ liệu người dùng khỏi local storage
                context.read<AuthBloc>().add(AuthCheckRequested());
                context.goNamed(AppRouteNames.splash2);

                refreshQueue.clear();
                isRefreshing = false;
                return handler.next(err);
              }
            } else if (isRefreshing && isTokenExpired) {
              // Nếu đang refresh thì push request này vào queue
              final completer = Completer<Response>();
              refreshQueue.add((String newAccessToken) async {
                final requestOptions = response.requestOptions;
                requestOptions.headers['Authorization'] =
                    'Bearer ${newAccessToken.trim()}';
                final retriedResponse = await dio.fetch(requestOptions);
                completer.complete(retriedResponse);
              });

              return handler.resolve(await completer.future);
            }
          }

          // Các lỗi 401 khác (ví dụ sai mật khẩu) → để UI xử lý
          return handler.next(err);
        },
      ),
    );

    return dio;
  }
}
