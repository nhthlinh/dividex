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

  @override
  Future<PagingModel<List<String>>> getCategories(int page, int pageSize, String key) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    if (page == 1) {
      return PagingModel(data: ['Food', 'Transport', 'Utilities'], totalPage: 2, page: 1);
    } else {
      return PagingModel(data: [], totalPage: 2, page: 2);
    }
  }

}
