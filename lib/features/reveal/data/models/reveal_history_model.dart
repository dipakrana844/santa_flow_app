import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reveal_history.dart';

part 'reveal_history_model.freezed.dart';
part 'reveal_history_model.g.dart';

/// Data model for RevealHistory with Freezed and JSON serialization
@freezed
abstract class RevealHistoryModel with _$RevealHistoryModel {
  const factory RevealHistoryModel({
    required String id,
    required String participantId,
    required String participantName,
    required String matchId,
    required String receiverId,
    required String receiverName,
    required DateTime revealedAt,
    required String eventId,
  }) = _RevealHistoryModel;

  factory RevealHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$RevealHistoryModelFromJson(json);
}

/// Extension to convert between Model and Entity
extension RevealHistoryModelX on RevealHistoryModel {
  /// Convert model to domain entity
  RevealHistory toEntity() {
    return RevealHistory(
      id: id,
      participantId: participantId,
      participantName: participantName,
      matchId: matchId,
      receiverId: receiverId,
      receiverName: receiverName,
      revealedAt: revealedAt,
      eventId: eventId,
    );
  }
}

/// Extension to convert Entity to Model
extension RevealHistoryEntityX on RevealHistory {
  /// Convert entity to data model
  RevealHistoryModel toModel() {
    return RevealHistoryModel(
      id: id,
      participantId: participantId,
      participantName: participantName,
      matchId: matchId,
      receiverId: receiverId,
      receiverName: receiverName,
      revealedAt: revealedAt,
      eventId: eventId,
    );
  }
}
