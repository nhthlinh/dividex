import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/models/user_model.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart';
import 'package:Dividex/features/auth/domain/auth_repository.dart';
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
  Future<void> requestOtp(String email) {
    return remoteDataSource.requestOtp(email);
  }

  @override
  Future<void> checkOtp(String email, String otp) {
    return remoteDataSource.checkOtp(email, otp);
  }

  @override
  Future<void> resetPassword(String email, String newPassword) {
    return remoteDataSource.resetPassword(email, newPassword);
  }

  @override
  Future<void> changePassword(String email, String newPassword, String oldPassword) {
    return remoteDataSource.changePassword(email, newPassword, oldPassword);
  }

  @override
  Future<void> updateFcmToken(String fcmToken) {
    return remoteDataSource.updateFcmToken(fcmToken);
  }
}
