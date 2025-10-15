import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/domain/account_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountUseCase {
  final AccountRepository repository;

  AccountUseCase(this.repository);

  Future<List<BankAccount>> getAccounts(int page, int pageSize) {
    return repository.getAccounts(page, pageSize);
  }
  Future<void> createAccount(BankAccount account) {
    return repository.createAccount(account);
  }
  Future<void> updateAccount(BankAccount account) {
    return repository.updateAccount(account);
  }
  Future<void> deleteAccount(String accountId) {
    return repository.deleteAccount(accountId);
  }
}