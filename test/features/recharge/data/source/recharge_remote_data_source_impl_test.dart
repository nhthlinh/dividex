import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/recharge/data/source/recharge_remote_data_source_impl.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late RechargeRemoteDatasourceImpl datasource;

  setUp(() {
    dioClient = _MockDioClient();
    datasource = RechargeRemoteDatasourceImpl(dioClient);
  });

  group('RechargeRemoteDatasourceImpl.deposit', () {
    test('returns PayOSResponseModel from response', () async {
      when(
        () => dioClient.post(
          '/payment/payos/create-link',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payment/payos/create-link'),
          data: {
            'data': {
              "order_code": 0,
              "qr_code": "0202020",
              "payment_link_id": "string",
            },
          },
        ),
      );

      final result = await datasource.deposit(100.0, 'VND');

      expect(result.qrCode, '0202020');
      verify(
        () => dioClient.post(
          '/payment/payos/create-link',
          data: {
            'amount': 100.0,
            'currency': 'VND',
            'description': 'Deposit 100.0 VND',
            'item_name': 'Deposit 100.0 VND',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });

    test('builds description with amount and currency', () async {
      when(
        () => dioClient.post(
          '/payment/payos/create-link',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payment/payos/create-link'),
          data: {
            'data': {
              "order_code": 0,
              "qr_code": "string",
              "payment_link_id": "string",
            },
          },
        ),
      );

      await datasource.deposit(250.5, 'VND');

      verify(
        () => dioClient.post(
          '/payment/payos/create-link',
          data: {
            'amount': 250.5,
            'currency': 'VND',
            'description': 'Deposit 250.5 VND',
            'item_name': 'Deposit 250.5 VND',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('RechargeRemoteDatasourceImpl.createDeposit', () {
    test('posts deposit params to endpoint', () async {
      when(
        () => dioClient.post(
          '/payment/deposit',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payment/deposit'),
          data: {},
        ),
      );

      await datasource.createDeposit(500.0, 'VND', 'VCB');

      verify(
        () => dioClient.post(
          '/payment/deposit',
          data: {'amount': 500.0, 'currency': 'VND', 'bank_code': 'VCB'},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('RechargeRemoteDatasourceImpl.createWithdraw', () {
    test('converts amount to int and posts withdraw data', () async {
      when(
        () => dioClient.post(
          '/wallet/withdraw',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/withdraw'),
          data: {},
        ),
      );

      await datasource.createWithdraw(1000.75, '1234567890', 'ACB');

      verify(
        () => dioClient.post(
          '/wallet/withdraw',
          data: {
            'amount': 1000,
            'account_number': '1234567890',
            'bank_name': 'ACB',
            'description': 'Withdraw 1000.75',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('RechargeRemoteDatasourceImpl.getWallet', () {
    test('formats balance with currency', () async {
      when(
        () => dioClient.get(
          '/wallet',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet'),
          data: {
            'data': {'balance': 5000.123, 'currency': 'VND'},
          },
        ),
      );

      final result = await datasource.getWallet();

      expect(result.endsWith('VND'), true);
      expect(result.contains('5.000,12'), true);
    });

    test('returns 0.00 when balance parsing fails', () async {
      when(
        () => dioClient.get(
          '/wallet',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet'),
          data: {
            'data': {'balance': 'invalid', 'currency': 'VND'},
          },
        ),
      );

      final result = await datasource.getWallet();

      expect(result, '0.00 VND');
    });

    test('uses empty string when currency is missing', () async {
      when(
        () => dioClient.get(
          '/wallet',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet'),
          data: {
            'data': {'balance': 1000.0},
          },
        ),
      );

      final result = await datasource.getWallet();

      expect(result.endsWith(' '), true);
    });
  });

  group('RechargeRemoteDatasourceImpl.getDepositDetail', () {
    test('fetches and maps deposit transaction', () async {
      when(
        () => dioClient.get(
          '/wallet/dep1/deposit',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/dep1/deposit'),
          data: {
            'data': {
              "uid": "dep1",
              "updated_at": "2019-08-24T14:15:22Z",
              "user": "76f62a58-5404-486d-9afc-07bded328704",
              "amount": 100.0,
              "currency": "VND",
              "created_at": "2019-08-24T14:15:22Z",
              "code": "string",
            },
          },
        ),
      );

      final result = await datasource.getDepositDetail('dep1');

      expect(result.id, 'dep1');
      expect(result.amount, 100.0);
    });
  });

  group('RechargeRemoteDatasourceImpl.getWithdrawDetail', () {
    test('fetches and maps withdrawal transaction', () async {
      when(
        () => dioClient.get(
          '/wallet/wd1/withdraw',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/wd1/withdraw'),
          data: {
            'data': {
              "user": {
                "full_name": "string",
                "email": "string",
                "balance": 0,
                "avatar_url": {
                  "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                  "original_name": "string",
                  "public_url": "string",
                },
                "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
              },
              "bank_account": {
                "bank_name": "string",
                "account_number": "string",
              },
              "uid": "wd1",
              "amount": 50.0,
              "code": "string",
              "created_at": "2019-08-24T14:15:22Z",
            },
          },
        ),
      );

      final result = await datasource.getWithdrawDetail('wd1');

      expect(result.id, 'wd1');
      expect(result.amount, 50.0);
    });
  });

  group('RechargeRemoteDatasourceImpl.getExternalHistory', () {
    test('returns paginated external transactions without filter', () async {
      when(
        () => dioClient.get(
          '/wallet/external',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/external'),
          data: {
            'data': {
              'content': [
                {
                  'uid': 'ext1',
                  'amount': 100.0,
                  'currency': 'vnd',
                  'type': 'deposit',
                  'date': '2026-03-26',
                  'code': 'EXT001',
                },
              ],
              'total_pages': 1,
              'current_page': 1,
            },
          },
        ),
      );

      final result = await datasource.getExternalHistory(1, 10, null);

      expect(result.data.length, 1);
      expect(result.totalPage, 1);
      expect(result.page, 1);
      verify(
        () => dioClient.get(
          '/wallet/external',
          queryParameters: {'page': 1, 'page_size': 10},
          data: null,
          options: null,
        ),
      ).called(1);
    });

    test('includes filter parameters in query params', () async {
      final filter = ExternalTransactionFilterArguments(
        start: DateTime(2026, 03, 01),
        end: DateTime(2026, 03, 31),
        minAmount: 50.0,
        maxAmount: 500.0,
        code: 'TEST',
      );

      when(
        () => dioClient.get(
          '/wallet/external',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/external'),
          data: <String, dynamic>{
            'data': {'content': [], 'total_pages': 0, 'current_page': 1},
          },
        ),
      );

      await datasource.getExternalHistory(1, 10, filter);

      final captured =
          verify(
                () => dioClient.get(
                  '/wallet/external',
                  queryParameters: captureAny(named: 'queryParameters'),
                ),
              ).captured.first
              as Map<String, dynamic>;

      expect(captured['page'], 1);
      expect(captured['page_size'], 10);
      expect(captured['start'], '2026-03-01 00:00');
      expect(captured['end'], '2026-03-31 00:00');
      expect(captured['min_amount'], 50.0);
      expect(captured['max_amount'], 500.0);
      expect(captured['code'], 'TEST');
    });

    test('omits null filter values from query params', () async {
      final filter = ExternalTransactionFilterArguments(minAmount: 100.0);

      when(
        () => dioClient.get(
          '/wallet/external',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/external'),
          data: {
            'data': {
              "content": [
                {
                  "uid": "07cc67f4-45d6-494b-adac-09b5cbc7e2b5",
                  "type": "deposit",
                  "amount": 0,
                  "currency": "vnd",
                  "code": "string",
                  "date": "2019-08-24T14:15:22Z",
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

      await datasource.getExternalHistory(2, 20, filter);

      verify(
        () => dioClient.get(
          '/wallet/external',
          queryParameters: {'page': 2, 'page_size': 20, 'min_amount': 100.0},
          data: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('RechargeRemoteDatasourceImpl.getInternalHistory', () {
    test('returns paginated internal transactions', () async {
      when(
        () => dioClient.get(
          '/wallet/transaction',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/transaction'),
          data: {
            'data': {
              'content': [
                {
                  'uid': 'int1',
                  'from_user': 'user1',
                  'to_user': 'user2',
                  'amount': 200.0,
                  'description': 'Payment',
                  'group': 'grp1',
                  'code': 'INT001',
                  'created_at': '2026-03-26',
                },
              ],
              'total_pages': 2,
              'current_page': 1,
            },
          },
        ),
      );

      final result = await datasource.getInternalHistory(1, 5, null);

      expect(result.data.length, 1);
      expect(result.totalPage, 2);
    });

    test('includes group and keyword filters', () async {
      final filter = InternalTransactionFilterArguments(
        groupId: 'grp1',
        keyword: 'search_term',
      );

      when(
        () => dioClient.get(
          '/wallet/transaction',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/transaction'),
          data: {
            'data': {'content': [], 'total_pages': 1, 'current_page': 1},
          },
        ),
      );

      await datasource.getInternalHistory(1, 10, filter);

      verify(
        () => dioClient.get(
          '/wallet/transaction',
          queryParameters: {
            'page': 1,
            'page_size': 10,
            'group_id': 'grp1',
            'keyword': 'search_term',
          },
          data: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('RechargeRemoteDatasourceImpl.verifyPin', () {
    test('returns token from response', () async {
      when(
        () => dioClient.post(
          '/wallet/verify-pin',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/verify-pin'),
          data: {
            'data': {'token': 'tok123'},
          },
        ),
      );

      final result = await datasource.verifyPin('123456', 100.0);

      expect(result, 'tok123');
      verify(
        () => dioClient.post(
          '/wallet/verify-pin',
          data: {'pin': '123456', 'amount': 100.0},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('RechargeRemoteDatasourceImpl.transfer', () {
    test('posts transfer without optional params', () async {
      when(
        () => dioClient.post(
          '/wallet/transaction',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/transaction'),
          data: {'success': 'SUCCESS'},
        ),
      );

      final result = await datasource.transfer(
        100.0,
        99.5,
        'VND',
        'recipient_uid',
        'Payment',
      );

      expect(result, true);
      verify(
        () => dioClient.post(
          '/wallet/transaction',
          data: {
            'original_amount': 100.0,
            'convert_amount': 99.5,
            'currency': 'VND',
            'user_uid': 'recipient_uid',
            'description': 'Payment',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });

    test('includes groupId and token when provided', () async {
      when(
        () => dioClient.post(
          '/wallet/transaction',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/transaction'),
          data: {'success': 'SUCCESS'},
        ),
      );

      final result = await datasource.transfer(
        50.0,
        49.75,
        'VND',
        'user_xyz',
        'Group expense',
        groupId: 'grp_abc',
        token: 'transfer_token_123',
      );

      expect(result, true);
      verify(
        () => dioClient.post(
          '/wallet/transaction',
          data: {
            'original_amount': 50.0,
            'convert_amount': 49.75,
            'currency': 'VND',
            'user_uid': 'user_xyz',
            'description': 'Group expense',
            'group_uid': 'grp_abc',
            'transfer_token': 'transfer_token_123',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });

    test('returns false when success is not SUCCESS', () async {
      when(
        () => dioClient.post(
          '/wallet/transaction',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wallet/transaction'),
          data: {'success': 'FAILED'},
        ),
      );

      final result = await datasource.transfer(10.0, 9.9, 'VND', 'uid', 'test');

      expect(result, false);
    });
  });
}
