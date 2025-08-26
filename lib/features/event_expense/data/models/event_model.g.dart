// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  creator: json['creator'] == null
      ? null
      : UserModel.fromJson(json['creator'] as Map<String, dynamic>),
  description: json['description'] as String?,
  eventStart: json['eventStart'] == null
      ? null
      : DateTime.parse(json['eventStart'] as String),
  eventEnd: json['eventEnd'] == null
      ? null
      : DateTime.parse(json['eventEnd'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'creator': instance.creator,
      'description': instance.description,
      'eventStart': instance.eventStart?.toIso8601String(),
      'eventEnd': instance.eventEnd?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
