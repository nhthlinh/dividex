import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/data/repositories/account_repository_impl.dart';
import 'package:Dividex/features/home/data/source/account_remote_datasource.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountRemoteDataSource extends Mock
    implements AccountRemoteDataSource {}

void main() {
  late AccountRemoteDataSource remoteDataSource;
  late AccountRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockAccountRemoteDataSource();
    repository = AccountRepositoryImpl(remoteDataSource);
  });

  group('AccountRepositoryImpl.createAccount', () {
    test('delegates to remote datasource and returns uid', () async {
      final account = BankAccount(
        id: null,
        accountNumber: '123456789',
        bankName: 'VCB',
        currency: CurrencyEnum.vnd,
      );

      when(() => remoteDataSource.createAccount(account))
          .thenAnswer((_) async => 'uid_123');

      final result = await repository.createAccount(account);

      expect(result, 'uid_123');
      verify(() => remoteDataSource.createAccount(account)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows exception from remote datasource', () async {
      final account = BankAccount(
        id: null,
        accountNumber: '123456789',
        bankName: 'VCB',
        currency: CurrencyEnum.vnd,
      );

      when(() => remoteDataSource.createAccount(account))
          .thenThrow(Exception('create failed'));

      expect(
        () => repository.createAccount(account),
        throwsA(isA<Exception>()),
      );

      verify(() => remoteDataSource.createAccount(account)).called(1);
    });
  });

  group('AccountRepositoryImpl.updateAccount', () {
    test('delegates update to remote datasource', () async {
      final account = BankAccount(
        id: 'acc_1',
        accountNumber: '999999',
        bankName: 'ACB',
        currency: CurrencyEnum.usd,
      );

      when(() => remoteDataSource.updateAccount(account))
          .thenAnswer((_) async {});

      await repository.updateAccount(account);

      verify(() => remoteDataSource.updateAccount(account)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('AccountRepositoryImpl.deleteAccount', () {
    test('delegates delete to remote datasource', () async {
      when(() => remoteDataSource.deleteAccount('acc_2'))
          .thenAnswer((_) async {});

      await repository.deleteAccount('acc_2');

      verify(() => remoteDataSource.deleteAccount('acc_2')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows delete failure', () async {
      when(() => remoteDataSource.deleteAccount('acc_3'))
          .thenThrow(StateError('delete failed'));

      expect(
        () => repository.deleteAccount('acc_3'),
        throwsA(isA<StateError>()),
      );

      verify(() => remoteDataSource.deleteAccount('acc_3')).called(1);
    });
  });

  group('AccountRepositoryImpl.getAccounts', () {
    test('returns account list from remote datasource', () async {
      final accounts = [
        BankAccount(
          id: 'a1',
          accountNumber: '1111',
          bankName: 'VCB',
          currency: CurrencyEnum.vnd,
        ),
        BankAccount(
          id: 'a2',
          accountNumber: '2222',
          bankName: 'ACB',
          currency: CurrencyEnum.usd,
        ),
      ];

      when(() => remoteDataSource.getAccounts(1, 20))
          .thenAnswer((_) async => accounts);

      final result = await repository.getAccounts(1, 20);

      expect(result.length, 2);
      expect(result.first.id, 'a1');
      expect(result.last.currency, CurrencyEnum.usd);
      verify(() => remoteDataSource.getAccounts(1, 20)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('returns empty list when remote datasource returns empty', () async {
      when(() => remoteDataSource.getAccounts(2, 10))
          .thenAnswer((_) async => []);

      final result = await repository.getAccounts(2, 10);

      expect(result, isEmpty);
      verify(() => remoteDataSource.getAccounts(2, 10)).called(1);
    });
  });

  group('AccountRepositoryImpl.verifyAccount', () {
    test('returns verified account name', () async {
      when(() => remoteDataSource.verifyAccount('12345678', 'VCB'))
          .thenAnswer((_) async => 'NGUYEN VAN A');

      final result = await repository.verifyAccount('12345678', 'VCB');

      expect(result, 'NGUYEN VAN A');
      verify(() => remoteDataSource.verifyAccount('12345678', 'VCB')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows verification exception', () async {
      when(() => remoteDataSource.verifyAccount('87654321', 'ACB'))
          .thenThrow(Exception('verify failed'));

      expect(
        () => repository.verifyAccount('87654321', 'ACB'),
        throwsA(isA<Exception>()),
      );

      verify(() => remoteDataSource.verifyAccount('87654321', 'ACB')).called(1);
    });
  });
}