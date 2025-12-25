import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/participant.dart';

part 'participant_model.freezed.dart';
part 'participant_model.g.dart';

/// Data model for Participant with Freezed and JSON serialization
@freezed
abstract class ParticipantModel with _$ParticipantModel {
  const factory ParticipantModel({
    required String id,
    required String name,
    required String email,
    String? eventId,
  }) = _ParticipantModel;

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);
}

/// Extension to convert between Model and Entity
extension ParticipantModelX on ParticipantModel {
  /// Convert model to domain entity
  Participant toEntity() {
    return Participant(id: id, name: name, email: email, eventId: eventId);
  }
}

/// Extension to convert Entity to Model
extension ParticipantEntityX on Participant {
  /// Convert entity to data model
  ParticipantModel toModel() {
    return ParticipantModel(id: id, name: name, email: email, eventId: eventId);
  }
}
