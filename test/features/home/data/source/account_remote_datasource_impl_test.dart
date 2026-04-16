import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/data/source/account_remote_datasource_impl.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late AccountRemoteDatasourceImpl datasource;

  setUp(() {
    dioClient = _MockDioClient();
    datasource = AccountRemoteDatasourceImpl(dioClient);
  });

  group('AccountRemoteDatasourceImpl.createAccount', () {
    test('returns uid and posts mapped payload', () async {
      final account = BankAccount(
        id: null,
        accountNumber: '123456789',
        bankName: 'VCB',
        currency: CurrencyEnum.vnd,
      );

      when(
        () => dioClient.post(
          '/bank_account',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/bank_account'),
          data: {
            'data': {'uid': 'acc-1'},
          },
        ),
      );

      final result = await datasource.createAccount(account);

      expect(result, 'acc-1');
      verify(
        () => dioClient.post(
          '/bank_account',
          data: {
            'bank_name': 'VCB',
            'account_number': '123456789',
            'currency': 'vnd',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('AccountRemoteDatasourceImpl.updateAccount', () {
    test('puts account payload to account endpoint', () async {
      final account = BankAccount(
        id: 'acc-2',
        accountNumber: '9999',
        bankName: 'ACB',
        currency: CurrencyEnum.vnd,
      );

      when(
        () => dioClient.put(
          '/bank_account/acc-2',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/bank_account/acc-2'),
          data: {},
        ),
      );

      await datasource.updateAccount(account);

      verify(
        () => dioClient.put(
          '/bank_account/acc-2',
          data: {
            'bank_name': 'ACB',
            'account_number': '9999',
            'currency': 'vnd',
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('AccountRemoteDatasourceImpl.deleteAccount', () {
    test('deletes account by id', () async {
      when(
        () => dioClient.delete(
          '/bank_account/acc-3',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/bank_account/acc-3'),
          data: {},
        ),
      );

      await datasource.deleteAccount('acc-3');

      verify(
        () => dioClient.delete(
          '/bank_account/acc-3',
          data: null,
          queryParameters: null,
        ),
      ).called(1);
    });
  });

  group('AccountRemoteDatasourceImpl.getAccounts', () {
    test('returns empty list when content is null', () async {
      when(
        () => dioClient.get(
          '/bank_account',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/bank_account'),
          data: {
            'data': {'content': null},
          },
        ),
      );

      final result = await datasource.getAccounts(1, 10);

      expect(result, isEmpty);
      verify(
        () => dioClient.get(
          '/bank_account',
          queryParameters: {'page': 1, 'page_size': 10},
          data: null,
          options: null,
        ),
      ).called(1);
    });

    test('maps content list into BankAccount models', () async {
      when(
        () => dioClient.get(
          '/bank_account',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/bank_account'),
          data: {
            'data': {
              'content': [
                {
                  'uid': 'a1',
                  'account_number': '111',
                  'bank_name': 'VCB',
                  'currency': 'vnd',
                },
                {
                  'uid': 'a2',
                  'account_number': '222',
                  'bank_name': 'ACB',
                  'currency': 'vnd',
                },
              ],
            },
          },
        ),
      );

      final result = await datasource.getAccounts(2, 5);

      expect(result.length, 2);
      expect(result.first.id, 'a1');
      expect(result.first.accountNumber, '111');
      expect(result.first.bankName, 'VCB');
      expect(result.first.currency, CurrencyEnum.vnd);
      expect(result[1].currency, CurrencyEnum.vnd);
    });
  });
}
