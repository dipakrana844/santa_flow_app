import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../features/events/data/models/event_model.dart';
import '../../features/matching/data/models/match_model.dart';
import '../../features/participants/data/models/participant_model.dart';
import '../../features/reveal/data/models/reveal_token_model.dart';
import 'hive_init.dart';

/// Initialize dummy data for debug mode
/// This will populate the app with sample data for testing
class DummyData {
  DummyData._();

  /// Initialize dummy data only in debug mode
  static Future<void> initialize() async {
    if (!kDebugMode) {
      return; // Only run in debug mode
    }

    try {
      // Check if data already exists
      final eventsBox = HiveInit.eventsBox;
      if (eventsBox.isNotEmpty) {
        debugPrint('Dummy data already exists. Skipping initialization.');
        return;
      }

      debugPrint('Initializing dummy data...');

      // Create sample events
      final events = _createSampleEvents();
      for (final event in events) {
        final json = event.toJson();
        final jsonString = jsonEncode(json);
        await eventsBox.put(event.id, jsonString);
      }
      await eventsBox.flush();

      // Create sample participants
      final participants = _createSampleParticipants(events);
      final participantsBox = HiveInit.participantsBox;
      for (final participant in participants) {
        final json = participant.toJson();
        final jsonString = jsonEncode(json);
        await participantsBox.put(participant.id, jsonString);
      }
      await participantsBox.flush();

      // Create sample matches
      final matches = _createSampleMatches(participants, events);
      final matchesBox = HiveInit.matchesBox;
      for (final match in matches) {
        final json = match.toJson();
        final jsonString = jsonEncode(json);
        await matchesBox.put(match.id, jsonString);
      }
      await matchesBox.flush();

      // Create sample reveal tokens
      final revealTokens = _createSampleRevealTokens(participants, matches);
      final revealTokensBox = HiveInit.revealTokensBox;
      for (final token in revealTokens) {
        final json = token.toJson();
        final jsonString = jsonEncode(json);
        await revealTokensBox.put(token.id, jsonString);
      }
      await revealTokensBox.flush();

      debugPrint('Dummy data initialized successfully!');
    } catch (e) {
      debugPrint('Error initializing dummy data: $e');
    }
  }

  /// Create sample events
  static List<EventModel> _createSampleEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: 'event-001',
        name: 'Christmas 2024',
        date: DateTime(2024, 12, 25),
        budget: 50.0,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      EventModel(
        id: 'event-002',
        name: 'New Year Party',
        date: DateTime(2025, 1, 1),
        budget: 75.0,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      EventModel(
        id: 'event-003',
        name: 'Office Secret Santa',
        date: DateTime(2024, 12, 20),
        budget: 30.0,
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ];
  }

  /// Create sample participants
  static List<ParticipantModel> _createSampleParticipants(
    List<EventModel> events,
  ) {
    final participants = <ParticipantModel>[];

    // Participants for Christmas 2024
    final christmasEvent = events[0];
    participants.addAll([
      ParticipantModel(
        id: 'participant-001',
        name: 'Alice Johnson',
        email: 'alice.johnson@example.com',
        eventId: christmasEvent.id,
      ),
      ParticipantModel(
        id: 'participant-002',
        name: 'Bob Smith',
        email: 'bob.smith@example.com',
        eventId: christmasEvent.id,
      ),
      ParticipantModel(
        id: 'participant-003',
        name: 'Charlie Brown',
        email: 'charlie.brown@example.com',
        eventId: christmasEvent.id,
      ),
      ParticipantModel(
        id: 'participant-004',
        name: 'Diana Prince',
        email: 'diana.prince@example.com',
        eventId: christmasEvent.id,
      ),
      ParticipantModel(
        id: 'participant-005',
        name: 'Eve Williams',
        email: 'eve.williams@example.com',
        eventId: christmasEvent.id,
      ),
    ]);

    // Participants for New Year Party
    final newYearEvent = events[1];
    participants.addAll([
      ParticipantModel(
        id: 'participant-006',
        name: 'Frank Miller',
        email: 'frank.miller@example.com',
        eventId: newYearEvent.id,
      ),
      ParticipantModel(
        id: 'participant-007',
        name: 'Grace Lee',
        email: 'grace.lee@example.com',
        eventId: newYearEvent.id,
      ),
      ParticipantModel(
        id: 'participant-008',
        name: 'Henry Davis',
        email: 'henry.davis@example.com',
        eventId: newYearEvent.id,
      ),
    ]);

    // Participants for Office Secret Santa
    final officeEvent = events[2];
    participants.addAll([
      ParticipantModel(
        id: 'participant-009',
        name: 'Ivy Chen',
        email: 'ivy.chen@example.com',
        eventId: officeEvent.id,
      ),
      ParticipantModel(
        id: 'participant-010',
        name: 'Jack Wilson',
        email: 'jack.wilson@example.com',
        eventId: officeEvent.id,
      ),
      ParticipantModel(
        id: 'participant-011',
        name: 'Kate Martinez',
        email: 'kate.martinez@example.com',
        eventId: officeEvent.id,
      ),
      ParticipantModel(
        id: 'participant-012',
        name: 'Liam Anderson',
        email: 'liam.anderson@example.com',
        eventId: officeEvent.id,
      ),
    ]);

    return participants;
  }

