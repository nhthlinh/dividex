import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/data/source/account_remote_datasource.dart';
import 'package:Dividex/features/home/domain/account_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createAccount(BankAccount account) {
    return remoteDataSource.createAccount(account);
  }

  @override
  Future<void> updateAccount(BankAccount account) {
    return remoteDataSource.updateAccount(account);
  }

  @override
  Future<void> deleteAccount(String accountId) {
    return remoteDataSource.deleteAccount(accountId);
  }

  @override
  Future<List<BankAccount>> getAccounts(int page, int pageSize) {
    return remoteDataSource.getAccounts(page, pageSize);
  }
}
