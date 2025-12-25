import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/participant.dart';
import '../../domain/repositories/participant_repository.dart';
import '../datasources/participant_local_data_source.dart';
import '../models/participant_model.dart';

/// Implementation of ParticipantRepository
class ParticipantRepositoryImpl implements ParticipantRepository {
  final ParticipantLocalDataSource dataSource;

  ParticipantRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Participant>>> getParticipants() async {
    try {
      final models = await dataSource.getParticipants();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get participants: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Participant>>> getParticipantsByEventId(
    String eventId,
  ) async {
    try {
      final models = await dataSource.getParticipantsByEventId(eventId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get participants by event: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addParticipant(Participant participant) async {
    try {
      final model = participant.toModel();
      await dataSource.addParticipant(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add participant: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeParticipant(String id) async {
    try {
      await dataSource.removeParticipant(id);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to remove participant: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearParticipants() async {
    try {
      await dataSource.clearParticipants();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to clear participants: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkParticipantExists(
    String email,
    String eventId,
  ) async {
    try {
      final exists = await dataSource.checkParticipantExists(email, eventId);
      return Right(exists);
    } catch (e) {
      return Left(
        CacheFailure('Failed to check participant existence: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeParticipantsByEventId(
    String eventId,
  ) async {
    try {
      await dataSource.removeParticipantsByEventId(eventId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to remove participants by event: ${e.toString()}'),
      );
    }
  }
}
