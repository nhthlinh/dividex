import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource_impl.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late AuthRemoteDataSourceImpl datasource;

  setUp(() {
    dioClient = _MockDioClient();
    datasource = AuthRemoteDataSourceImpl(dioClient);
  });

  test('register posts mapped payload and returns AuthResponseModel', () async {
    when(
      () => dioClient.post(
        '/auth/register',
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/auth/register'),
        statusCode: 201,
        data: <String, dynamic>{
          'data': <String, dynamic>{
            'access_token': 'access',
            'refresh_token': 'refresh',
            'user': <String, dynamic>{
              'uid': 'u-1',
              'email': 'alice@test.com',
              'full_name': 'Alice',
            },
          },
        },
      ),
    );

    final result = await datasource.register(
      UserModel(
        id: 'u-1',
        email: 'alice@test.com',
        fullName: 'Alice',
        phoneNumber: '0123',
      ),
      'Secret123!',
    );

    expect(result.accessToken, 'access');
    expect(result.user.id, 'u-1');
    verify(
      () => dioClient.post(
        '/auth/register',
        data: <String, dynamic>{
          'full_name': 'Alice',
          'email': 'alice@test.com',
          'password': 'Secret123!',
          'phone_number': '0123',
        },
        queryParameters: null,
        options: null,
      ),
    ).called(1);
  });

  test('checkEmailExists posts otp and returns token', () async {
    when(
      () => dioClient.post(
        '/auth/password/otp',
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/auth/password/otp'),
        statusCode: 200,
        data: <String, dynamic>{
          'data': <String, dynamic>{'token': 'otp-token'},
        },
      ),
    );

    final token = await datasource.checkEmailExists('alice@test.com', '123456');

    expect(token, 'otp-token');
    verify(
      () => dioClient.post(
        '/auth/password/otp',
        data: <String, dynamic>{'email': 'alice@test.com', 'otp': '123456'},
        queryParameters: null,
        options: null,
      ),
    ).called(1);
  });
}
