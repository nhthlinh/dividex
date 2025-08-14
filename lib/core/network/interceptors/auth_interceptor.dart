import 'package:dio/dio.dart';
import '../../session/session_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = SessionManager.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
            // ignore: unnecessary_statements
            ('Token expired -> handle refresh here.');
    }
    handler.next(err);
  }
}
      
      