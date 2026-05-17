import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/domain/expense_repository.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

enum ExpenseStatusEnum { deleted, active }

@injectable
class ExpenseUseCase {
  final ExpenseRepository repository;

  ExpenseUseCase(this.repository);

  List<UserDebt> calculateUserDebts(
    List<UserDebt> members,
    double totalAmount,
  ) {
    return members.map((m) {
      if (totalAmount <= 0 || members.isEmpty) {
        return UserDebt(userId: m.userId, amount: 0);
      }
      final balance = totalAmount / members.length;
      return UserDebt(userId: m.userId, amount: balance);
    }).toList();
  }

  Future<String> createExpense(
    String name,
    double totalAmount,
    String currency,
    String? category,
    String eventId,
    String? paidById,
    String? note,
    String? expenseDate,
    String? remindAt,
    SplitTypeEnum splitType,
    List<UserDebt> userDebts,
  ) async {
    if (userDebts.isEmpty) {
      throw Exception("Cần ít nhất 1 người tham gia chia sẻ chi phí");
    }

    if (splitType == SplitTypeEnum.equal && userDebts.isNotEmpty) {
      userDebts = calculateUserDebts(userDebts, totalAmount);
    }

    if (splitType == SplitTypeEnum.custom && userDebts.isNotEmpty) {
      final totalDebt = userDebts.fold<double>(
        0,
        (previousValue, element) => previousValue + (element.amount),
      );
      if (totalDebt != totalAmount) {
        throw Exception(
          "Tổng số tiền chia sẻ không khớp với tổng số tiền của chi phí",
        );
      }
    }
    return await repository.createExpense(
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
    ExpenseStatusEnum status,
  ) async {
    return await repository.listExpensesInGroup(
      groupId,
      page,
      pageSize,
      status,
    );
  }

  Future<PagingModel<List<ExpenseModel>>> listAllExpenses(
    int page,
    int pageSize,
    ExpenseFilterArguments? filter,
  ) async {
    return await repository.listAllExpenses(page, pageSize, filter);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    if (expense.userDebts!.isNotEmpty) {
      throw Exception("Cần ít nhất 1 người tham gia chia sẻ chi phí");
    }

    if (expense.splitType == SplitTypeEnum.custom && expense.userDebts!.isNotEmpty) {
      final totalDebt = expense.userDebts!.fold<double>(
        0,
        (previousValue, element) => previousValue + (element.amount),
      );
      if (totalDebt != expense.totalAmount) {
        throw Exception(
          "Tổng số tiền chia sẻ không khớp với tổng số tiền của chi phí",
        );
      }
    }
    await repository.updateExpense(expense);
  }

  Future<void> softDeleteExpense(String id) async {
    await repository.softDeleteExpense(id);
  }

  Future<void> hardDeleteExpense(String id) async {
    await repository.hardDeleteExpense(id);
  }

  Future<ExpenseModel?> getExpenseDetail(String expenseId) async {
    return await repository.getExpenseDetail(expenseId);
  }

  Future<void> restoreExpense(String id) async {
    await repository.restoreExpense(id);
  }

  Future<List<CustomBarChartData>> getBarChartData(int year) async {
    return await repository.getBarChartData(year);
  }
}
