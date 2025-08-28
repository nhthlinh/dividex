

import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  final String? id;
  final String? name;
  final UserModel? leader;
  final StatusEnum? status;
  final String? avatarUrl;
  final DateTime? createdAt;
  final List<GroupMemberModel>? members;
  final List<EventModel>? events;

  GroupModel({
    this.id,
    this.name,
    this.avatarUrl,
    this.createdAt,
    this.members,
    this.leader,
    this.status,
    this.events,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}


