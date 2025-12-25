import 'package:equatable/equatable.dart';

/// Domain entity representing a reveal token for Secret Santa
class RevealToken extends Equatable {
  final String id;
  final String participantId;
  final String matchId;
  final String token; // Unique token for QR code/link
  final DateTime expiresAt;
  final bool isRevealed;
  final DateTime? revealedAt;

  const RevealToken({
    required this.id,
    required this.participantId,
    required this.matchId,
    required this.token,
    required this.expiresAt,
    this.isRevealed = false,
    this.revealedAt,
  });

  @override
  List<Object?> get props => [
    id,
    participantId,
    matchId,
    token,
    expiresAt,
    isRevealed,
    revealedAt,
  ];

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token is valid (not expired and not revealed)
  bool get isValid => !isExpired && !isRevealed;

  /// Creates a copy of this token with updated fields
  RevealToken copyWith({
    String? id,
    String? participantId,
    String? matchId,
    String? token,
    DateTime? expiresAt,
    bool? isRevealed,
    DateTime? revealedAt,
  }) {
    return RevealToken(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      matchId: matchId ?? this.matchId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      isRevealed: isRevealed ?? this.isRevealed,
      revealedAt: revealedAt ?? this.revealedAt,
    );
  }
}
