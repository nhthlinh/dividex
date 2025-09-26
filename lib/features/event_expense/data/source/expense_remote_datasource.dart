import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> createExpense(
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
  
  Future<PagingModel<List<ExpenseModel>>> listExpensesInEvent(
    String eventId,
    int page,
    int pageSize,
  );

  Future<PagingModel<List<ExpenseModel>>> listExpensesInGroup(
    String groupId,
    int page,
    int pageSize,
  );
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}
