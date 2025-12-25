import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../entities/reveal_token.dart';
import '../../../matching/domain/entities/secret_santa_match.dart';

/// Use case to generate reveal tokens for matches
class GenerateRevealTokens {
  final _uuid = const Uuid();

  /// Generate reveal tokens for a list of matches
  ///
  /// Each match gets a unique token that expires after 30 days
  Either<Failure, List<RevealToken>> call(List<SecretSantaMatch> matches) {
    try {
      final tokens = matches.map((match) {
        return RevealToken(
          id: _uuid.v4(),
          participantId: match.giverId,
          matchId: match.id,
          token: _uuid.v4(),
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );
      }).toList();

      return Right(tokens);
    } catch (e) {
      return Left(
        ValidationFailure('Failed to generate tokens: ${e.toString()}'),
      );
    }
  }
}
