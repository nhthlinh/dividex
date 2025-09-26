import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/domain/expense_repository.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseUseCase {
  final ExpenseRepository repository;

  ExpenseUseCase(this.repository);

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
  ) async {
    await repository.createExpense(
      name,
      totalAmount,
      currency,
      category,
      eventId,
      paidById,
      note,
      expenseDate,
      remindAt,
      splitType,
      userDebts,
    );
  }

  Future<PagingModel<List<ExpenseModel>>> listExpensesInEvent(
    String eventId,
    int page,
    int pageSize,
  ) async {
    return await repository.listExpensesInEvent(eventId, page, pageSize);
  }

  Future<PagingModel<List<ExpenseModel>>> listExpensesInGroup(
    String groupId,
    int page,
    int pageSize,
  ) async {
    return await repository.listExpensesInGroup(groupId, page, pageSize);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await repository.updateExpense(expense);
  }

  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
  }
}
