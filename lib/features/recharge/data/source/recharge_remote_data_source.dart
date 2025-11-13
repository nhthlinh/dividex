import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class RechargeRemoteDataSource {
  Future<String> deposit(double amount, String currency, String bankCode);
  Future<void> createDeposit(double amount, String currency, String bankCode);
  Future<void> createWithdraw(double amount, String accountNumber, String bankCode);
  Future<String> getWallet();
  Future<DepositTransactionModel> getDepositDetail(String id);
  Future<WithdrawTransactionModel> getWithdrawDetail(String id);
  Future<PagingModel<List<ExternalTransactionModel>>> getExternalHistory(int page, int pageSize, ExternalTransactionFilterArguments? filter);
  Future<PagingModel<List<InternalTransactionModel>>> getInternalHistory(int page, int pageSize, InternalTransactionFilterArguments? filter);
  Future<String?> verifyPin(String pin, double amount);
  Future<bool> transfer(double originalAmount, double realAmount, String currency, String toAccount, String description, {String? groupId, String? token});
}
