import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/data/source/recharge_remote_data_source.dart';
import 'package:Dividex/features/recharge/domain/recharge_repository.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RechargeRepository)
class RechargeRepositoryImpl implements RechargeRepository {
  final RechargeRemoteDataSource remoteDataSource;

  RechargeRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> deposit(double amount, String currency, String bankCode) {
    return remoteDataSource.deposit(amount, currency, bankCode);
  }

  @override
  Future<void> createDeposit(double amount, String currency, String bankCode) {
    return remoteDataSource.createDeposit(amount, currency, bankCode);
  }

  @override
  Future<void> createWithdraw(double amount, String accountNumber, String bankCode) {
    return remoteDataSource.createWithdraw(amount, accountNumber, bankCode);
  }

  @override
  Future<String> getWallet() {
    return remoteDataSource.getWallet();
  }

  @override
  Future<Map<String, dynamic>> getWalletInfo() {
    return remoteDataSource.getWalletInfo();
  }

  @override
  Future<PagingModel<List<ExternalTransactionModel>>> getExternalHistory(int page, int pageSize, ExternalTransactionFilterArguments? filter) {
    return remoteDataSource.getExternalHistory(page, pageSize, filter);
  }

  @override
  Future<PagingModel<List<InternalTransactionModel>>> getInternalHistory(int page, int pageSize, InternalTransactionFilterArguments? filter) {
    return remoteDataSource.getInternalHistory(page, pageSize, filter);
  }

  @override
  Future<DepositTransactionModel> getDepositDetail(String id) {
    return remoteDataSource.getDepositDetail(id);
  }

  @override
  Future<WithdrawTransactionModel> getWithdrawDetail(String id) {
    return remoteDataSource.getWithdrawDetail(id);
  }

  @override
  Future<String?> verifyPin(String pin, double amount) {
    return remoteDataSource.verifyPin(pin, amount);
  }

  @override
  Future<bool> transfer(double originalAmount, double realAmount, String currency, String toAccount, String description, {String? groupId, String? token}) {
    return remoteDataSource.transfer(originalAmount, realAmount, currency, toAccount, description, groupId: groupId, token: token);
  }
}
