import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/domain/auth_repository.dart';
import 'package:Dividex/features/auth/domain/usecase.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

import 'usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late RegisterUseCase registerUseCase;
  late LoginUseCase loginUseCase;
  late LogoutUseCase logoutUseCase;
  late EmailUseCase emailUseCase;
  late ResetPasswordUseCase resetPasswordUseCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockRepository);
    loginUseCase = LoginUseCase(mockRepository);
    logoutUseCase = LogoutUseCase(mockRepository);
    emailUseCase = EmailUseCase(mockRepository);
    resetPasswordUseCase = ResetPasswordUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    test('should call repository.register with correct parameters', () async {
      final user = UserModel(
        email: 'test@example.com',
        fullName: 'Test User',
      );
      final password = 'password123';
      final mockResponse = AuthResponseModel(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        user: user,
      );

      when(mockRepository.register(user, password))
          .thenAnswer((_) async => mockResponse);

      final result = await registerUseCase.call(user, password);

      expect(result.accessToken, 'access_token');
      expect(result.refreshToken, 'refresh_token');
      expect(result.user.email, 'test@example.com');
      verify(mockRepository.register(user, password)).called(1);
    });

    test('should propagate repository exceptions', () async {
      final user = UserModel(email: 'test@example.com');
      final password = 'password123';

      when(mockRepository.register(user, password))
          .thenThrow(Exception('Registration failed'));

      expect(
        () => registerUseCase.call(user, password),
        throwsException,
      );
    });
  });

  group('LoginUseCase', () {
    test('should call repository.login with correct parameters', () async {
      const email = 'test@example.com';
      const password = 'password123';
      final user = UserModel(email: email, fullName: 'Test User');
      final mockResponse = AuthResponseModel(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        user: user,
      );

      when(mockRepository.login(email, password))
          .thenAnswer((_) async => mockResponse);

      final result = await loginUseCase.call(email, password);

      expect(result.accessToken, 'access_token');
      expect(result.user.email, email);
      verify(mockRepository.login(email, password)).called(1);
    });

    test('should handle login failure', () async {
      const email = 'test@example.com';
      const password = 'wrongpassword';

      when(mockRepository.login(email, password))
          .thenThrow(Exception('Invalid credentials'));

      expect(
        () => loginUseCase.call(email, password),
        throwsException,
      );
    });
  });

  group('LogoutUseCase', () {
    test('should call repository.logout', () async {
      when(mockRepository.logout()).thenAnswer((_) async {});

      await logoutUseCase.call();

      verify(mockRepository.logout()).called(1);
    });

    test('should handle logout failure', () async {
      when(mockRepository.logout())
          .thenThrow(Exception('Logout failed'));

      expect(
        () => logoutUseCase.call(),
        throwsException,
      );
    });
  });

  group('EmailUseCase', () {
    test('should call repository.requestEmail', () async {
      const email = 'test@example.com';

      when(mockRepository.requestEmail(email)).thenAnswer((_) async {});

      await emailUseCase.requestEmail(email);

      verify(mockRepository.requestEmail(email)).called(1);
    });

    test('should call repository.checkEmailExists', () async {
      const email = 'test@example.com';
      const otp = '123456';
      const token = 'verification_token';

      when(mockRepository.checkEmailExists(email, otp))
          .thenAnswer((_) async => token);

      final result = await emailUseCase.checkEmailExists(email, otp);

      expect(result, token);
      verify(mockRepository.checkEmailExists(email, otp)).called(1);
    });

    test('should propagate email verification exceptions', () async {
      const email = 'test@example.com';
      const otp = 'invalid_otp';

      when(mockRepository.checkEmailExists(email, otp))
          .thenThrow(Exception('Invalid OTP'));

      expect(
        () => emailUseCase.checkEmailExists(email, otp),
        throwsException,
      );
    });
  });

  group('ResetPasswordUseCase', () {
    test('should call repository.resetPassword', () async {
      const newPassword = 'newpassword123';
      const token = 'reset_token';

      when(mockRepository.resetPassword(newPassword, token))
          .thenAnswer((_) async {});

      await resetPasswordUseCase.resetPassword(newPassword, token);

      verify(mockRepository.resetPassword(newPassword, token)).called(1);
    });

    test('should call repository.changePassword', () async {
      const newPassword = 'newpassword123';
      const oldPassword = 'oldpassword123';

      when(mockRepository.changePassword(newPassword, oldPassword))
          .thenAnswer((_) async {});

      await resetPasswordUseCase.changePassword(newPassword, oldPassword);

      verify(mockRepository.changePassword(newPassword, oldPassword))
          .called(1);
    });

    test('should call repository.updateFcmToken', () async {
      const fcmToken = 'fcm_token_123';

      when(mockRepository.updateFcmToken(fcmToken)).thenAnswer((_) async {});

      await resetPasswordUseCase.updateFcmToken(fcmToken);

      verify(mockRepository.updateFcmToken(fcmToken)).called(1);
    });

    test('should handle password reset failure', () async {
      const newPassword = 'newpassword123';
      const token = 'invalid_token';

      when(mockRepository.resetPassword(newPassword, token))
          .thenThrow(Exception('Invalid token'));

      expect(
        () => resetPasswordUseCase.resetPassword(newPassword, token),
        throwsException,
      );
    });
  });
}