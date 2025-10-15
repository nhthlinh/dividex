import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

class GroupMemberModel {
  final String? id;
  final GroupModel? group;
  final UserModel? user;
  final DateTime? joinedAt;
  final double? amount;

  GroupMemberModel({
    this.id,
    this.user,
    this.group,
    this.joinedAt,
    this.amount,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
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
        amount: json['balance'] == null
            ? null
            : double.tryParse(json['balance'].toString()),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'group': group,
    'user': user,
    'joinedAt': joinedAt?.toIso8601String(),
    'amount': amount,
  };
}
