import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:Dividex/features/auth/domain/usecase.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';


import 'auth_bloc_test.mocks.dart';

@GenerateMocks(
  [RegisterUseCase, LoginUseCase, LogoutUseCase, EmailUseCase, ResetPasswordUseCase],
  customMocks: [MockSpec<HiveService>()],
)
void main() {
  group('AuthBloc', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLoginUseCase mockLoginUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockEmailUseCase mockEmailUseCase;
    late MockResetPasswordUseCase mockResetPasswordUseCase;

    setUp(() {
      mockRegisterUseCase = MockRegisterUseCase();
      mockLoginUseCase = MockLoginUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockEmailUseCase = MockEmailUseCase();
      mockResetPasswordUseCase = MockResetPasswordUseCase();
    });

    group('AuthRegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when registration is successful',
        build: () {
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

          when(mockRegisterUseCase.call(user, password))
              .thenAnswer((_) async => mockResponse);

          return AuthBloc();
        },
        act: (bloc) {
          final user = UserModel(
            email: 'test@example.com',
            fullName: 'Test User',
          );
          bloc.add(AuthRegisterRequested(userData: user, password: 'password123'));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when registration fails',
        build: () {
          final user = UserModel(
            email: 'test@example.com',
            fullName: 'Test User',
          );
          when(mockRegisterUseCase.call(user, 'password123'))
              .thenThrow(Exception('Email already exists'));

          return AuthBloc();
        },
        act: (bloc) {
          final user = UserModel(
            email: 'test@example.com',
            fullName: 'Test User',
          );
          bloc.add(AuthRegisterRequested(userData: user, password: 'password123'));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login is successful',
        build: () {
          const email = 'test@example.com';
          const password = 'password123';
          final user = UserModel(
            email: email,
            fullName: 'Test User',
          );
          final mockResponse = AuthResponseModel(
            accessToken: 'access_token',
            refreshToken: 'refresh_token',
            user: user,
          );

          when(mockLoginUseCase.call(email, password))
              .thenAnswer((_) async => mockResponse);

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when login fails with invalid credentials',
        build: () {
          const email = 'test@example.com';
          const password = 'wrongpassword';

          when(mockLoginUseCase.call(email, password))
              .thenThrow(Exception('Email or password incorrect'));

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthLoginRequested(
            email: 'test@example.com',
            password: 'wrongpassword',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout is successful',
        build: () {
          when(mockLogoutUseCase.call()).thenAnswer((_) async => {});

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthLogoutRequested());
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout fails',
        build: () {
          when(mockLogoutUseCase.call())
              .thenThrow(Exception('Logout failed'));

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthLogoutRequested());
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when token exists',
        build: () => AuthBloc(),
        act: (bloc) {
          bloc.add(const AuthCheckRequested());
        },
        expect: () => [
          isA<AuthLoading>(),
          anyOf(isA<AuthAuthenticated>(), isA<AuthUnauthenticated>()),
        ],
      );
    });

    group('AuthEmailRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthEmailSent] when email request is successful',
        build: () {
          const email = 'test@example.com';

          when(mockEmailUseCase.requestEmail(email))
              .thenAnswer((_) async => {});

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthEmailRequested(email: 'test@example.com'));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthEmailSent>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when email request fails with user not found',
        build: () {
          const email = 'nonexistent@example.com';

          when(mockEmailUseCase.requestEmail(email))
              .thenThrow(Exception('User not found'));

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthEmailRequested(email: 'nonexistent@example.com'));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('AuthOtpSubmitted', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthEmailChecked] when OTP is valid',
        build: () {
          const email = 'test@example.com';
          const otp = '123456';
          const token = 'reset_token';

          when(mockEmailUseCase.checkEmailExists(email, otp))
              .thenAnswer((_) async => token);

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthOtpSubmitted(
            email: 'test@example.com',
            otp: '123456',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthEmailChecked>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when OTP is invalid',
        build: () {
          const email = 'test@example.com';
          const otp = 'invalid_otp';

          when(mockEmailUseCase.checkEmailExists(email, otp))
              .thenThrow(Exception('Invalid or expired OTP'));

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthOtpSubmitted(
            email: 'test@example.com',
            otp: 'invalid_otp',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('AuthResetPasswordRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when password reset is successful',
        build: () {
          const newPassword = 'newpassword123';
          const token = 'reset_token';

          when(mockResetPasswordUseCase.resetPassword(newPassword, token))
              .thenAnswer((_) async => {});

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthResetPasswordRequested(
            newPassword: 'newpassword123',
            token: 'reset_token',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when password reset fails',
        build: () {
          const newPassword = 'newpassword123';
          const token = 'invalid_token';

          when(mockResetPasswordUseCase.resetPassword(newPassword, token))
              .thenThrow(Exception('Invalid or expired OTP'));

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthResetPasswordRequested(
            newPassword: 'newpassword123',
            token: 'invalid_token',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('AuthChangePasswordRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when password change is successful',
        build: () {
          const newPassword = 'newpassword123';
          const oldPassword = 'oldpassword123';

          when(mockResetPasswordUseCase.changePassword(newPassword, oldPassword))
              .thenAnswer((_) async => {});

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthChangePasswordRequested(
            newPassword: 'newpassword123',
            oldPassword: 'oldpassword123',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when old password is incorrect',
        build: () {
          const newPassword = 'newpassword123';
          const oldPassword = 'wrongpassword';

          when(mockResetPasswordUseCase.changePassword(newPassword, oldPassword))
              .thenThrow(Exception('Password incorrect'));

          return AuthBloc();
        },
        act: (bloc) {
          bloc.add(const AuthChangePasswordRequested(
            newPassword: 'newpassword123',
            oldPassword: 'wrongpassword',
          ));
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
      );
    });
  });
}
