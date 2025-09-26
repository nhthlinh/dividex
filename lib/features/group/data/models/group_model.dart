import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class GroupModel {
  final String? id;
  final String? name;
  final String? leader;
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

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['uid'] as String?,
      name: json['name'] as String? ?? json['group_name'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['group_avatar_url'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      leader: json['leader'] == null ? null : json['leader'] as String,
      status: $enumDecodeNullable(_$StatusEnumEnumMap, json['status']),
      events:
          (json['events'] as List<dynamic>? ??
                  json['list_event'] as List<dynamic>?)
              ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': id,
    'name': name,
    'leader': leader,
    'status': _$StatusEnumEnumMap[status],
    'avatar_url': avatarUrl,
    'createdAt': createdAt?.toIso8601String(),
    'members': members,
    'events': events,
  };
}

const _$StatusEnumEnumMap = {
  StatusEnum.active: 'active',
  StatusEnum.deleted: 'deleted',
};
