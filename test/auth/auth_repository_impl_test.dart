import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:mockito/annotations.dart';

import 'auth_repository_impl_test.mocks.dart';


@GenerateMocks([AuthRemoteDataSource])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  group('AuthRepositoryImpl', () {
    test('should delegate register to remote data source', () async {
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

      when(mockRemoteDataSource.register(user, password))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.register(user, password);

      expect(result.accessToken, 'access_token');
      verify(mockRemoteDataSource.register(user, password)).called(1);
    });

    test('should delegate login to remote data source', () async {
      const email = 'test@example.com';
      const password = 'password123';
      final user = UserModel(email: email);
      final mockResponse = AuthResponseModel(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        user: user,
      );

      when(mockRemoteDataSource.login(email, password))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.login(email, password);

      expect(result.accessToken, 'access_token');
      verify(mockRemoteDataSource.login(email, password)).called(1);
    });

    test('should delegate logout to remote data source', () async {
      when(mockRemoteDataSource.logout()).thenAnswer((_) async {});

      await repository.logout();

      verify(mockRemoteDataSource.logout()).called(1);
    });

    test('should delegate requestEmail to remote data source', () async {
      const email = 'test@example.com';

      when(mockRemoteDataSource.requestEmail(email)).thenAnswer((_) async {});

      await repository.requestEmail(email);

      verify(mockRemoteDataSource.requestEmail(email)).called(1);
    });

    test('should delegate checkEmailExists to remote data source', () async {
      const email = 'test@example.com';
      const otp = '123456';
      const token = 'verification_token';

      when(mockRemoteDataSource.checkEmailExists(email, otp))
          .thenAnswer((_) async => token);

      final result = await repository.checkEmailExists(email, otp);

      expect(result, token);
      verify(mockRemoteDataSource.checkEmailExists(email, otp)).called(1);
    });

    test('should delegate resetPassword to remote data source', () async {
      const newPassword = 'newpassword123';
      const token = 'reset_token';

      when(mockRemoteDataSource.resetPassword(newPassword, token))
          .thenAnswer((_) async {});

      await repository.resetPassword(newPassword, token);

      verify(mockRemoteDataSource.resetPassword(newPassword, token))
          .called(1);
    });

    test('should delegate changePassword to remote data source', () async {
      const newPassword = 'newpassword123';
      const oldPassword = 'oldpassword123';

      when(mockRemoteDataSource.changePassword(newPassword, oldPassword))
          .thenAnswer((_) async {});

      await repository.changePassword(newPassword, oldPassword);

      verify(mockRemoteDataSource.changePassword(newPassword, oldPassword))
          .called(1);
    });

    test('should delegate updateFcmToken to remote data source', () async {
      const fcmToken = 'fcm_token_123';

      when(mockRemoteDataSource.updateFcmToken(fcmToken))
          .thenAnswer((_) async {});

      await repository.updateFcmToken(fcmToken);

      verify(mockRemoteDataSource.updateFcmToken(fcmToken)).called(1);
    });

    test('should propagate exceptions from remote data source', () async {
      const email = 'test@example.com';
      const password = 'password123';

      when(mockRemoteDataSource.login(email, password))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.login(email, password),
        throwsException,
      );
    });
  });
}