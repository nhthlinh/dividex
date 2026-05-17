import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/domain/auth_repository.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  String _normalizeName(String? name) {
    if (name == null) return '';

    return name
        .trim()
        .split(RegExp(r'\s+'))
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }

  Future<AuthResponseModel> call(UserModel user, String password) {
    // Chuẩn hóa dữ liệu trước khi gửi
    final normalizedUser = user.copyWith(
      fullName: _normalizeName(user.fullName),
      email: user.email?.trim().toLowerCase(),
      phoneNumber: user.phoneNumber?.trim().toLowerCase(),
    );
    return repository.register(normalizedUser, password);
  }
}

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponseModel> call(String email, String password) {
    email = email.trim().toLowerCase();
    password = password.trim();
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
    email = email.trim().toLowerCase();
    return repository.requestEmail(email);
  }

  Future<String> checkEmailExists(String email, String otp) {
    email = email.trim().toLowerCase();
    return repository.checkEmailExists(email, otp);
  }
}

@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> resetPassword(String newPassword, String token) {
    newPassword = newPassword.trim();
    return repository.resetPassword(newPassword, token);
  }

  Future<void> changePassword(String newPassword, String oldPassword) {
    newPassword = newPassword.trim();
    oldPassword = oldPassword.trim();
    return repository.changePassword(newPassword, oldPassword);
  }

  Future<void> updateFcmToken(String fcmToken) {
    fcmToken = fcmToken.trim();
    return repository.updateFcmToken(fcmToken);
  }
}
