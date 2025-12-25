import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/event.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

/// Data model for Event with Freezed and JSON serialization
@freezed
abstract class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String name,
    required DateTime date,
    double? budget,
    required DateTime createdAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

/// Extension to convert between Model and Entity
extension EventModelX on EventModel {
  /// Convert model to domain entity
  Event toEntity() {
    return Event(
      id: id,
      name: name,
      date: date,
      budget: budget,
      createdAt: createdAt,
    );
  }
}

/// Extension to convert Entity to Model
extension EventEntityX on Event {
  /// Convert entity to data model
  EventModel toModel() {
    return EventModel(
      id: id,
      name: name,
      date: date,
      budget: budget,
      createdAt: createdAt,
    );
  }
}
