import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reveal_history.dart';
import '../../domain/repositories/reveal_history_repository.dart';
import '../datasources/reveal_history_local_data_source.dart';
import '../models/reveal_history_model.dart';

/// Implementation of RevealHistoryRepository
class RevealHistoryRepositoryImpl implements RevealHistoryRepository {
  final RevealHistoryLocalDataSource dataSource;

  RevealHistoryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<RevealHistory>>> getHistory() async {
    try {
      final models = await dataSource.getHistory();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<RevealHistory>>> getHistoryByEventId(
    String eventId,
  ) async {
    try {
      final models = await dataSource.getHistoryByEventId(eventId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get history by event: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<RevealHistory>>> getHistoryByParticipantId(
    String participantId,
  ) async {
    try {
      final models = await dataSource.getHistoryByParticipantId(participantId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get history by participant: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addHistory(RevealHistory history) async {
    try {
      final model = history.toModel();
      await dataSource.addHistory(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await dataSource.clearHistory();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeHistoryByEventId(String eventId) async {
    try {
      await dataSource.removeHistoryByEventId(eventId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to remove history by event: ${e.toString()}'),
      );
    }
  }
}
