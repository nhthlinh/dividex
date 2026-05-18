import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final ImageModel? avatar;
  final bool? hasDebt;
  final double? amount;
  final CurrencyEnum? currency;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.avatar,
    this.hasDebt,
    this.amount,
    this.currency,
  });

  static ImageModel? _parseAvatar(Map<String, dynamic> json) {
    final rawAvatar = json['avatar_url'] ?? json['user_avatar_url'];

    if (rawAvatar is Map) {
      return ImageModel.fromJson(Map<String, dynamic>.from(rawAvatar));
    }

    if (rawAvatar is String && rawAvatar.isNotEmpty) {
      return ImageModel(
        uid: '',
        originalName: '',
        publicUrl: rawAvatar,
      );
    }

    return null;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['uid'] ?? json['friend_uid'] as String?,
    email: json['email'] as String?,
    fullName: json['full_name'] as String?,
    phoneNumber: json['phone_number'] as String?,
    avatar: _parseAvatar(json),
    hasDebt: json['has_debt'] as bool?,
    amount: (json['amount'] as num?)?.toDouble(),
    currency: json['currency'] == null
        ? null
        : $enumDecodeNullable(
            $CurrencyEnumEnumMap,
            json['currency'].toString().toLowerCase(),
          ),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'full_name': fullName,
    'phone_number': phoneNumber,
    'avatar_url': avatar?.toJson(),
    'has_debt': hasDebt,
    'amount': amount,
    'currency': currency != null ? $CurrencyEnumEnumMap[currency]! : null,
  };

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    ImageModel? avatar,
    bool? hasDebt,
    double? amount,
    CurrencyEnum? currency,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      hasDebt: hasDebt ?? this.hasDebt,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }
}
