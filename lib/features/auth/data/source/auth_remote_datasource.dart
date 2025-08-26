

import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(UserModel user, String password);
  Future<AuthResponseModel> login(String email, String password);
  Future<void> logout();
  Future<void> requestEmail(String email);
  Future<void> resetPassword(String email, String newPassword, String token);
  Future<void> changePassword(String email, String newPassword, String oldPassword);

  Future<void> updateFcmToken(String fcmToken);
}
