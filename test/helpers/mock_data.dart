import 'package:uuid/uuid.dart';
import '../../lib/features/participants/domain/entities/participant.dart';
import '../../lib/features/events/domain/entities/event.dart';
import '../../lib/features/matching/domain/entities/secret_santa_match.dart';
import '../../lib/features/reveal/domain/entities/reveal_token.dart';

/// Factory class for creating mock data in tests
class MockDataFactory {
  static const _uuid = Uuid();

  /// Create a mock participant
  static Participant createParticipant({
    String? id,
    String? name,
    String? email,
    String? eventId,
  }) {
    return Participant(
      id: id ?? _uuid.v4(),
      name: name ?? 'John Doe',
      email: email ?? 'john@example.com',
      eventId: eventId,
    );
  }

  /// Create a list of mock participants
  static List<Participant> createParticipants({
    int count = 3,
    String? eventId,
  }) {
    final names = ['John Doe', 'Jane Smith', 'Bob Johnson', 'Alice Brown'];
    final emails = [
      'john@example.com',
      'jane@example.com',
      'bob@example.com',
      'alice@example.com',
    ];

    return List.generate(
      count,
      (index) => createParticipant(
        name: names[index % names.length],
        email: emails[index % emails.length],
        eventId: eventId,
      ),
    );
  }

  /// Create a mock event
  static Event createEvent({
    String? id,
    String? name,
    DateTime? date,
    double? budget,
  }) {
    return Event(
      id: id ?? _uuid.v4(),
      name: name ?? 'Christmas 2024',
      date: date ?? DateTime.now().add(const Duration(days: 30)),
      budget: budget,
      createdAt: DateTime.now(),
    );
  }

  /// Create a mock match
  static SecretSantaMatch createMatch({
    String? id,
    String? giverId,
    String? receiverId,
    String? eventId,
  }) {
    return SecretSantaMatch(
      id: id ?? _uuid.v4(),
      giverId: giverId ?? _uuid.v4(),
      receiverId: receiverId ?? _uuid.v4(),
      eventId: eventId ?? _uuid.v4(),
    );
  }

  /// Create a list of mock matches
  static List<SecretSantaMatch> createMatches({
    required List<Participant> participants,
    String? eventId,
  }) {
    if (participants.length < 2) {
      return [];
    }

    final matches = <SecretSantaMatch>[];
    for (int i = 0; i < participants.length; i++) {
      final giver = participants[i];
      final receiver = participants[(i + 1) % participants.length];
      matches.add(
        createMatch(
          giverId: giver.id,
          receiverId: receiver.id,
          eventId: eventId ?? giver.eventId,
        ),
      );
    }
    return matches;
  }

  /// Create a mock reveal token
  static RevealToken createRevealToken({
    String? id,
    String? participantId,
    String? matchId,
    String? token,
    DateTime? expiresAt,
    bool isRevealed = false,
  }) {
    return RevealToken(
      id: id ?? _uuid.v4(),
      participantId: participantId ?? _uuid.v4(),
      matchId: matchId ?? _uuid.v4(),
      token: token ?? _uuid.v4(),
      expiresAt: expiresAt ?? DateTime.now().add(const Duration(days: 30)),
      isRevealed: isRevealed,
    );
  }
}
