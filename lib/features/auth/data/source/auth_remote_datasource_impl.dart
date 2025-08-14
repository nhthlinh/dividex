import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/models/user_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'auth_remote_datasource.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> register(UserModel user, String password) async {
    try {
      final formData = ({
        "full_name": user.fullName,
        "email": user.email,
        "password": password,
        "phone_number": user.phoneNumber
      });

      final response = await dio.post(
        '/auth/register',
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register: ${response.statusCode}');
      } else if (response.statusCode == 409 || response.data['error_code'] == 409) {
        if (response.data != null) {
          final serverMessage = response.data['message_code'] ?? response;
          throw Exception(serverMessage);
        }
      }

      return AuthResponseModel.fromJson(response.data['data']);
    }
    catch (e) {
      throw Exception('Error during register: $e');
    }
  }
  
  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login', // hoặc URI thật
      data: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to login: ${response.statusCode}');
    }
    return AuthResponseModel.fromJson(response.data['data']);
  }
  
  @override
  Future<void> logout() async {
    final response = await dio.get(
      '/auth/logout', // hoặc URI thật
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }

  @override
  Future<void> requestOtp(String email) async {
    final response = await dio.post(
      '/email/send-otp', // hoặc URI thật
      data: {'to': email},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to request OTP: ${response.statusCode}');
    }
  }

  @override
  Future<void> checkOtp(String email, String otp) async { 
    final response = await dio.post(
      '/email/verify-otp', // hoặc URI thật
      data: {
        'email': email,
        'otp': otp,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to check OTP: ${response.statusCode}');
    }
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    final response = await dio.post(
      '/user/new-password', // hoặc URI thật
      data: {
        'email': email,
        'newPassword': newPassword,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  }

  @override
  Future<void> changePassword(String email, String newPassword, String oldPassword) async {
    final response = await dio.post(
      '/user/change-password', // hoặc URI thật
      data: {
        'email': email,
        'newPassword': newPassword,
        'oldPassword': oldPassword,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to change password: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    final response = await dio.put(
      '/user/fcm-token',
      data: {
        'fcmToken': fcmToken,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update FCM token: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    final response = await dio.put(
      '/user/device-language',
      data: {
        'lang': languageCode,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update language: ${response.statusCode}');
    }
  }
  
}
