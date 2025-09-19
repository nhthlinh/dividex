import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> register(UserModel user, String password);
  Future<AuthResponseModel> login(String email, String password);
  Future<void> logout();
  Future<void> requestEmail(String email);
  Future<String> checkEmailExists(String email, String otp);
  Future<void> resetPassword(String newPassword, String token);
  Future<void> changePassword(String newPassword, String oldPassword);

  Future<void> updateFcmToken(String fcmToken);
}
