import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/secret_santa_match.dart';

/// Repository interface for match operations
abstract class MatchRepository {
  /// Get all matches
  Future<Either<Failure, List<SecretSantaMatch>>> getMatches();

  /// Get matches by event ID
  Future<Either<Failure, List<SecretSantaMatch>>> getMatchesByEventId(
    String eventId,
  );

  /// Get match by giver ID
  Future<Either<Failure, SecretSantaMatch?>> getMatchByGiverId(
    String giverId,
    String eventId,
  );

  /// Get match by ID
  Future<Either<Failure, SecretSantaMatch?>> getMatchById(String matchId);

  /// Save matches
  Future<Either<Failure, void>> saveMatches(List<SecretSantaMatch> matches);

  /// Clear all matches
  Future<Either<Failure, void>> clearMatches();

  /// Clear matches for a specific event
  Future<Either<Failure, void>> clearMatchesByEventId(String eventId);
}
