import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExpenseRemoteDataSource)
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final DioClient dio;

  ExpenseRemoteDataSourceImpl(this.dio);

}
