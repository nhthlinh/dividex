import 'package:Dividex/features/auth/data/models/auth_credentials.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource);
  });

  group('AuthRepositoryImpl.login', () {
    test('returns token response on successful login', () async {
      const credentials = AuthCredentials(
        password: 'StrongPass@123', 
        email: '',
      );

      final token = AuthResponseModel(
        accessToken: 'access_token',
        refreshToken: 'refresh_token', 
        user: UserModel(id: 'u1', fullName: 'John Doe'), 
        countUserLogin: 2,
      );

      when(() => remoteDataSource.login(credentials.email, credentials.password))
          .thenAnswer((_) async => token);

      final result = await repository.login(credentials.email, credentials.password);

      expect(result.accessToken, 'access_token');
      expect(result.refreshToken, 'refresh_token');
      verify(() => remoteDataSource.login(credentials.email, credentials.password)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows exception when login fails', () async {
      const credentials = AuthCredentials(
        email: 'user@example.com',
        password: 'WrongPass',
      );

      when(() => remoteDataSource.login(credentials.email, credentials.password))
          .thenThrow(Exception('Invalid credentials'));

      expect(
        () => repository.login(credentials.email, credentials.password),
        throwsA(isA<Exception>()),
      );

      verify(() => remoteDataSource.login(credentials.email, credentials.password)).called(1);
    });
  });

  group('AuthRepositoryImpl.logout', () {
    test('delegates logout to remote datasource', () async {
      when(() => remoteDataSource.logout()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => remoteDataSource.logout()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows logout exception', () async {
      when(() => remoteDataSource.logout())
          .thenThrow(Exception('Logout failed'));

      expect(
        () => repository.logout(),
        throwsA(isA<Exception>()),
      );

      verify(() => remoteDataSource.logout()).called(1);
    });
  });

  group('AuthRepositoryImpl.resetPassword', () {
    test('delegates resetPassword with otp and new password', () async {
      when(() => remoteDataSource.resetPassword('123456', 'New@123'))
          .thenAnswer((_) async {});

      await repository.resetPassword('123456', 'New@123');

      verify(() => remoteDataSource.resetPassword('123456', 'New@123'))
          .called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows resetPassword failures', () async {
      when(() => remoteDataSource.resetPassword('000000', 'New@123'))
          .thenThrow(StateError('Invalid OTP'));

      expect(
        () => repository.resetPassword('000000', 'New@123'),
        throwsA(isA<StateError>()),
      );

      verify(() => remoteDataSource.resetPassword('000000', 'New@123'))
          .called(1);
    });
  });
}