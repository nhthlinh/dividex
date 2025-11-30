import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/domain/recharge_repository.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class RechargeUseCase {
  final RechargeRepository rechargeRepository;

  RechargeUseCase({required this.rechargeRepository});

  Future<String> deposit(
    double amount,
    String currency,
    String bankCode,
  ) async {
    return rechargeRepository.deposit(amount, currency, bankCode);
  }

  Future<void> createDeposit(
    double amount,
    String currency,
    String bankCode,
  ) async {
    return rechargeRepository.createDeposit(amount, currency, bankCode);
  }

  Future<void> createWithdraw(
    double amount,
    String accountNumber,
    String bankCode,
  ) async {
    return rechargeRepository.createWithdraw(amount, accountNumber, bankCode);
  }

  Future<String> getWallet() async {
    return rechargeRepository.getWallet();
  }

  Future<Map<String, dynamic>> getWalletInfo() async {
    return rechargeRepository.getWalletInfo();
  }

  Future<PagingModel<List<ExternalTransactionModel>>> getExternalHistory(
    int page,
    int pageSize,
    ExternalTransactionFilterArguments? filter
  ) async {
    return rechargeRepository.getExternalHistory(page, pageSize, filter);
  }

  Future<PagingModel<List<InternalTransactionModel>>> getInternalHistory(
    int page,
    int pageSize,
    InternalTransactionFilterArguments? filter
  ) async {
    return rechargeRepository.getInternalHistory(page, pageSize, filter);
  }

  Future<DepositTransactionModel> getDepositDetail(String id) async {
    return rechargeRepository.getDepositDetail(id);
  }

  Future<WithdrawTransactionModel> getWithdrawDetail(String id) async {
    return rechargeRepository.getWithdrawDetail(id);
  }

  Future<String?> verifyPin(String pin, double amount) async {
    return rechargeRepository.verifyPin(pin, amount);
  }

  Future<bool> transfer(double originalAmount, double realAmount, String currency, String toAccount, String description, {String? groupId, String? token}) async {
    return rechargeRepository.transfer(originalAmount, realAmount, currency, toAccount, description, groupId: groupId, token: token);
  }
}
