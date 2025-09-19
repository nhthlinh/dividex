import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart';
import 'package:Dividex/features/auth/domain/auth_repository.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthResponseModel> register(UserModel user, String password) {
    return remoteDataSource.register(user, password);
  }
  
  @override
  Future<AuthResponseModel> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }
  
  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> requestEmail(String email) {
    return remoteDataSource.requestEmail(email);
  }

  @override
  Future<String> checkEmailExists(String email, String otp) {
    return remoteDataSource.checkEmailExists(email, otp);
  }

  @override
  Future<void> resetPassword(String newPassword, String token) {
    return remoteDataSource.resetPassword(newPassword, token);
  }

  @override
  Future<void> changePassword(String newPassword, String oldPassword) {
    return remoteDataSource.changePassword(newPassword, oldPassword);
  }

  @override
  Future<void> updateFcmToken(String fcmToken) {
    return remoteDataSource.updateFcmToken(fcmToken);
  }
}
