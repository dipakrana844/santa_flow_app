import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/match_model.dart';

/// Abstract class defining the contract for match local data source
abstract class MatchLocalDataSource {
  /// Get all matches
  Future<List<MatchModel>> getMatches();

  /// Get matches by event ID
  Future<List<MatchModel>> getMatchesByEventId(String eventId);

  /// Get match by giver ID
  Future<MatchModel?> getMatchByGiverId(String giverId, String eventId);

  /// Get match by ID
  Future<MatchModel?> getMatchById(String matchId);

  /// Save matches
  Future<void> saveMatches(List<MatchModel> matches);

  /// Clear all matches
  Future<void> clearMatches();

  /// Clear matches for a specific event
  Future<void> clearMatchesByEventId(String eventId);
}

/// Implementation of MatchLocalDataSource using Hive
class MatchLocalDataSourceImpl implements MatchLocalDataSource {
  final Box<dynamic> _box;

  MatchLocalDataSourceImpl(this._box);

  @override
  Future<List<MatchModel>> getMatches() async {
    try {
      final matchesList = <MatchModel>[];
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
            final match = MatchModel.fromJson(json);
            matchesList.add(match);
          }
        } catch (e) {
          // Skip corrupted entries but continue reading others
          continue;
        }
      }

      return matchesList;
    } catch (e) {
      throw Exception('Failed to get matches: $e');
    }
  }

  @override
  Future<List<MatchModel>> getMatchesByEventId(String eventId) async {
    try {
      final allMatches = await getMatches();
      return allMatches.where((m) => m.eventId == eventId).toList();
    } catch (e) {
      throw Exception('Failed to get matches by event: $e');
    }
  }

  @override
  Future<MatchModel?> getMatchByGiverId(String giverId, String eventId) async {
    try {
      final matches = await getMatchesByEventId(eventId);
      return matches.firstWhere(
        (m) => m.giverId == giverId,
        orElse: () => throw StateError('No match found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MatchModel?> getMatchById(String matchId) async {
    try {
      final data = _box.get(matchId);
      if (data != null) {
        Map<String, dynamic> json;
        if (data is String) {
          // Data stored as JSON string
          json = jsonDecode(data) as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          // Legacy format - data stored as Map
          json = data;
        } else {
          return null;
        }
        return MatchModel.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveMatches(List<MatchModel> matches) async {
    try {
      for (final match in matches) {
        final json = match.toJson();
        // Store as JSON string to ensure proper serialization
        final jsonString = jsonEncode(json);
        await _box.put(match.id, jsonString);
      }
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to save matches: $e');
    }
  }

  @override
  Future<void> clearMatches() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear matches: $e');
    }
  }

  @override
  Future<void> clearMatchesByEventId(String eventId) async {
    try {
      final matches = await getMatchesByEventId(eventId);
      for (final match in matches) {
        await _box.delete(match.id);
      }
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to clear matches by event: $e');
    }
  }
}
