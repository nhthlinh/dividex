import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/friend/data/source/friend_remote_datasource_impl.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late FriendRemoteDatasourceImpl datasource;

  setUp(() {
    dioClient = _MockDioClient();
    datasource = FriendRemoteDatasourceImpl(dioClient);
  });

  group('FriendRemoteDatasourceImpl.getFriends', () {
    test('returns paging model and maps friends', () async {
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
            'data': <String, dynamic>{
              'content': <Map<String, dynamic>>[
                <String, dynamic>{
                  'friend_uid': 'f-1',
                  'full_name': 'Alice',
                  'friendship_uid': 'fs-1',
                  'status': 'ACCEPTED',
                },
              ],
              'current_page': 1,
              'total_pages': 2,
              'total_rows': 8,
            },
          },
        ),
      );

      final result = await datasource.getFriends('alice', 1, 5);

      expect(result.page, 1);
      expect(result.totalPage, 2);
      expect(result.totalItems, 8);
      expect(result.data.first.friendUid, 'f-1');
      final verification = verify(
        () => dioClient.get(
          '/friends',
          queryParameters: captureAny(named: 'queryParameters'),
          data: null,
          options: null,
        ),
      );
      verification.called(1);
      final captured = verification.captured.single as Map<String, dynamic>;
      expect(captured['search'], 'alice');
      expect(captured['page'], 1);
      expect(captured['page_size'], 5);
      expect(captured['order_by'], 'updated_at');
    });

    // test('throws when content is empty', () async {
    //   when(
    //     () => dioClient.get(
    //       '/friends',
    //       queryParameters: any(named: 'queryParameters'),
    //       data: any(named: 'data'),
    //       options: any(named: 'options'),
    //     ),
    //   ).thenAnswer(
    //     (_) async => Response(
    //       requestOptions: RequestOptions(path: '/friends'),
    //       data: <String, dynamic>{
    //         'data': <String, dynamic>{
    //           'content': <Map<String, dynamic>>[],
    //           'current_page': 1,
    //           'total_pages': 1,
    //           'total_rows': 0,
    //         },
    //       },
    //     ),
    //   );

    //   expect(
    //     () => datasource.getFriends(null, 1, 5),
    //     throwsA(
    //       isA<Exception>().having(
    //         (e) => e.toString(),
    //         'message',
    //         contains('Failed to load friends'),
    //       ),
    //     ),
    //   );
    // });
  
  });

  group('FriendRemoteDatasourceImpl.getFriendRequests', () {
    test('sends received request_type in queryParameters', () async {
      when(
        () => dioClient.get(
          '/friends/request',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/friends/request'),
          data: <String, dynamic>{
            'data': <String, dynamic>{
              'content': <Map<String, dynamic>>[
                <String, dynamic>{
                  'friend_uid': 'f-2',
                  'full_name': 'Bob',
                },
              ],
              'current_page': 1,
              'total_pages': 1,
              'total_rows': 1,
            },
          },
        ),
      );

      await datasource.getFriendRequests(FriendRequestType.received, 'bo', 2, 10);

      final captured =
          verify(
                () => dioClient.get(
                  '/friends/request',
                  queryParameters: captureAny(named: 'queryParameters'),
                  data: null,
                  options: null,
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['request_type'], 'Received');
      expect(captured['search'], 'bo');
      expect(captured['page'], 2);
      expect(captured['page_size'], 10);
    });
  });
}
