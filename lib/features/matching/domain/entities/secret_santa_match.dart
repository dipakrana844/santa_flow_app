import 'package:equatable/equatable.dart';

/// Domain entity representing a Secret Santa match
class SecretSantaMatch extends Equatable {
  final String id;
  final String giverId;
  final String receiverId;
  final String eventId;

  const SecretSantaMatch({
    required this.id,
    required this.giverId,
    required this.receiverId,
    required this.eventId,
  });

  @override
  List<Object?> get props => [id, giverId, receiverId, eventId];

  /// Creates a copy of this match with updated fields
  SecretSantaMatch copyWith({
    String? id,
    String? giverId,
    String? receiverId,
    String? eventId,
  }) {
    return SecretSantaMatch(
      id: id ?? this.id,
      giverId: giverId ?? this.giverId,
      receiverId: receiverId ?? this.receiverId,
      eventId: eventId ?? this.eventId,
    );
  }
}
