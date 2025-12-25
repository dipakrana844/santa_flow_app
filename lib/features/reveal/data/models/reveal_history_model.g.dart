// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reveal_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RevealHistoryModel _$RevealHistoryModelFromJson(Map<String, dynamic> json) =>
    _RevealHistoryModel(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      matchId: json['matchId'] as String,
      receiverId: json['receiverId'] as String,
      receiverName: json['receiverName'] as String,
      revealedAt: DateTime.parse(json['revealedAt'] as String),
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$RevealHistoryModelToJson(_RevealHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantId': instance.participantId,
      'participantName': instance.participantName,
      'matchId': instance.matchId,
      'receiverId': instance.receiverId,
      'receiverName': instance.receiverName,
      'revealedAt': instance.revealedAt.toIso8601String(),
      'eventId': instance.eventId,
    };
