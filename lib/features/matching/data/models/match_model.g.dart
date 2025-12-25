// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => _MatchModel(
  id: json['id'] as String,
  giverId: json['giverId'] as String,
  receiverId: json['receiverId'] as String,
  eventId: json['eventId'] as String,
);

Map<String, dynamic> _$MatchModelToJson(_MatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'giverId': instance.giverId,
      'receiverId': instance.receiverId,
      'eventId': instance.eventId,
    };
