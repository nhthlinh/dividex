import 'package:Dividex/shared/utils/get_time_ago.dart';

class EventModel {
  final String? id;
  final String? name;
  final String? creator;
  final String? description;
  final DateTime? eventStart;
  final DateTime? eventEnd;
  final DateTime? createdAt;
  final String? group;
  final String? groupName;
  final List<String>? memberIds;

  EventModel({
    this.id,
    this.name,
    this.creator,
    this.description,
    this.eventStart,
    this.eventEnd,
    this.createdAt,
    this.group,
    this.groupName,
    this.memberIds,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['uid'] as String? ?? json['event_uid'] as String?,
    name: json['name'] as String? ?? json['event_name'] as String?,
    creator: json['creator'] as String?,
    group: json['group'] as String?,
    description: json['description'] as String? ?? json['event_description'] as String?,
    eventStart: json['event_start'] == null
        ? null
        : parseUTCToVN(json['event_start'] as String),
    eventEnd: json['event_end'] == null
        ? null
        : parseUTCToVN(json['event_end'] as String),
    createdAt: json['created_at'] == null
        ? null
        : parseUTCToVN(json['created_at'] as String),
    groupName: json['group_name'] as String?,
    memberIds: (json['member_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'creator': creator,
    'description': description,
    'eventStart': eventStart?.toIso8601String(),
    'eventEnd': eventEnd?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'group': group,
    'groupName': groupName,
    'memberIds': memberIds,
  };
}
