import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reveal_token.dart';
import '../../domain/repositories/reveal_token_repository.dart';
import '../datasources/reveal_token_local_data_source.dart';
import '../models/reveal_token_model.dart';

/// Implementation of RevealTokenRepository
class RevealTokenRepositoryImpl implements RevealTokenRepository {
  final RevealTokenLocalDataSource dataSource;

  RevealTokenRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, RevealToken?>> getTokenByTokenString(
    String token,
  ) async {
    try {
      final model = await dataSource.getTokenByTokenString(token);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to get token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, RevealToken?>> getTokenById(String id) async {
    try {
      final model = await dataSource.getTokenById(id);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to get token by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<RevealToken>>> getTokensByParticipantId(
    String participantId,
  ) async {
    try {
      final models = await dataSource.getTokensByParticipantId(participantId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get tokens by participant: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<RevealToken>>> getTokensByMatchId(
    String matchId,
  ) async {
    try {
      final models = await dataSource.getTokensByMatchId(matchId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get tokens by match: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addToken(RevealToken token) async {
    try {
      final model = token.toModel();
      await dataSource.addToken(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateToken(RevealToken token) async {
    try {
      final model = token.toModel();
      await dataSource.updateToken(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markTokenAsRevealed(
    String tokenId,
    DateTime revealedAt,
  ) async {
    try {
      await dataSource.markTokenAsRevealed(tokenId, revealedAt);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to mark token as revealed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearTokens() async {
    try {
      await dataSource.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear tokens: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTokensByMatchId(String matchId) async {
    try {
      await dataSource.removeTokensByMatchId(matchId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to remove tokens by match: ${e.toString()}'),
      );
    }
  }
}
