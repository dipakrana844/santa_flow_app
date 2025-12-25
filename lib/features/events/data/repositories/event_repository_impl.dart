import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_local_data_source.dart';
import '../models/event_model.dart';

/// Implementation of EventRepository
class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource dataSource;

  EventRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final models = await dataSource.getEvents();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get events: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Event?>> getEventById(String id) async {
    try {
      final model = await dataSource.getEventById(id);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to get event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addEvent(Event event) async {
    try {
      final model = event.toModel();
      await dataSource.addEvent(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEvent(Event event) async {
    try {
      final model = event.toModel();
      await dataSource.updateEvent(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeEvent(String id) async {
    try {
      await dataSource.removeEvent(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearEvents() async {
    try {
      await dataSource.clearEvents();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear events: ${e.toString()}'));
    }
  }
}
