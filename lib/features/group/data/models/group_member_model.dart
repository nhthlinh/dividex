import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'group_member_model.g.dart';

@JsonSerializable()
class GroupMemberModel {
  final String? id;
  final GroupModel? group;
  final UserModel? user;
  final DateTime? joinedAt;

  GroupMemberModel({
    this.id,
    this.user,
    this.group,
    this.joinedAt,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);
}
