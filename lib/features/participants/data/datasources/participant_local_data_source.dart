import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/participant_model.dart';

/// Abstract class defining the contract for participant local data source
abstract class ParticipantLocalDataSource {
  /// Get all participants
  Future<List<ParticipantModel>> getParticipants();

  /// Get participants by event ID
  Future<List<ParticipantModel>> getParticipantsByEventId(String eventId);

  /// Add a new participant
  Future<void> addParticipant(ParticipantModel participant);

  /// Remove a participant by ID
  Future<void> removeParticipant(String id);

  /// Clear all participants
  Future<void> clearParticipants();

  /// Check if a participant with the given email exists for the event
  Future<bool> checkParticipantExists(String email, String eventId);

  /// Remove all participants for a specific event
  Future<void> removeParticipantsByEventId(String eventId);
}

/// Implementation of ParticipantLocalDataSource using Hive
class ParticipantLocalDataSourceImpl implements ParticipantLocalDataSource {
  final Box<dynamic> _box;

  ParticipantLocalDataSourceImpl(this._box);

  @override
  Future<List<ParticipantModel>> getParticipants() async {
    try {
      final participantsList = <ParticipantModel>[];
      final keys = _box.keys.toList();

      for (final key in keys) {
        try {
          final data = _box.get(key);
          if (data != null) {
            Map<String, dynamic> json;
            if (data is String) {
              // Data stored as JSON string
              json = jsonDecode(data) as Map<String, dynamic>;
            } else if (data is Map<String, dynamic>) {
              // Legacy format - data stored as Map
              json = data;
            } else {
              continue;
            }
            final participant = ParticipantModel.fromJson(json);
            participantsList.add(participant);
          }
        } catch (e) {
          // Skip corrupted entries but continue reading others
          continue;
        }
      }

      return participantsList;
    } catch (e) {
      throw Exception('Failed to get participants: $e');
    }
  }

  @override
  Future<List<ParticipantModel>> getParticipantsByEventId(
    String eventId,
  ) async {
    try {
      final allParticipants = await getParticipants();
      return allParticipants.where((p) => p.eventId == eventId).toList();
    } catch (e) {
      throw Exception('Failed to get participants by event: $e');
    }
  }

  @override
  Future<void> addParticipant(ParticipantModel participant) async {
    try {
      final json = participant.toJson();
      // Store as JSON string to ensure proper serialization
      final jsonString = jsonEncode(json);
      await _box.put(participant.id, jsonString);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  @override
  Future<void> removeParticipant(String id) async {
    try {
      await _box.delete(id);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to remove participant: $e');
    }
  }

  @override
  Future<void> clearParticipants() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear participants: $e');
    }
  }

  @override
  Future<bool> checkParticipantExists(String email, String eventId) async {
    try {
      final participants = await getParticipantsByEventId(eventId);
      return participants.any(
        (p) => p.email.toLowerCase().trim() == email.toLowerCase().trim(),
      );
    } catch (e) {
      throw Exception('Failed to check participant existence: $e');
    }
  }

  @override
  Future<void> removeParticipantsByEventId(String eventId) async {
    try {
      final participants = await getParticipantsByEventId(eventId);
      for (final participant in participants) {
        await _box.delete(participant.id);
      }
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to remove participants by event: $e');
    }
  }
}
