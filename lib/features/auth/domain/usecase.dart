import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/models/user_model.dart';
import 'package:Dividex/features/auth/domain/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponseModel> call(UserModel user, String password) {
    return repository.register(user, password);
  }
}

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponseModel> call(String email, String password) {
    return repository.login(email, password);
  }
}

@injectable
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

@injectable
class OtpUseCase {
  final AuthRepository repository;

  OtpUseCase(this.repository);

  Future<void> requestOtp(String email) {
    return repository.requestOtp(email);
  }

  Future<void> checkOtp(String email, String otp) {
    return repository.checkOtp(email, otp);
  }
}

@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> resetPassword(String email, String newPassword) {
    return repository.resetPassword(email, newPassword);
  }

  Future<void> changePassword(String email, String newPassword, String oldPassword) {
    return repository.changePassword(email, newPassword, oldPassword);
  }

  Future<void> updateFcmToken(String fcmToken) {
    return repository.updateFcmToken(fcmToken);
  }
}