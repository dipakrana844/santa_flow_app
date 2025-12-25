// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reveal_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RevealTokenModel _$RevealTokenModelFromJson(Map<String, dynamic> json) =>
    _RevealTokenModel(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      matchId: json['matchId'] as String,
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isRevealed: json['isRevealed'] as bool? ?? false,
      revealedAt: json['revealedAt'] == null
          ? null
          : DateTime.parse(json['revealedAt'] as String),
    );

Map<String, dynamic> _$RevealTokenModelToJson(_RevealTokenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantId': instance.participantId,
      'matchId': instance.matchId,
      'token': instance.token,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'isRevealed': instance.isRevealed,
      'revealedAt': instance.revealedAt?.toIso8601String(),
    };
