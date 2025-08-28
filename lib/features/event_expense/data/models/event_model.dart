

import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final String? id;
  final String? name;
  final UserModel? creator;
  final String? description;
  final DateTime? eventStart;
  final DateTime? eventEnd;
  final DateTime? createdAt;
  final String? groupId;
  final String? groupName;

  EventModel({
    this.id,
    this.name,
    this.creator,
    this.description,
    this.eventStart,
    this.eventEnd,
    this.createdAt,
    this.groupId,
    this.groupName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}