import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource_impl.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    authRemoteDataSource = AuthRemoteDataSourceImpl(mockDioClient);
  });

  

  group('AuthRemoteDataSourceImpl', () {
    group('register', () {
      final testUser = UserModel(
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '1234567890',
      );
      const testPassword = 'password123';
      final testResponseData = Response(
        data: {
          'data': {
            'access_token': 'test_token',
            'refresh_token': 'refresh_token',
            'user': {
              'full_name': 'Test User',
              'email': 'test@example.com',
              'phone_number': '1234567890',
            },
          }
        },
        statusCode: 201,
        requestOptions: RequestOptions(path: '/auth/register'),
      );


      test('should return AuthResponseModel when register is successful',
          () async {
        // Arrange
        final mockResponse = Response(
          data: testResponseData.data,
          statusCode: testResponseData.statusCode,
          requestOptions: testResponseData.requestOptions,
        );
        when(() => mockDioClient.post(
              '/auth/register',
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);


        // Act
        final result = await authRemoteDataSource.register(testUser, testPassword);

        // Assert
        expect(result, isA<AuthResponseModel>());
        verify(() => mockDioClient.post(
              '/auth/register',
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
        )).called(1);

      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/register'),
        );
        when(() => mockDioClient.post('/auth/register', data: any(named: 'data')))
            .thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.register(testUser, testPassword),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception with DioException error message',
          () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          response: Response(
            data: {
              'message': 'Email already exists',
              'message_code': 'EMAIL_EXISTS',
            },
            statusCode: 409,
            requestOptions: RequestOptions(path: '/auth/register'),
          ),
        );
        when(() => mockDioClient.post('/auth/register', data: any(named: 'data')))
            .thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.register(testUser, testPassword),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('EMAIL_EXISTS'),
          )),
        );
      });

      test('should throw network error exception when no response', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          message: 'Connection timeout',
        );
        when(() => mockDioClient.post('/auth/register', data: any(named: 'data')))
            .thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.register(testUser, testPassword),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Network error'),
          )),
        );
      });
    });

    group('login', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';
      final testResponseData = {
        'access_token': 'test_token',
        'refresh_token': 'refresh_token',
        'user': {
          'full_name': 'Test User',
          'email': 'test@example.com',
          'phone_number': '1234567890',
        },
      };

      test('should return AuthResponseModel when login is successful', () async {
        // Arrange
        final mockResponse = Response(
          data: {'data': testResponseData},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );
        when(() => mockDioClient.post(
          '/auth/login',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteDataSource.login(testEmail, testPassword);

        // Assert
        expect(result, isA<AuthResponseModel>());
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 401,
          requestOptions: RequestOptions(path: '/auth/login'),
        );
        when(() => mockDioClient.post(
          '/auth/login',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.login(testEmail, testPassword),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception with error message from response', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            data: {
              'message': 'Invalid credentials',
              'message_code': 'INVALID_CREDENTIALS',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/login'),
          ),
        );
        when(() => mockDioClient.post(
          '/auth/login',
          data: any(named: 'data'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.login(testEmail, testPassword),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('INVALID_CREDENTIALS'),
          )),
        );
      });
    });

    group('logout', () {
      test('should successfully logout', () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/logout'),
        );
        when(() => mockDioClient.put('/auth/logout'))
            .thenAnswer((_) async => mockResponse);

        // Act
        await authRemoteDataSource.logout();

        // Assert
        verify(() => mockDioClient.put('/auth/logout')).called(1);
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 500,
          requestOptions: RequestOptions(path: '/auth/logout'),
        );
        when(() => mockDioClient.put('/auth/logout'))
            .thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.logout(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('requestEmail', () {
      const testEmail = 'test@example.com';

      test('should successfully request email for password reset', () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/password/forget'),
        );
        when(() => mockDioClient.post(
          '/auth/password/forget',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        await authRemoteDataSource.requestEmail(testEmail);

        // Assert
        verify(() => mockDioClient.post(
          '/auth/password/forget',
          data: any(named: 'data'),
        )).called(1);
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 404,
          requestOptions: RequestOptions(path: '/auth/password/forget'),
        );
        when(() => mockDioClient.post(
          '/auth/password/forget',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.requestEmail(testEmail),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception with error message from response', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/password/forget'),
          response: Response(
            data: {
              'message': 'Email not found',
              'message_code': 'EMAIL_NOT_FOUND',
            },
            statusCode: 404,
            requestOptions: RequestOptions(path: '/auth/password/forget'),
          ),
        );
        when(() => mockDioClient.post(
          '/auth/password/forget',
          data: any(named: 'data'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.requestEmail(testEmail),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('EMAIL_NOT_FOUND'),
          )),
        );
      });
    });

    group('checkEmailExists', () {
      const testEmail = 'test@example.com';
      const testOtp = '123456';
      const testToken = 'reset_token';

      test('should return token when OTP verification is successful', () async {
        // Arrange
        final mockResponse = Response(
          data: {'data': {'token': testToken}},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/password/otp'),
        );
        when(() => mockDioClient.post(
          '/auth/password/otp',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteDataSource.checkEmailExists(
          testEmail,
          testOtp,
        );

        // Assert
        expect(result, equals(testToken));
        verify(() => mockDioClient.post(
          '/auth/password/otp',
          data: any(named: 'data'),
        )).called(1);
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/password/otp'),
        );
        when(() => mockDioClient.post(
          '/auth/password/otp',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.checkEmailExists(testEmail, testOtp),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception with error message from response', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/password/otp'),
          response: Response(
            data: {
              'message': 'Invalid OTP',
              'message_code': 'INVALID_OTP',
            },
            statusCode: 400,
            requestOptions: RequestOptions(path: '/auth/password/otp'),
          ),
        );
        when(() => mockDioClient.post(
          '/auth/password/otp',
          data: any(named: 'data'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.checkEmailExists(testEmail, testOtp),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('INVALID_OTP'),
          )),
        );
      });
    });

    group('resetPassword', () {
      const testNewPassword = 'newPassword123';
      const testToken = 'reset_token';

      test('should successfully reset password', () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/password/reset'),
        );
        when(() => mockDioClient.put(
          '/auth/password/reset',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        await authRemoteDataSource.resetPassword(testNewPassword, testToken);

        // Assert
        verify(() => mockDioClient.put(
          '/auth/password/reset',
          data: any(named: 'data'),
        )).called(1);
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/password/reset'),
        );
        when(() => mockDioClient.put(
          '/auth/password/reset',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.resetPassword(testNewPassword, testToken),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception with error message from response', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/password/reset'),
          response: Response(
            data: {
              'message': 'Invalid token',
              'message_code': 'INVALID_TOKEN',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/password/reset'),
          ),
        );
        when(() => mockDioClient.put(
          '/auth/password/reset',
          data: any(named: 'data'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.resetPassword(testNewPassword, testToken),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('INVALID_TOKEN'),
          )),
        );
      });
    });

    group('changePassword', () {
      const testNewPassword = 'newPassword123';
      const testOldPassword = 'oldPassword123';

      test('should successfully change password', () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/password/change'),
        );
        when(() => mockDioClient.put(
          '/auth/password/change',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        await authRemoteDataSource.changePassword(
          testNewPassword,
          testOldPassword,
        );

        // Assert
        verify(() => mockDioClient.put(
          '/auth/password/change',
          data: any(named: 'data'),
        )).called(1);
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 401,
          requestOptions: RequestOptions(path: '/auth/password/change'),
        );
        when(() => mockDioClient.put(
          '/auth/password/change',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.changePassword(
            testNewPassword,
            testOldPassword,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception with error message from response', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/auth/password/change'),
          response: Response(
            data: {
              'message': 'Current password is incorrect',
              'message_code': 'INCORRECT_PASSWORD',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/password/change'),
          ),
        );
        when(() => mockDioClient.put(
          '/auth/password/change',
          data: any(named: 'data'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => authRemoteDataSource.changePassword(
            testNewPassword,
            testOldPassword,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('INCORRECT_PASSWORD'),
          )),
        );
      });
    });

    group('updateFcmToken', () {
      const testFcmToken = 'fcm_token_12345';

      test('should successfully update FCM token', () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/fcm-token'),
        );
        when(() => mockDioClient.put(
          '/user/fcm-token',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        await authRemoteDataSource.updateFcmToken(testFcmToken);

        // Assert
        verify(() => mockDioClient.put(
          '/user/fcm-token',
          data: any(named: 'data'),
        )).called(1);
      });

      test('should throw exception when status code is not 200 or 201',
          () async {
        // Arrange
        final mockResponse = Response(
          data: {},
          statusCode: 500,
          requestOptions: RequestOptions(path: '/user/fcm-token'),
        );
        when(() => mockDioClient.put(
          '/user/fcm-token',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => authRemoteDataSource.updateFcmToken(testFcmToken),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
