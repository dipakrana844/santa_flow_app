import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/reveal_history_model.dart';

/// Abstract class defining the contract for reveal history local data source
abstract class RevealHistoryLocalDataSource {
  /// Get all reveal history entries
  Future<List<RevealHistoryModel>> getHistory();

  /// Get history by event ID
  Future<List<RevealHistoryModel>> getHistoryByEventId(String eventId);

  /// Get history by participant ID
  Future<List<RevealHistoryModel>> getHistoryByParticipantId(
    String participantId,
  );

  /// Add a new history entry
  Future<void> addHistory(RevealHistoryModel history);

  /// Clear all history
  Future<void> clearHistory();

  /// Remove all history entries for a specific event
  Future<void> removeHistoryByEventId(String eventId);
}

/// Implementation of RevealHistoryLocalDataSource using Hive
class RevealHistoryLocalDataSourceImpl implements RevealHistoryLocalDataSource {
  final Box<dynamic> _box;

  RevealHistoryLocalDataSourceImpl(this._box);

  @override
  Future<List<RevealHistoryModel>> getHistory() async {
    try {
      final historyList = <RevealHistoryModel>[];
      final keys = _box.keys.toList();

      for (final key in keys) {
        try {
          final data = _box.get(key);
          if (data != null) {
            Map<String, dynamic> json;
            if (data is String) {
              json = jsonDecode(data) as Map<String, dynamic>;
            } else if (data is Map<String, dynamic>) {
              json = data;
            } else {
              continue;
            }
            final history = RevealHistoryModel.fromJson(json);
            historyList.add(history);
          }
        } catch (e) {
          continue;
        }
      }

      // Sort by revealedAt descending (most recent first)
      historyList.sort((a, b) => b.revealedAt.compareTo(a.revealedAt));

      return historyList;
    } catch (e) {
      throw Exception('Failed to get history: $e');
    }
  }

  @override
  Future<List<RevealHistoryModel>> getHistoryByEventId(String eventId) async {
    try {
      final allHistory = await getHistory();
      return allHistory.where((h) => h.eventId == eventId).toList();
    } catch (e) {
      throw Exception('Failed to get history by event: $e');
    }
  }

  @override
  Future<List<RevealHistoryModel>> getHistoryByParticipantId(
    String participantId,
  ) async {
    try {
      final allHistory = await getHistory();
      return allHistory.where((h) => h.participantId == participantId).toList();
    } catch (e) {
      throw Exception('Failed to get history by participant: $e');
    }
  }

  @override
  Future<void> addHistory(RevealHistoryModel history) async {
    try {
      final json = history.toJson();
      final jsonString = jsonEncode(json);
      await _box.put(history.id, jsonString);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to add history: $e');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }

  @override
  Future<void> removeHistoryByEventId(String eventId) async {
    try {
      final historyEntries = await getHistoryByEventId(eventId);
      for (final history in historyEntries) {
        await _box.delete(history.id);
      }
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to remove history by event: $e');
    }
  }
}
