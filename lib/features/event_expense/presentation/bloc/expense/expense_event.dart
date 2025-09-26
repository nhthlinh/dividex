import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/shared/models/enum.dart';

class ExpenseEvent {}

class CreateExpenseEvent extends ExpenseEvent {
  final String name;
  final double totalAmount;
  final String currency;
  final String category;
  final String eventId;
  final String? paidById;

  final String? note;
  final String? expenseDate;
  final String? remindAt;
  final SplitTypeEnum splitType;
  final List<UserDebt> userDebts;

  CreateExpenseEvent(
    this.name,
    this.totalAmount,
    this.currency,
    this.category,
    this.eventId,
    this.paidById,
    this.note,
    this.expenseDate,
    this.remindAt,
    this.splitType,
    this.userDebts,
  );
}

class UpdateExpenseEvent extends ExpenseEvent {
  final String expenseId;
  final String name;
  final double totalAmount;
  final String currency;
  final String category;
  final String? paidById;

  final String? note;
  final String? expenseDate;
  final String? remindAt;
  final SplitTypeEnum splitType;
  final List<UserDebt> userDebts;

  UpdateExpenseEvent({
    required this.expenseId,
    required this.name,
    required this.totalAmount,
    required this.currency,
    required this.category,
    this.paidById,
    this.note,
    this.expenseDate,
    this.remindAt,
    required this.splitType,
    required this.userDebts,
  });
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;

  DeleteExpenseEvent({required this.expenseId});
}

enum LoadExpenseType { group, event }

class InitialEvent extends ExpenseEvent {
  String id;
  int page;
  int pageSize;
  String searchQuery;
  String orderBy;
  String sortType;
  LoadExpenseType type;

  InitialEvent({
    required this.id,
    this.page = 0,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
    this.type = LoadExpenseType.group,
  });
}

class LoadMoreExpenses extends ExpenseEvent {
  String id;
  int page;
  int pageSize;
  String searchQuery;
  String orderBy;
  String sortType;
  LoadExpenseType type;

  LoadMoreExpenses({
    required this.id,
    this.page = 0,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
    this.type = LoadExpenseType.group,
  });
}

class RefreshExpenses extends ExpenseEvent {
  String id;
  int page;
  int pageSize;
  String searchQuery;
  String orderBy;
  String sortType;
  LoadExpenseType type;

  RefreshExpenses({
    required this.id,
    this.page = 0,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
    this.type = LoadExpenseType.group,
  });
}
