import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/user/data/source/user_remote_datasource_impl.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late UserRemoteDatasourceImpl datasource;

  setUp(() {
    dioClient = _MockDioClient();
    datasource = UserRemoteDatasourceImpl(dioClient);
  });

  group('UserRemoteDatasourceImpl.getUserForCreateGroup', () {
    test('returns PagingModel when content is not empty', () async {
      when(
        () => dioClient.get(
          '/friends',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/friends'),
          data: <String, dynamic>{
            'data': {
              "content": [
                {
                  "friend_uid": "u1",
                  "full_name": "string",
                  "avatar_url": {
                    "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                    "original_name": "string",
                    "public_url": "string",
                  },
                  "friendship_uid": "ec9d6425-03b8-4d3d-97cf-4d806c218243",
                  "start": "2019-08-24T14:15:22Z",
                },
              ],
              "current_page": 1,
              "page_size": 1,
              "total_rows": 1,
              "total_pages": 1,
            },
          },
        ),
      );

      final result = await datasource.getUserForCreateGroup('uid', 1, 10, null);

      expect(result.data.length, 1);
      expect(result.data.first.id, 'u1');
      verify(
        () => dioClient.get(
          '/friends',
          queryParameters: {
            'page': 1,
            'page_size': 10,
            'search': null,
            'order_by': 'updated_at',
          },
        ),
      ).called(1);
    });

    test('throws exception when content is empty', () async {
      when(
        () => dioClient.get(
          '/friends',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/friends'),
          data: <String, dynamic>{
            'data': {
              "content": [],
              "current_page": 1,
              "page_size": 1,
              "total_rows": 1,
              "total_pages": 1,
            },
          },
        ),
      );

      expect(
        () => datasource.getUserForCreateGroup('uid', 1, 10, null),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to load users'),
          ),
        ),
      );
    });

    test('includes search query in request parameters', () async {
      when(
        () => dioClient.get(
          '/friends',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/friends'),
          data: <String, dynamic>{
            'data': {
              "content": [
                {
                  "friend_uid": "u1",
                  "full_name": "string",
                  "avatar_url": {
                    "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                    "original_name": "string",
                    "public_url": "string",
                  },
                  "friendship_uid": "ec9d6425-03b8-4d3d-97cf-4d806c218243",
                  "start": "2019-08-24T14:15:22Z",
                },
              ],
              "current_page": 1,
              "page_size": 1,
              "total_rows": 1,
              "total_pages": 1,
            },
          },
        ),
      );

      await datasource.getUserForCreateGroup('uid', 2, 20, 'search_term');

      verify(
        () => dioClient.get(
          '/friends',
          queryParameters: {
            'page': 2,
            'page_size': 20,
            'search': 'search_term',
            'order_by': 'updated_at',
          },
          data: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('UserRemoteDatasourceImpl.getUserForCreateEvent', () {
    test('maps nested user objects from response', () async {
      when(
        () => dioClient.get(
          '/groups/group1/members',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/groups/group1/members'),
          data: <String, dynamic>{
            'data': {
              "content": [
                {
                  "group_members_uid": "fbb07d7a-97e0-4f23-b6a1-df43e7e4a623",
                  "user": {
                    "full_name": "Charlie",
                    "email": "Charlie",
                    "balance": 0,
                    "avatar_url": {
                      "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                      "original_name": "string",
                      "public_url": "string",
                    },
                    "uid": "u1",
                  },
                  "joined_at": "2019-08-24T14:15:22Z",
                },
              ],
              "current_page": 0,
              "page_size": 0,
              "total_rows": 0,
              "total_pages": 0,
            },
          },
        ),
      );

      final result = await datasource.getUserForCreateEvent(
        'group1',
        1,
        10,
        null,
      );

      expect(result.data.length, 1);
      expect(result.data.first.id, 'u1');
      expect(result.data.first.fullName, 'Charlie');
    });

    test('throws exception when content is empty', () async {
      when(
        () => dioClient.get(
          '/groups/group1/members',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/groups/group1/members'),
          data: <String, dynamic>{
            'data': {
              "content": [],
              "current_page": 0,
              "page_size": 0,
              "total_rows": 0,
              "total_pages": 0,
            },
          },
        ),
      );

      expect(
        () => datasource.getUserForCreateEvent('group1', 1, 10, null),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to load users'),
          ),
        ),
      );
    });
  });

  group('UserRemoteDatasourceImpl.getUserForCreateExpense', () {
    test('uses default orderBy and sortType when not provided', () async {
      when(
        () => dioClient.get(
          '/events/evt1/members',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/events/evt1/members'),
          data: <String, dynamic>{
            'data': {
              "content": [
                {
                  "group_members_uid": "fbb07d7a-97e0-4f23-b6a1-df43e7e4a623",
                  "user": {
                    "full_name": "Charlie",
                    "email": "Charlie",
                    "balance": 0,
                    "avatar_url": {
                      "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                      "original_name": "string",
                      "public_url": "string",
                    },
                    "uid": "u1",
                  },
                  "joined_at": "2019-08-24T14:15:22Z",
                },
              ],
              "current_page": 0,
              "page_size": 0,
              "total_rows": 0,
              "total_pages": 0,
            },
          },
        ),
      );

      await datasource.getUserForCreateExpense('evt1', 1, 10, null);

      verify(
        () => dioClient.get(
          '/events/evt1/members',
          queryParameters: {
            'page': 1,
            'page_size': 10,
            'search': null,
            'order_by': 'full_name',
            'sort_type': 'asc',
          },
          data: null,
          options: null,
        ),
      ).called(1);
    });

    test('uses custom orderBy and sortType when provided', () async {
      when(
        () => dioClient.get(
          '/events/evt1/members',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/events/evt1/members'),
          data: <String, dynamic>{
            'data': {
              "content": [
                {
                  "event_member_uid": "fd33600e-b20e-4418-a6f3-859772e8e798",
                  "user": {
                    "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                    "full_name": "string",
                    "avatar": {
                      "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                      "original_name": "string",
                      "public_url": "string",
                    },
                    "email": "string",
                  },
                  "status": "string",
                },
              ],
              "current_page": 0,
              "page_size": 0,
              "total_rows": 0,
              "total_pages": 0,
            },
          },
        ),
      );

      await datasource.getUserForCreateExpense(
        'evt1',
        1,
        10,
        null,
        orderBy: 'created_at',
        sortType: 'desc',
      );

      verify(
        () => dioClient.get(
          '/events/evt1/members',
          queryParameters: {
            'page': 1,
            'page_size': 10,
            'search': null,
            'order_by': 'created_at',
            'sort_type': 'desc',
          },
          data: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('UserRemoteDatasourceImpl.getMe', () {
    test('returns UserModel from response data', () async {
      when(
        () => dioClient.get(
          '/auth/me',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          data: {
            'data': {
              'uid': 'me-1',
              'full_name': 'Frank',
              'phone_number': '0909999999',
            }
          },
        ),
      );

      final result = await datasource.getMe();

      expect(result.id, 'me-1');
      expect(result.fullName, 'Frank');
    });
  });

  group('UserRemoteDatasourceImpl.reviewApp', () {
    test('sends stars as rate in request body', () async {
      when(
        () => dioClient.put(
          '/users/review',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/review'),
          data: {},
        ),
      );

      await datasource.reviewApp(5);

      verify(
        () => dioClient.put(
          '/users/review',
          data: {'rate': 5},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('UserRemoteDatasourceImpl.updateMe', () {
    test('sends name to auth/me endpoint', () async {
      when(
        () => dioClient.put(
          '/auth/me',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          data: {},
        ),
      );

      await datasource.updateMe('New Name', CurrencyEnum.vnd);

      verify(
        () => dioClient.put(
          '/auth/me',
          data: {'full_name': 'New Name'},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('UserRemoteDatasourceImpl.createPin', () {
    test('posts pin to auth/pin endpoint', () async {
      when(
        () => dioClient.post(
          '/auth/pin',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/pin'),
          data: {},
        ),
      );

      await datasource.createPin('123456');

      verify(
        () => dioClient.post(
          '/auth/pin',
          data: {'pin': '123456'},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('UserRemoteDatasourceImpl.updatePin', () {
    test('sends old and new pins in request', () async {
      when(
        () => dioClient.put(
          '/auth/pin',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/pin'),
          data: {},
        ),
      );

      await datasource.updatePin('111111', '222222');

      verify(
        () => dioClient.put(
          '/auth/pin',
          data: {'old_pin': '111111', 'new_pin': '222222'},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });
}
