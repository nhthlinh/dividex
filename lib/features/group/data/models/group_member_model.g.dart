// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      id: json['id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      group: json['group'] == null
          ? null
          : GroupModel.fromJson(json['group'] as Map<String, dynamic>),
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
      hasDebt: json['hasDebt'] as bool?,
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'user': instance.user,
      'joinedAt': instance.joinedAt?.toIso8601String(),
      'hasDebt': instance.hasDebt,
      'amount': instance.amount,
    };
