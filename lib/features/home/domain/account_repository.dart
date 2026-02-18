import 'package:Dividex/features/home/data/models/bank_account_model.dart';

abstract class AccountRepository {
  Future<List<BankAccount>> getAccounts(int page, int pageSize);
  Future<void> createAccount(BankAccount account);
  Future<void> updateAccount(BankAccount account);
  Future<void> deleteAccount(String accountId);
}