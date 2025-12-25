import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reveal_token.dart';
import '../repositories/reveal_token_repository.dart';

/// Use case to validate a reveal token
class ValidateRevealToken {
  final RevealTokenRepository repository;

  ValidateRevealToken(this.repository);

  /// Validate a token string
  ///
  /// Returns [Left] with [ValidationFailure] if:
  /// - Token not found
  /// - Token is expired
  /// - Token is already revealed
  ///
  /// Returns [Right] with [RevealToken] if valid
  Future<Either<Failure, RevealToken>> call(String token) async {
    final result = await repository.getTokenByTokenString(token);

    return result.fold((failure) => Left(failure), (tokenEntity) {
      if (tokenEntity == null) {
        return const Left(ValidationFailure('Token not found or invalid'));
      }

      if (tokenEntity.isExpired) {
        return const Left(ValidationFailure('Token has expired'));
      }

      if (tokenEntity.isRevealed) {
        return const Left(ValidationFailure('Token has already been revealed'));
      }

      if (!tokenEntity.isValid) {
        return const Left(ValidationFailure('Token is not valid'));
      }

      return Right(tokenEntity);
    });
  }
}
