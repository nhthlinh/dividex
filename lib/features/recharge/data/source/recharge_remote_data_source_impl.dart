import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/data/source/recharge_remote_data_source.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:Dividex/shared/utils/get_time_ago.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@Injectable(as: RechargeRemoteDataSource)
class RechargeRemoteDatasourceImpl implements RechargeRemoteDataSource {
  final DioClient dio;

  RechargeRemoteDatasourceImpl(this.dio);

  @override
  Future<String> deposit(double amount, String currency, String bankCode) {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/payment',
        data: {'amount': amount, 'currency': currency, 'bank_code': bankCode},
      );

      return response.data['data']['payment_url'];
    });
  }

  @override
  Future<void> createDeposit(double amount, String currency, String bankCode) {
    return apiCallWrapper(() async {
      await dio.post(
        '/payment/deposit',
        data: {'amount': amount, 'currency': currency, 'bank_code': bankCode},
      );
    });
  }

  @override
  Future<void> createWithdraw(
    double amount,
    String accountNumber,
    String bankCode,
  ) {
    return apiCallWrapper(() async {
      await dio.post(
        '/wallet/withdraw',
        data: {
          'amount': amount,
          'account_number': accountNumber,
          'bank_name': bankCode,
        },
      );
    });
  }

  @override
  Future<String> getWallet() {
    return apiCallWrapper(() async {
      final res = await dio.get('/wallet');

      final balanceRaw = res.data['data']['balance'];
      final currency = res.data['data']['currency'] ?? '';

      final balance = double.tryParse(balanceRaw.toString());

      return balance != null
          ? '${formatNumber(double.parse(balance.toStringAsFixed(2)))} $currency'
          : '0.00 $currency';
    });
  }

  @override
  Future<Map<String, dynamic>> getWalletInfo() {
    return apiCallWrapper(() async {
      final res = await dio.get('/auth/wallet');

      final balanceRaw = res.data['data']['balance'];
      final currency = res.data['data']['currency'] ?? '';
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      final balance = double.tryParse(balanceRaw.toString());
      return {
        'balance': balance != null
            ? formatNumber(double.parse(balance.toStringAsFixed(2)))
            : 0.00,
        'currency': currency,
        'totalTransactions': res.data['data']['total_transactions'].toString(),
        'phoneNumber': res.data['data']['phone_number'].toString(),
        'fullName': res.data['data']['full_name'].toString(),
        'latestTime': getTimeAgo(DateTime.parse(res.data['data']['latest_time']), intl),
      };
    });
  }

  @override
  Future<DepositTransactionModel> getDepositDetail(String id) {
    return apiCallWrapper(() async {
      final res = await dio.get('/wallet/$id/deposit');
      return DepositTransactionModel.fromJson(res.data['data']);
    });
  }

  @override
  Future<WithdrawTransactionModel> getWithdrawDetail(String id) {
    return apiCallWrapper(() async {
      final res = await dio.get('/wallet/$id/withdraw');
      return WithdrawTransactionModel.fromJson(res.data['data']);
    });
  }

  @override
  Future<PagingModel<List<ExternalTransactionModel>>> getExternalHistory(
    int page,
    int pageSize,
    ExternalTransactionFilterArguments? filter,
  ) {
    return apiCallWrapper(() async {
      final queryParams = {
        'page': page,
        'page_size': pageSize,
        if (filter?.start != null) 'start': DateFormat("yyyy-MM-dd HH:mm").format(filter!.start!),
        if (filter?.end != null) 'end': DateFormat("yyyy-MM-dd HH:mm").format(filter!.end!),
        if (filter?.minAmount != null) 'min_amount': filter!.minAmount,
        if (filter?.maxAmount != null) 'max_amount': filter!.maxAmount,
        if (filter?.code?.isNotEmpty ?? false) 'code': filter!.code,
      };
      final res = await dio.get(
        '/wallet/external',
        queryParameters: queryParams,
      );

      final data = res.data as Map<String, dynamic>;
      final transactions = (data['data']['content'] as List)
          .map(
            (item) =>
                ExternalTransactionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();

      return PagingModel(
        data: transactions,
        totalItems: transactions.length,
        totalPage: data['data']['total_pages'],
        page: data['data']['current_page'],
      );
    });
  }

  @override
  Future<PagingModel<List<InternalTransactionModel>>> getInternalHistory(
    int page,
    int pageSize,
    InternalTransactionFilterArguments? filter,
  ) {
    return apiCallWrapper(() async {
      final queryParams = {
        'page': page,
        'page_size': pageSize,

        if (filter?.start != null) 'start': DateFormat("yyyy-MM-dd HH:mm").format(filter!.start!),
        if (filter?.end != null) 'end': DateFormat("yyyy-MM-dd HH:mm").format(filter!.end!),
        if (filter?.minAmount != null) 'min_amount': filter!.minAmount,
        if (filter?.maxAmount != null) 'max_amount': filter!.maxAmount,
        if (filter?.groupId?.isNotEmpty ?? false) 'group_id': filter!.groupId,
        if (filter?.keyword?.isNotEmpty ?? false) 'keyword': filter!.keyword,
      };
      final res = await dio.get(
        '/wallet/transaction',
        queryParameters: queryParams,
      );

      final data = res.data as Map<String, dynamic>;
      final transactions = (data['data']['content'] as List)
          .map(
            (item) =>
                InternalTransactionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();

      return PagingModel(
        data: transactions,
        totalItems: transactions.length,
        totalPage: data['data']['total_pages'],
        page: data['data']['current_page'],
      );
    });
  }

  @override
  Future<String?> verifyPin(String pin, double amount) {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/wallet/verify-pin',
        data: {'pin': pin, 'amount': amount},
      );

      return response.data['data']['token'];
    });
  }

  @override
  Future<bool> transfer(
    double originalAmount,
    double realAmount,
    String currency,
    String toAccount,
    String description, {
    String? groupId,
    String? token,
  }) {
    return apiCallWrapper(() async {
      final data = {
        'original_amount': originalAmount,
        'convert_amount': realAmount,
        'currency': currency,
        'user_uid': toAccount,
        'description': description,
      };
      if (groupId != null) {
        data['group_uid'] = groupId;
      }
      if (token != null) {
        data['transfer_token'] = token;
      }

      final response = await dio.post('/wallet/transaction', data: data);

      return response.data['success'] == 'SUCCESS';
    });
  }
}
