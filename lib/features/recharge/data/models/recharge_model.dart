import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/get_time_ago.dart';
import 'package:json_annotation/json_annotation.dart';

enum ExternalTransactionType {
  deposit,
  withdraw,
}

class InternalTransactionModel {
  final String? uid;
  final String? fromUser;
  final String? toUser;
  final double? amount;
  final String? description;
  final String? group;
  final DateTime? date;
  final String? code;

  InternalTransactionModel({
    this.uid,
    this.fromUser,
    this.toUser,
    this.amount,
    this.description,
    this.group,
    this.date,
    this.code,
  });

  factory InternalTransactionModel.fromJson(Map<String, dynamic> json) {
    return InternalTransactionModel(
      uid: json['uid'] as String?,
      fromUser: json['from_user'],
      toUser: json['to_user'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'],
      group: json['group'],
      code: json['code'],
      date: parseUTCToVN(json['created_at']),
    );
  }
}

class ExternalTransactionModel {
  final String id;
  final ExternalTransactionType type;
  final double amount;
  final CurrencyEnum currency;
  final String code;
  final DateTime date;

  ExternalTransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.type,
    required this.date,
    required this.code,
  });

  factory ExternalTransactionModel.fromJson(Map<String, dynamic> json) {
    return ExternalTransactionModel(
      id: json['uid'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currency: $enumDecodeNullable(
            $CurrencyEnumEnumMap,
            json['currency'].toString().toLowerCase(),
          ) ?? CurrencyEnum.values.first,
      type: json['type'] == 'deposit'
          ? ExternalTransactionType.deposit
          : ExternalTransactionType.withdraw,
      date: parseUTCToVN(json['date']),
      code: json['code'],
    );
  }
}

class DepositTransactionModel {
  final String id;
  final String user;
  final double amount;
  final CurrencyEnum currency;
  final DateTime date;
  final String code;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  DepositTransactionModel({
    required this.user,
    required this.amount,
    required this.currency,
    required this.date,
    required this.code,
    this.updatedAt,
    this.createdAt,
    required this.id,
  });

  factory DepositTransactionModel.fromJson(Map<String, dynamic> json) {
    return DepositTransactionModel(
      id: json['uid'],
      user: json['user'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currency: $enumDecodeNullable(
            $CurrencyEnumEnumMap,
            json['currency'].toString().toLowerCase(),
          ) ?? CurrencyEnum.values.first,
      date: parseUTCToVN(json['created_at']),
      code: json['code'],
      createdAt: json['created_at'] != null ? parseUTCToVN(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? parseUTCToVN(json['updated_at']) : null,
    );
  }
}

class WithdrawTransactionModel {
  final String id;
  final UserModel user;
  final BankAccount bankAccount;
  final double amount;
  final DateTime date;
  final String code;

  WithdrawTransactionModel({
    required this.user,
    required this.amount,
    required this.date,
    required this.code,
    required this.id,
    required this.bankAccount,
  });

  factory WithdrawTransactionModel.fromJson(Map<String, dynamic> json) {
    return WithdrawTransactionModel(
      id: json['uid'],
      user: UserModel.fromJson(json['user']),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: parseUTCToVN(json['created_at']),
      code: json['code'],
      bankAccount: BankAccount.fromJson(json['bank_account']),
    );
  }
}