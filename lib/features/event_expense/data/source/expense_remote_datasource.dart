


import 'package:Dividex/features/event_expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseModel>> getExpenses();
}
