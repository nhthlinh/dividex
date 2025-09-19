import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/domain/auth_repository.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
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
class EmailUseCase {
  final AuthRepository repository;

  EmailUseCase(this.repository);

  Future<void> requestEmail(String email) {
    return repository.requestEmail(email);
  }

  Future<String> checkEmailExists(String email, String otp) {
    return repository.checkEmailExists(email, otp);
  } 
}

@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> resetPassword(String newPassword, String token) {
    return repository.resetPassword(newPassword, token);
  }

  Future<void> changePassword(String newPassword, String oldPassword) {
    return repository.changePassword(newPassword, oldPassword);
  }

  Future<void> updateFcmToken(String fcmToken) {
    return repository.updateFcmToken(fcmToken);
  }
}