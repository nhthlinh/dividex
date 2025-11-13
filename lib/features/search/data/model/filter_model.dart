import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';

class ExpenseFilterArguments {
  final String? name;
  final ExpenseStatusEnum? status;
  final DateTime? start;
  final DateTime? end;
  final double? minAmount;
  final double? maxAmount;
  final String? eventId;
  final String? groupId;
  final String? category;

  ExpenseFilterArguments({
    this.name,
    this.status,
    this.start,
    this.end,
    this.minAmount,
    this.maxAmount,
    this.eventId,
    this.groupId,
    this.category,
  });

  ExpenseFilterArguments copyWith({
    String? name,
    ExpenseStatusEnum? status,
    DateTime? start,
    DateTime? end,
    double? minAmount,
    double? maxAmount,
    String? eventId,
    String? groupId,
    String? category,
  }) {
    return ExpenseFilterArguments(
      name: name ?? this.name,
      status: status ?? this.status,
      start: start ?? this.start,
      end: end ?? this.end,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      eventId: eventId ?? this.eventId,
      groupId: groupId ?? this.groupId,
      category: category ?? this.category,
    );
  }
}

class ExternalTransactionFilterArguments {
  final String? code;
  final DateTime? start;
  final DateTime? end;
  final double? minAmount;
  final double? maxAmount;

  ExternalTransactionFilterArguments({
    this.code,
    this.start,
    this.end,
    this.minAmount,
    this.maxAmount,
  });

  ExternalTransactionFilterArguments copyWith({
    String? code,
    DateTime? start,
    DateTime? end,
    double? minAmount,
    double? maxAmount,
  }) {
    return ExternalTransactionFilterArguments(
      code: code ?? this.code,
      start: start ?? this.start,
      end: end ?? this.end,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }
}

class InternalTransactionFilterArguments {
  final String? name;
  final String? code;
  final String? groupId;
  final DateTime? start;
  final DateTime? end;
  final double? minAmount;
  final double? maxAmount;

  InternalTransactionFilterArguments({
    this.name,
    this.code,
    this.groupId,
    this.start,
    this.end,
    this.minAmount,
    this.maxAmount,
  });

  InternalTransactionFilterArguments copyWith({
    String? name,
    String? code,
    String? groupId,
    DateTime? start,
    DateTime? end,
    double? minAmount,
    double? maxAmount,
  }) {
    return InternalTransactionFilterArguments(
      name: name ?? this.name,
      code: code ?? this.code,
      groupId: groupId ?? this.groupId,
      start: start ?? this.start,
      end: end ?? this.end,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }
}
