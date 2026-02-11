// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  leader: json['leader'] as String?,
  status: $enumDecodeNullable(_$StatusEnumEnumMap, json['status']),
  events: (json['events'] as List<dynamic>?)
      ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'leader': instance.leader,
      'status': _$StatusEnumEnumMap[instance.status],
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'members': instance.members,
      'events': instance.events,
    };

const _$StatusEnumEnumMap = {
  StatusEnum.active: 'active',
  StatusEnum.deleted: 'deleted',
};
