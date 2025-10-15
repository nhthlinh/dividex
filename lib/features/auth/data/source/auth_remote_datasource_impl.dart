import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'auth_remote_datasource.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> register(UserModel user, String password) async {
    return apiCallWrapper(() async {
      final formData = ({
        "full_name": user.fullName,
        "email": user.email,
        "password": password,
        "phone_number": user.phoneNumber,
      });

      final response = await dio.post('/auth/register', data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register: ${response.statusCode}');
      }

      return AuthResponseModel.fromJson(response.data['data']);
    });
  }

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to login: ${response.statusCode}');
      }
      return AuthResponseModel.fromJson(response.data['data']);
    });
  }

  @override
  Future<void> logout() async {
    return apiCallWrapper(() async {
      final response = await dio.put('/auth/logout');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    });
  }

  @override
  Future<void> requestEmail(String email) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/auth/password/forget',
        data: {'email': email},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to request OTP: ${response.statusCode}');
      }
    });
  }

  @override
  Future<String> checkEmailExists(String email, String otp) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/auth/password/otp',
        data: {'email': email, 'otp': otp},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
      return response.data['data']['token'];
    });
  }

  @override
  Future<void> resetPassword(String newPassword, String token) async {
    return apiCallWrapper(() async {
      final response = await dio.put(
        '/auth/password/reset',
        data: {'new_password': newPassword, 'token': token},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    });
  }

  @override
  Future<void> changePassword(String newPassword, String oldPassword) async {
    return apiCallWrapper(() async {
      final response = await dio.put(
        '/auth/password/change',
        data: {'new_password': newPassword, 'old_password': oldPassword},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    });
  }

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    return apiCallWrapper(() async {
      final response = await dio.put(
        '/user/fcm-token',
        data: {'fcmToken': fcmToken},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update FCM token: ${response.statusCode}');
      }
    });
  }
}
