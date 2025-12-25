import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../matching/domain/entities/secret_santa_match.dart';
import '../../../matching/domain/repositories/match_repository.dart';
import '../repositories/reveal_token_repository.dart';

/// Use case to get a match by reveal token
class GetMatchByToken {
  final RevealTokenRepository revealTokenRepository;
  final MatchRepository matchRepository;

  GetMatchByToken(this.revealTokenRepository, this.matchRepository);

  /// Get match associated with a token
  ///
  /// Returns [Left] with [Failure] if:
  /// - Token not found or invalid
  /// - Match not found
  ///
  /// Returns [Right] with [SecretSantaMatch] on success
  Future<Either<Failure, SecretSantaMatch>> call(String token) async {
    // First, get the token
    final tokenResult = await revealTokenRepository.getTokenByTokenString(
      token,
    );

    return tokenResult.fold((failure) => Left(failure), (tokenEntity) async {
      if (tokenEntity == null) {
        return const Left(ValidationFailure('Token not found or invalid'));
      }

      // Get the match using matchId from token
      final matchResult = await matchRepository.getMatchById(
        tokenEntity.matchId,
      );

      return matchResult.fold((failure) => Left(failure), (match) {
        if (match == null) {
          return const Left(
            ValidationFailure('Match not found for this token'),
          );
        }
        return Right(match);
      });
    });
  }
}