  /// Create sample matches
  static List<MatchModel> _createSampleMatches(
    List<ParticipantModel> participants,
    List<EventModel> events,
  ) {
    final matches = <MatchModel>[];

    // Matches for Christmas 2024 (5 participants)
    final christmasParticipants = participants
        .where((p) => p.eventId == events[0].id)
        .toList();
    if (christmasParticipants.length >= 3) {
      // Create circular matches: A->B, B->C, C->D, D->E, E->A
      for (int i = 0; i < christmasParticipants.length; i++) {
        final giver = christmasParticipants[i];
        final receiver =
            christmasParticipants[(i + 1) % christmasParticipants.length];
        matches.add(
          MatchModel(
            id: 'match-${giver.id}-${receiver.id}',
            giverId: giver.id,
            receiverId: receiver.id,
            eventId: events[0].id,
          ),
        );
      }
    }

    // Matches for New Year Party (3 participants)
    final newYearParticipants = participants
        .where((p) => p.eventId == events[1].id)
        .toList();
    if (newYearParticipants.length >= 3) {
      for (int i = 0; i < newYearParticipants.length; i++) {
        final giver = newYearParticipants[i];
        final receiver =
            newYearParticipants[(i + 1) % newYearParticipants.length];
        matches.add(
          MatchModel(
            id: 'match-${giver.id}-${receiver.id}',
            giverId: giver.id,
            receiverId: receiver.id,
            eventId: events[1].id,
          ),
        );
      }
    }

    // Matches for Office Secret Santa (4 participants)
    final officeParticipants = participants
        .where((p) => p.eventId == events[2].id)
        .toList();
    if (officeParticipants.length >= 3) {
      for (int i = 0; i < officeParticipants.length; i++) {
        final giver = officeParticipants[i];
        final receiver =
            officeParticipants[(i + 1) % officeParticipants.length];
        matches.add(
          MatchModel(
            id: 'match-${giver.id}-${receiver.id}',
            giverId: giver.id,
            receiverId: receiver.id,
            eventId: events[2].id,
          ),
        );
      }
    }

    return matches;
  }

  /// Create sample reveal tokens
  static List<RevealTokenModel> _createSampleRevealTokens(
    List<ParticipantModel> participants,
    List<MatchModel> matches,
  ) {
    final tokens = <RevealTokenModel>[];
    final now = DateTime.now();

    // Create tokens for first 3 matches of Christmas event
    final christmasMatches = matches
        .where((m) => m.eventId == 'event-001')
        .take(3)
        .toList();

    for (final match in christmasMatches) {
      final participant = participants.firstWhere(
        (p) => p.id == match.giverId,
        orElse: () => participants.first,
      );

      tokens.add(
        RevealTokenModel(
          id: 'token-${match.id}',
          participantId: participant.id,
          matchId: match.id,
          token: 'token-${match.id}-${DateTime.now().millisecondsSinceEpoch}',
          expiresAt: now.add(const Duration(days: 30)),
          isRevealed: false,
        ),
      );
    }

    return tokens;
  }

  /// Clear all dummy data (useful for testing)
  static Future<void> clearAll() async {
    if (!kDebugMode) {
      return; // Only run in debug mode
    }

    try {
      await HiveInit.eventsBox.clear();
      await HiveInit.participantsBox.clear();
      await HiveInit.matchesBox.clear();
      await HiveInit.revealTokensBox.clear();
      await HiveInit.revealHistoryBox.clear();
      debugPrint('All dummy data cleared!');
    } catch (e) {
      debugPrint('Error clearing dummy data: $e');
    }
  }
}
