import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> register(UserModel user, String password);
  Future<AuthResponseModel> login(String email, String password);
  Future<void> logout();
  Future<void> requestOtp(String email);
  Future<void> checkOtp(String email, String otp);
  Future<void> resetPassword(String email, String newPassword);
  Future<void> changePassword(String email, String newPassword, String oldPassword);

  Future<void> updateFcmToken(String fcmToken);
}
