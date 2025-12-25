import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reveal_token.dart';

/// Repository interface for reveal token operations
abstract class RevealTokenRepository {
  /// Get reveal token by token string
  Future<Either<Failure, RevealToken?>> getTokenByTokenString(String token);

  /// Get reveal token by ID
  Future<Either<Failure, RevealToken?>> getTokenById(String id);

  /// Get all tokens for a participant
  Future<Either<Failure, List<RevealToken>>> getTokensByParticipantId(
    String participantId,
  );

  /// Get all tokens for a match
  Future<Either<Failure, List<RevealToken>>> getTokensByMatchId(String matchId);

  /// Add a new reveal token
  Future<Either<Failure, void>> addToken(RevealToken token);

  /// Update a reveal token
  Future<Either<Failure, void>> updateToken(RevealToken token);

  /// Mark token as revealed
  Future<Either<Failure, void>> markTokenAsRevealed(
    String tokenId,
    DateTime revealedAt,
  );

  /// Clear all tokens
  Future<Either<Failure, void>> clearTokens();

  /// Remove all tokens for a specific match
  Future<Either<Failure, void>> removeTokensByMatchId(String matchId);
}
