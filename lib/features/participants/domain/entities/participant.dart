import 'package:equatable/equatable.dart';

/// Domain entity representing a participant in Secret Santa
class Participant extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? eventId;

  const Participant({
    required this.id,
    required this.name,
    required this.email,
    this.eventId,
  });

  @override
  List<Object?> get props => [id, name, email, eventId];

  /// Creates a copy of this participant with updated fields
  Participant copyWith({
    String? id,
    String? name,
    String? email,
    String? eventId,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      eventId: eventId ?? this.eventId,
    );
  }
}
