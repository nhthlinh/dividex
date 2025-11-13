import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

class FriendDept {
  final GroupModel group;
  final UserModel creditor;
  final UserModel debtor;
  final double value;
  final CurrencyEnum currency;

  FriendDept({
    required this.group,
    required this.creditor,
    required this.debtor,
    required this.value,
    this.currency = CurrencyEnum.vnd,
  });

  factory FriendDept.fromJson(Map<String, dynamic> json) {
    return FriendDept(
      group: GroupModel.fromJson(json['group']),
      creditor: UserModel.fromJson(json['creditor']),
      debtor: UserModel.fromJson(json['debtor']),
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      currency: json['currency'] == null
        ? CurrencyEnum.vnd
        : ($enumDecodeNullable(
            $CurrencyEnumEnumMap,
            json['currency'].toString().toLowerCase(),
          ) ?? CurrencyEnum.vnd),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group': group.toJson(),
      'creditor': creditor.toJson(),
      'debtor': debtor.toJson(),
      'value': value,
    };
  }
}