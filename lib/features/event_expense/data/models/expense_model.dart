import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  final String? id;
  final int? ordinal;
  final String? name;
  final EventModel? event;
  final CurrencyEnum? currency;
  final double? totalAmount;
  final String? description;
  final UserModel? paidBy;
  final UserModel? creator;
  final SplitTypeEnum? splitType;
  final DateTime? expenseDate;
  final DateTime? remindAt;
  final String? receiptUrl;

  ExpenseModel({
    this.id,
    this.ordinal,
    this.name,
    this.event,
    this.currency,
    this.totalAmount,
    this.description,
    this.paidBy,
    this.creator,
    this.splitType,
    this.expenseDate,
    this.remindAt,
    this.receiptUrl,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);
}
