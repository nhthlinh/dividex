import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class ExpenseRepository {
  Future<String> createExpense(
    String name,
    double totalAmount,
    String currency,
    String category,
    String eventId,
    String? paidById,
    String? note,
    String? expenseDate,
    String? remindAt,
    SplitTypeEnum splitType,
    List<UserDebt> userDebts,
  );
  Future<PagingModel<List<ExpenseModel>>> listExpensesInGroup(
    String groupId,
    int page,
    int pageSize,
    ExpenseStatusEnum status,
  );
  Future<PagingModel<List<ExpenseModel>>> listExpensesInEvent(
    String eventId,
    int page,
    int pageSize,
  );
  Future<PagingModel<List<ExpenseModel>>> listAllExpenses(
    int page,
    int pageSize,
    ExpenseFilterArguments? filter,
  );
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> softDeleteExpense(String id);
  Future<void> hardDeleteExpense(String id);

  Future<ExpenseModel?> getExpenseDetail(String expenseId);
  Future<void> restoreExpense(String id);
  Future<List<CustomBarChartData>> getBarChartData(int year);
}
