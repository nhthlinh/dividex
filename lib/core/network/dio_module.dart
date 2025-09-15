import 'dart:async';

import 'package:Dividex/config/routes/router.dart';
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

    /// Log request/response
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    bool isRefreshing = false;
    final List<Function(String)> refreshQueue = [];

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = HiveService.getToken();
          debugPrint(
            "🟡 Interceptor token: ${token?.accessToken}, refresh: ${token?.refreshToken}",
          );

          // BỎ QUA nếu là request refresh
          if (options.path.contains('/auth/refresh')) {
            return handler.next(options);
          }
          options.headers['Authorization'] =
              'Bearer ${token?.accessToken?.trim()}';

          handler.next(options);
        },
        onResponse: (response, handler) async {
          if ((response.data['error_code'] == 401 ||
                  response.data['error_code'] == 403) &&
              !isRefreshing) {
            isRefreshing = true;

            try {
              final refreshToken = HiveService.getToken()?.refreshToken;
              debugPrint('🔁 Refresh token: $refreshToken');

              final refreshResponse = await dio.post(
                '/auth/refresh',
                data: {'refresh_token': refreshToken},
              );

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

              // chạy lại các request trong queue
              for (final queued in refreshQueue) {
                queued(newAccessToken);
              }
              refreshQueue.clear();

              isRefreshing = false;

              // retry request hiện tại
              // copy headers cũ + headers global
              final requestOptions = response.requestOptions;

              final headers = Map<String, dynamic>.from(requestOptions.headers)
                ..addAll(dio.options.headers) // giữ Accept-Language
                ..['Authorization'] = 'Bearer ${newAccessToken.trim()}';

              requestOptions.headers = headers;

              final retriedResponse = await dio.fetch(requestOptions);
              return handler.resolve(retriedResponse);
            } catch (e) {
              debugPrint('❌ Refresh token failed: $e');

              // ép logout: clear Hive + điều hướng về login
              await HiveService.clearToken();
              final context = navigatorKey.currentContext!;
              final authBloc = context.read<AuthBloc>();
              authBloc.add(const AuthLogoutRequested());
              context.goNamed(AppRouteNames.login);

              refreshQueue.clear();
              isRefreshing = false;

              return handler.next(response);
            }
          } else if (response.data['error_code'] == 401 ||
              response.data['error_code'] == 403 && isRefreshing) {
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
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          final response = err.response!;

          if ((response.data['error_code'] == 401 ||
                  response.data['error_code'] == 403) &&
              !isRefreshing) {
            isRefreshing = true;

            try {
              final refreshToken = HiveService.getToken()?.refreshToken;
              debugPrint('🔁 Refresh token: $refreshToken');

              final refreshResponse = await dio.post(
                '/auth/refresh',
                data: {'refresh_token': refreshToken},
              );

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

              // chạy lại các request trong queue
              for (final queued in refreshQueue) {
                queued(newAccessToken);
              }
              refreshQueue.clear();

              isRefreshing = false;

              // retry request hiện tại
              // copy headers cũ + headers global
              final requestOptions = response.requestOptions;

              final headers = Map<String, dynamic>.from(requestOptions.headers)
                ..addAll(dio.options.headers) // giữ Accept-Language
                ..['Authorization'] = 'Bearer ${newAccessToken.trim()}';

              requestOptions.headers = headers;

              final retriedResponse = await dio.fetch(requestOptions);
              return handler.resolve(retriedResponse);
            } catch (e) {
              debugPrint('❌ Refresh token failed: $e');

              // ép logout: clear Hive + điều hướng về login
              await HiveService.clearToken();
              final context = navigatorKey.currentContext!;
              context.goNamed(AppRouteNames.login);

              refreshQueue.clear();
              isRefreshing = false;

              return handler.next(err);
            }
          } else if (response.data['error_code'] == 401 ||
              response.data['error_code'] == 403 && isRefreshing) {
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
          return handler.next(err);
        },
      ),
    );

    return dio;
  }
}
