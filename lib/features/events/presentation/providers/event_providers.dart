import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/hive_init.dart';
import '../../data/datasources/event_local_data_source.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

part 'event_providers.g.dart';

/// Provider for events Hive box
@riverpod
Box<dynamic> eventsBox(Ref ref) {
  return HiveInit.eventsBox;
}

/// Provider for event local data source
@riverpod
EventLocalDataSource eventLocalDataSource(Ref ref) {
  final box = ref.watch(eventsBoxProvider);
  return EventLocalDataSourceImpl(box);
}

/// Provider for event repository
@riverpod
EventRepository eventRepository(Ref ref) {
  final dataSource = ref.watch(eventLocalDataSourceProvider);
  return EventRepositoryImpl(dataSource);
}

/// Provider for events list
@riverpod
Future<List<Event>> events(Ref ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  final result = await repository.getEvents();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (events) => events,
  );
}

/// Provider for current selected event ID
@riverpod
class CurrentEventId extends _$CurrentEventId {
  static const String _key = 'current_event_id';

  @override
  FutureOr<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getString(_key);

    // If no event selected, get first event or return null
    if (eventId == null) {
      final eventsList = await ref.watch(eventsProvider.future);
      if (eventsList.isNotEmpty) {
        await setCurrentEvent(eventsList.first.id);
        return eventsList.first.id;
      }
    }

    return eventId;
  }

  /// Set the current event ID
  Future<void> setCurrentEvent(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, eventId);
    state = AsyncData(eventId);
  }

  /// Clear the current event
  Future<void> clearCurrentEvent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const AsyncData(null);
  }
}

/// Provider for current event entity
@riverpod
Future<Event?> currentEvent(Ref ref) async {
  final eventId = await ref.watch(currentEventIdProvider.future);
  if (eventId == null) return null;

  final repository = ref.watch(eventRepositoryProvider);
  final result = await repository.getEventById(eventId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (event) => event,
  );
}

/// Provider for event by ID (family provider)
@riverpod
Future<Event?> eventById(Ref ref, String eventId) async {
  final repository = ref.watch(eventRepositoryProvider);
  final result = await repository.getEventById(eventId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (event) => event,
  );
}
