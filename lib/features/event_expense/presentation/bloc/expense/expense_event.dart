import 'dart:typed_data';

import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
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

  final List<Uint8List>? images;

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
    this.images,
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

class SoftDeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;

  SoftDeleteExpenseEvent({required this.expenseId});
}

class HardDeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;

  HardDeleteExpenseEvent({required this.expenseId});
}

class RestoreExpense extends ExpenseEvent {
  final String expenseId;

  RestoreExpense({required this.expenseId});
}

class GetExpenseDetail extends ExpenseEvent {
  final String expenseId;

  GetExpenseDetail({required this.expenseId});
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
  ExpenseStatusEnum? status;

  InitialEvent({
    required this.id,
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
    this.type = LoadExpenseType.group,
    this.status = ExpenseStatusEnum.active,
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
  ExpenseStatusEnum? status;

  LoadMoreExpenses({
    required this.id,
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
    this.type = LoadExpenseType.group,
    this.status = ExpenseStatusEnum.active,
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
  ExpenseStatusEnum? status;

  RefreshExpenses({
    required this.id,
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
    this.type = LoadExpenseType.group,
    this.status = ExpenseStatusEnum.active,
  });
}
