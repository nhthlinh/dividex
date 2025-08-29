

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? avatar;
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

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
