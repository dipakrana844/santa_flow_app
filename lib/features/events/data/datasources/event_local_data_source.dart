import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/event_model.dart';

/// Abstract class defining the contract for event local data source
abstract class EventLocalDataSource {
  /// Get all events
  Future<List<EventModel>> getEvents();

  /// Get event by ID
  Future<EventModel?> getEventById(String id);

  /// Add a new event
  Future<void> addEvent(EventModel event);

  /// Update an event
  Future<void> updateEvent(EventModel event);

  /// Remove an event by ID
  Future<void> removeEvent(String id);

  /// Clear all events
  Future<void> clearEvents();
}

/// Implementation of EventLocalDataSource using Hive
class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Box<dynamic> _box;

  EventLocalDataSourceImpl(this._box);

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      final eventsList = <EventModel>[];
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
            final event = EventModel.fromJson(json);
            eventsList.add(event);
          }
        } catch (e) {
          // Skip corrupted entries but continue reading others
          continue;
        }
      }

      return eventsList;
    } catch (e) {
      throw Exception('Failed to get events: $e');
    }
  }

  @override
  Future<EventModel?> getEventById(String id) async {
    try {
      final data = _box.get(id);
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
        return EventModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get event: $e');
    }
  }

  @override
  Future<void> addEvent(EventModel event) async {
    try {
      final json = event.toJson();
      // Store as JSON string to ensure proper serialization of DateTime and other types
      final jsonString = jsonEncode(json);
      await _box.put(event.id, jsonString);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to add event: $e');
    }
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    try {
      final json = event.toJson();
      // Store as JSON string to ensure proper serialization of DateTime and other types
      final jsonString = jsonEncode(json);
      await _box.put(event.id, jsonString);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> removeEvent(String id) async {
    try {
      await _box.delete(id);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to remove event: $e');
    }
  }

  @override
  Future<void> clearEvents() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear events: $e');
    }
  }
}
