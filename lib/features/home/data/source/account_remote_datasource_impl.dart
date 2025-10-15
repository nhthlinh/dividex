import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/data/source/account_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AccountRemoteDataSource)
class AccountRemoteDatasourceImpl implements AccountRemoteDataSource {
  final DioClient dio;

  AccountRemoteDatasourceImpl(this.dio);

  @override
  Future<String> createAccount(BankAccount account) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/bank_account',
        data: {
          'bank_name': account.bankName,
          'account_number': account.accountNumber,
          'currency': account.currency != null
              ? $CurrencyEnumEnumMap[account.currency]
              : null,
        },
      );
      return response.data['data']['uid'] as String;
    });
  }

  @override
  Future<void> updateAccount(BankAccount account) async {
    return apiCallWrapper(() async {
      await dio.put(
        '/bank_account/${account.id}',
        data: {
          'bank_name': account.bankName,
          'account_number': account.accountNumber,
          'currency': account.currency != null
              ? $CurrencyEnumEnumMap[account.currency]
              : null,
        },
      );
    });
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    return apiCallWrapper(() async {
      await dio.delete('/bank_account/$accountId');
    });
  }

  @override
  Future<List<BankAccount>> getAccounts(int page, int pageSize) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/bank_account',
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      final data = response.data;
      final content = data['data']['content'];

      if (content == null || content is! List) {
        return <BankAccount>[];
      }

      return content.map((item) => BankAccount.fromJson(item)).toList();
    });
  }
}
