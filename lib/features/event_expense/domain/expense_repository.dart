import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseModel>> getExpenses();

  Future<PagingModel<List<String>>> getCategories(int page, int pageSize, String key);
}
