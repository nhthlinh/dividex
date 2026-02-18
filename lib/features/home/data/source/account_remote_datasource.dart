import 'package:Dividex/features/home/data/models/bank_account_model.dart';

abstract class AccountRemoteDataSource {
  Future<String> createAccount(BankAccount account);
  Future<void> updateAccount(BankAccount account);
  Future<void> deleteAccount(String accountId);
  Future<List<BankAccount>> getAccounts(int page, int pageSize);
}
