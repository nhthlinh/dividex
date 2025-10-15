import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';

class BankAccount {
  final String? id;
  final String accountNumber;
  final String bankName;
  final CurrencyEnum? currency;

  BankAccount({
    this.id,
    required this.accountNumber,
    required this.bankName,
    required this.currency,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['uid'],
      accountNumber: json['account_number'],
      bankName: json['bank_name'],
      currency: json['currency'] == null
          ? null
          : $enumDecodeNullable(
              $CurrencyEnumEnumMap,
              json['currency'].toString().toLowerCase(),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'account_number': accountNumber,
      'bank_name': bankName,
      'currency': currency != null ? $CurrencyEnumEnumMap[currency] : null,
    };
  }
}
