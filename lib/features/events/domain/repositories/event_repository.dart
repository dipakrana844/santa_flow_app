import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event.dart';

/// Repository interface for event operations
abstract class EventRepository {
  /// Get all events
  Future<Either<Failure, List<Event>>> getEvents();

  /// Get event by ID
  Future<Either<Failure, Event?>> getEventById(String id);

  /// Add a new event
  Future<Either<Failure, void>> addEvent(Event event);

  /// Update an event
  Future<Either<Failure, void>> updateEvent(Event event);

  /// Remove an event by ID
  Future<Either<Failure, void>> removeEvent(String id);

  /// Clear all events
  Future<Either<Failure, void>> clearEvents();
}
