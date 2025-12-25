import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/secret_santa_match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_local_data_source.dart';
import '../models/match_model.dart';

/// Implementation of MatchRepository
class MatchRepositoryImpl implements MatchRepository {
  final MatchLocalDataSource dataSource;

  MatchRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<SecretSantaMatch>>> getMatches() async {
    try {
      final models = await dataSource.getMatches();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get matches: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SecretSantaMatch>>> getMatchesByEventId(
    String eventId,
  ) async {
    try {
      final models = await dataSource.getMatchesByEventId(eventId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get matches by event: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, SecretSantaMatch?>> getMatchByGiverId(
    String giverId,
    String eventId,
  ) async {
    try {
      final model = await dataSource.getMatchByGiverId(giverId, eventId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(
        CacheFailure('Failed to get match by giver: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, SecretSantaMatch?>> getMatchById(
    String matchId,
  ) async {
    try {
      final model = await dataSource.getMatchById(matchId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to get match by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveMatches(
    List<SecretSantaMatch> matches,
  ) async {
    try {
      final models = matches.map((match) => match.toModel()).toList();
      await dataSource.saveMatches(models);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save matches: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearMatches() async {
    try {
      await dataSource.clearMatches();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear matches: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearMatchesByEventId(String eventId) async {
    try {
      await dataSource.clearMatchesByEventId(eventId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to clear matches by event: ${e.toString()}'),
      );
    }
  }
}
