import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/secret_santa_match.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// Data model for SecretSantaMatch with Freezed and JSON serialization
@freezed
abstract class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String giverId,
    required String receiverId,
    required String eventId,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}

/// Extension to convert between Model and Entity
extension MatchModelX on MatchModel {
  /// Convert model to domain entity
  SecretSantaMatch toEntity() {
    return SecretSantaMatch(
      id: id,
      giverId: giverId,
      receiverId: receiverId,
      eventId: eventId,
    );
  }
}

/// Extension to convert Entity to Model
extension MatchEntityX on SecretSantaMatch {
  /// Convert entity to data model
  MatchModel toModel() {
    return MatchModel(
      id: id,
      giverId: giverId,
      receiverId: receiverId,
      eventId: eventId,
    );
  }
}
