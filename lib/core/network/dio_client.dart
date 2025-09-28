import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  final Dio dio;

  DioClient(this.dio);

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return dio.delete(path, data: data, queryParameters: queryParameters);
  }

  // Thêm các phương thức put, delete... nếu cần
}


Future<T> apiCallWrapper<T>(Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on DioException catch (dioError) {
    if (dioError.response != null) {
      final data = dioError.response?.data;
      final message = data['message'] ?? 'Unknown error';
      final messageCode = data['message_code'] ?? '';
      throw Exception('$messageCode: $message');
    } else {
      throw Exception('Network error: ${dioError.message}');
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
    throw Exception('Unexpected error: $e');
  }
}

