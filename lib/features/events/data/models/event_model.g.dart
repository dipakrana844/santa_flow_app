// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventModel _$EventModelFromJson(Map<String, dynamic> json) => _EventModel(
  id: json['id'] as String,
  name: json['name'] as String,
  date: DateTime.parse(json['date'] as String),
  budget: (json['budget'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$EventModelToJson(_EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'budget': instance.budget,
      'createdAt': instance.createdAt.toIso8601String(),
    };
