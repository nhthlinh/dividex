import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart';
import 'package:Dividex/features/event_expense/domain/expense_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await remoteDataSource.addExpense(expense);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await remoteDataSource.updateExpense(expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await remoteDataSource.deleteExpense(id);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return await remoteDataSource.getExpenses();
  }

  @override
  Future<PagingModel<List<String>>> getCategories(int page, int pageSize, String key) async {
    return await remoteDataSource.getCategories(page, pageSize, key);
  }

}
