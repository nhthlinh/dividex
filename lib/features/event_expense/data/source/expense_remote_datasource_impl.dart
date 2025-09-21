import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExpenseRemoteDataSource)
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final DioClient dio;

  ExpenseRemoteDataSourceImpl(this.dio);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await dio.post('/expenses', data: expense.toJson());
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await dio.put('/expenses/${expense.id}', data: expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await dio.delete('/expenses/$id');
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final response = await dio.get('/expenses');
    return (response.data as List)
        .map((item) => ExpenseModel.fromJson(item))
        .toList();
  }
}
