import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/data/repositories/account_repository_impl.dart';
import 'package:Dividex/features/home/data/source/account_remote_datasource.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountRemoteDataSource extends Mock implements AccountRemoteDataSource {}

void main() {
  late AccountRemoteDataSource remoteDataSource;
  late AccountRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockAccountRemoteDataSource();
    repository = AccountRepositoryImpl(remoteDataSource);
  });

  test('createAccount delegates to remote datasource', () async {
    final account = BankAccount(
      accountNumber: '123456789',
      bankName: 'VCB',
      currency: CurrencyEnum.vnd,
    );
    when(() => remoteDataSource.createAccount(account)).thenAnswer((_) async => 'acc-1');

    final id = await repository.createAccount(account);

    expect(id, 'acc-1');
    verify(() => remoteDataSource.createAccount(account)).called(1);
  });

  test('verifyAccount delegates and returns account name', () async {
    when(() => remoteDataSource.verifyAccount('123456789', 'VCB')).thenAnswer((_) async => 'ALICE NGUYEN');

    final name = await repository.verifyAccount('123456789', 'VCB');

    expect(name, 'ALICE NGUYEN');
    verify(() => remoteDataSource.verifyAccount('123456789', 'VCB')).called(1);
  });
}
