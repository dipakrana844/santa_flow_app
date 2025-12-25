import 'package:equatable/equatable.dart';

/// Domain entity representing a reveal history entry
class RevealHistory extends Equatable {
  final String id;
  final String participantId;
  final String participantName;
  final String matchId;
  final String receiverId;
  final String receiverName;
  final DateTime revealedAt;
  final String eventId;

  const RevealHistory({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.matchId,
    required this.receiverId,
    required this.receiverName,
    required this.revealedAt,
    required this.eventId,
  });

  @override
  List<Object?> get props => [
    id,
    participantId,
    participantName,
    matchId,
    receiverId,
    receiverName,
    revealedAt,
    eventId,
  ];
}
