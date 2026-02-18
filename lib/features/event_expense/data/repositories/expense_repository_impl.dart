import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart';
import 'package:Dividex/features/event_expense/domain/expense_repository.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
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
  ) async {
    return await remoteDataSource.createExpense(
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

  @override
  Future<PagingModel<List<ExpenseModel>>> listExpensesInGroup(
    String groupId,
    int page,
    int pageSize,
    ExpenseStatusEnum status,
  ) async {
    return await remoteDataSource.listExpensesInGroup(groupId, page, pageSize, status);
  }

  @override
  Future<PagingModel<List<ExpenseModel>>> listExpensesInEvent(
    String eventId,
    int page,
    int pageSize,
  ) async {
    return await remoteDataSource.listExpensesInEvent(eventId, page, pageSize);
  }

  @override
  Future<PagingModel<List<ExpenseModel>>> listAllExpenses(
    int page,
    int pageSize,
    ExpenseFilterArguments? filter,
  ) async {
    return await remoteDataSource.listAllExpenses(page, pageSize, filter);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await remoteDataSource.updateExpense(expense);
  }

  @override
  Future<void> softDeleteExpense(String id) async {
    await remoteDataSource.softDeleteExpense(id);
  }

  @override
  Future<void> hardDeleteExpense(String id) async {
    await remoteDataSource.hardDeleteExpense(id);
  }

  @override
  Future<ExpenseModel?> getExpenseDetail(String expenseId) async {
    return await remoteDataSource.getExpenseDetail(expenseId);
  }

  @override
  Future<void> restoreExpense(String id) async {
    await remoteDataSource.restoreExpense(id);
  }

  @override
  Future<List<CustomBarChartData>> getBarChartData(int year) async {
    return await remoteDataSource.getBarChartData(year);
  }
}
