import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/matching/domain/entities/secret_santa_match.dart';
import '../../../../../lib/features/matching/domain/repositories/match_repository.dart';
import '../../../../../lib/features/reveal/domain/entities/reveal_token.dart';
import '../../../../../lib/features/reveal/domain/repositories/reveal_token_repository.dart';
import '../../../../../lib/features/reveal/domain/usecases/get_match_by_token.dart';
import '../../../../helpers/mock_data.dart';

class MockRevealTokenRepository extends Mock implements RevealTokenRepository {}

class MockMatchRepository extends Mock implements MatchRepository {}

void main() {
  late GetMatchByToken getMatchByToken;
  late MockRevealTokenRepository mockRevealTokenRepository;
  late MockMatchRepository mockMatchRepository;

  setUp(() {
    mockRevealTokenRepository = MockRevealTokenRepository();
    mockMatchRepository = MockMatchRepository();
    getMatchByToken = GetMatchByToken(
      mockRevealTokenRepository,
      mockMatchRepository,
    );
  });

  group('GetMatchByToken', () {
    test('should return match when token and match are valid', () async {
      // Arrange
      const tokenString = 'valid-token-123';
      final revealToken = MockDataFactory.createRevealToken(
        token: tokenString,
        matchId: 'match-id-123',
      );
      final match = MockDataFactory.createMatch(
        id: 'match-id-123',
        giverId: revealToken.participantId,
      );

      when(
        () => mockRevealTokenRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => Right(revealToken));
      when(
        () => mockMatchRepository.getMatchById(any()),
      ).thenAnswer((_) async => Right(match));

      // Act
      final result = await getMatchByToken(tokenString);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedMatch,
      ) {
        expect(retrievedMatch.id, match.id);
        expect(retrievedMatch.giverId, match.giverId);
      });
      verify(
        () => mockRevealTokenRepository.getTokenByTokenString(tokenString),
      ).called(1);
      verify(
        () => mockMatchRepository.getMatchById(revealToken.matchId),
      ).called(1);
    });

    test('should return ValidationFailure when token not found', () async {
      // Arrange
      const tokenString = 'non-existent-token';
      when(
        () => mockRevealTokenRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await getMatchByToken(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Token not found or invalid');
      }, (_) => fail('Should return failure'));
      verify(
        () => mockRevealTokenRepository.getTokenByTokenString(tokenString),
      ).called(1);
      verifyNever(() => mockMatchRepository.getMatchById(any()));
    });

    test('should return ValidationFailure when match not found', () async {
      // Arrange
      const tokenString = 'valid-token-no-match';
      final revealToken = MockDataFactory.createRevealToken(
        token: tokenString,
        matchId: 'non-existent-match-id',
      );

      when(
        () => mockRevealTokenRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => Right(revealToken));
      when(
        () => mockMatchRepository.getMatchById(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await getMatchByToken(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Match not found for this token');
      }, (_) => fail('Should return failure'));
      verify(
        () => mockRevealTokenRepository.getTokenByTokenString(tokenString),
      ).called(1);
      verify(
        () => mockMatchRepository.getMatchById(revealToken.matchId),
      ).called(1);
    });

    test('should propagate token repository failure', () async {
      // Arrange
      const tokenString = 'error-token';
      const failure = CacheFailure('Database error');
      when(
        () => mockRevealTokenRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await getMatchByToken(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Database error');
      }, (_) => fail('Should return failure'));
      verify(
        () => mockRevealTokenRepository.getTokenByTokenString(tokenString),
      ).called(1);
      verifyNever(() => mockMatchRepository.getMatchById(any()));
    });

    test('should propagate match repository failure', () async {
      // Arrange
      const tokenString = 'valid-token';
      final revealToken = MockDataFactory.createRevealToken(
        token: tokenString,
        matchId: 'match-id-123',
      );
      const failure = CacheFailure('Match database error');

      when(
        () => mockRevealTokenRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => Right(revealToken));
      when(
        () => mockMatchRepository.getMatchById(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await getMatchByToken(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Match database error');
      }, (_) => fail('Should return failure'));
      verify(
        () => mockRevealTokenRepository.getTokenByTokenString(tokenString),
      ).called(1);
      verify(
        () => mockMatchRepository.getMatchById(revealToken.matchId),
      ).called(1);
    });
  });
}
