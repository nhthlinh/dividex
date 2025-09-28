import 'package:Dividex/features/image/data/models/image_model.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final ImageModel? avatar;
  final bool? hasDebt;
  final double? amount;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.avatar,
    this.hasDebt,
    this.amount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['uid'] ?? json['friend_uid'] as String?,
    email: json['email'] as String?,
    fullName: json['full_name'] as String?,
    phoneNumber: json['phone_number'] as String?,
    avatar: json['avatar_url'] != null
        ? ImageModel.fromJson(json['avatar_url'] as Map<String, dynamic>)
        : (json['user_avatar_url'] != null
            ? ImageModel.fromJson({'url': json['user_avatar_url']})
            : null),
    hasDebt: json['has_debt'] as bool?,
    amount: (json['amount'] as num?)?.toDouble(),
  );

    Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'avatar_url': avatar,
      'has_debt': hasDebt,
      'amount': amount,
    };


  }
