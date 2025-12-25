import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/reveal/data/datasources/reveal_token_local_data_source.dart';
import '../../../../../lib/features/reveal/data/models/reveal_token_model.dart';
import '../../../../../lib/features/reveal/data/repositories/reveal_token_repository_impl.dart';
import '../../../../../lib/features/reveal/domain/entities/reveal_token.dart';
import '../../../../helpers/mock_data.dart';

class MockRevealTokenLocalDataSource extends Mock
    implements RevealTokenLocalDataSource {}

void main() {
  late RevealTokenRepositoryImpl repository;
  late MockRevealTokenLocalDataSource mockDataSource;

  setUpAll(() {
    final revealToken = MockDataFactory.createRevealToken();
    registerFallbackValue(revealToken.toModel());
  });

  setUp(() {
    mockDataSource = MockRevealTokenLocalDataSource();
    repository = RevealTokenRepositoryImpl(mockDataSource);
  });

  group('getTokenByTokenString', () {
    test('should return token when found', () async {
      // Arrange
      const tokenString = 'test-token-123';
      final revealToken = MockDataFactory.createRevealToken(token: tokenString);
      final model = revealToken.toModel();

      when(
        () => mockDataSource.getTokenByTokenString(any()),
      ).thenAnswer((_) async => model);

      // Act
      final result = await repository.getTokenByTokenString(tokenString);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedToken,
      ) {
        expect(retrievedToken, isNotNull);
        expect(retrievedToken!.token, tokenString);
      });
      verify(() => mockDataSource.getTokenByTokenString(tokenString)).called(1);
    });

    test('should return null when token not found', () async {
      // Arrange
      const tokenString = 'non-existent-token';
      when(
        () => mockDataSource.getTokenByTokenString(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getTokenByTokenString(tokenString);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (retrievedToken) => expect(retrievedToken, null),
      );
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const tokenString = 'error-token';
      when(
        () => mockDataSource.getTokenByTokenString(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getTokenByTokenString(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get token'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getTokenById', () {
    test('should return token when found', () async {
      // Arrange
      const tokenId = 'token-id-123';
      final revealToken = MockDataFactory.createRevealToken(id: tokenId);
      final model = revealToken.toModel();

      when(
        () => mockDataSource.getTokenById(any()),
      ).thenAnswer((_) async => model);

      // Act
      final result = await repository.getTokenById(tokenId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedToken,
      ) {
        expect(retrievedToken, isNotNull);
        expect(retrievedToken!.id, tokenId);
      });
      verify(() => mockDataSource.getTokenById(tokenId)).called(1);
    });

    test('should return null when token not found', () async {
      // Arrange
      const tokenId = 'non-existent-id';
      when(
        () => mockDataSource.getTokenById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getTokenById(tokenId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (retrievedToken) => expect(retrievedToken, null),
      );
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const tokenId = 'error-id';
      when(
        () => mockDataSource.getTokenById(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getTokenById(tokenId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get token by id'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getTokensByParticipantId', () {
    test('should return tokens for participant', () async {
      // Arrange
      const participantId = 'participant-123';
      final tokens = [
        MockDataFactory.createRevealToken(participantId: participantId),
        MockDataFactory.createRevealToken(participantId: participantId),
      ];
      final models = tokens.map((t) => t.toModel()).toList();

      when(
        () => mockDataSource.getTokensByParticipantId(any()),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getTokensByParticipantId(participantId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedTokens,
      ) {
        expect(retrievedTokens.length, 2);
        expect(
          retrievedTokens.every((t) => t.participantId == participantId),
          true,
        );
      });
      verify(
        () => mockDataSource.getTokensByParticipantId(participantId),
      ).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const participantId = 'participant-123';
      when(
        () => mockDataSource.getTokensByParticipantId(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getTokensByParticipantId(participantId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(
          failure.message,
          contains('Failed to get tokens by participant'),
        );
      }, (_) => fail('Should return failure'));
    });
  });

  group('getTokensByMatchId', () {
    test('should return tokens for match', () async {
      // Arrange
      const matchId = 'match-123';
      final tokens = [
        MockDataFactory.createRevealToken(matchId: matchId),
        MockDataFactory.createRevealToken(matchId: matchId),
      ];
      final models = tokens.map((t) => t.toModel()).toList();

      when(
        () => mockDataSource.getTokensByMatchId(any()),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getTokensByMatchId(matchId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedTokens,
      ) {
        expect(retrievedTokens.length, 2);
        expect(retrievedTokens.every((t) => t.matchId == matchId), true);
      });
      verify(() => mockDataSource.getTokensByMatchId(matchId)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const matchId = 'match-123';
      when(
        () => mockDataSource.getTokensByMatchId(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getTokensByMatchId(matchId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get tokens by match'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('addToken', () {
    test('should add token successfully', () async {
      // Arrange
      final token = MockDataFactory.createRevealToken();
      final model = token.toModel();

      when(
        () => mockDataSource.addToken(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.addToken(token);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.addToken(model)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final token = MockDataFactory.createRevealToken();
      when(
        () => mockDataSource.addToken(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.addToken(token);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to add token'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('updateToken', () {
    test('should update token successfully', () async {
      // Arrange
      final token = MockDataFactory.createRevealToken();
      final model = token.toModel();

      when(
        () => mockDataSource.updateToken(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateToken(token);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.updateToken(model)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final token = MockDataFactory.createRevealToken();
      when(
        () => mockDataSource.updateToken(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.updateToken(token);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to update token'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('markTokenAsRevealed', () {
    test('should mark token as revealed successfully', () async {
      // Arrange
      const tokenId = 'token-123';
      final revealedAt = DateTime.now();
      when(
        () => mockDataSource.markTokenAsRevealed(any(), any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.markTokenAsRevealed(tokenId, revealedAt);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockDataSource.markTokenAsRevealed(tokenId, revealedAt),
      ).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const tokenId = 'token-123';
      final revealedAt = DateTime.now();
      when(
        () => mockDataSource.markTokenAsRevealed(any(), any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.markTokenAsRevealed(tokenId, revealedAt);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to mark token as revealed'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('clearTokens', () {
    test('should clear all tokens successfully', () async {
      // Arrange
      when(
        () => mockDataSource.clearTokens(),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.clearTokens();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.clearTokens()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.clearTokens(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.clearTokens();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to clear tokens'));
      }, (_) => fail('Should return failure'));
    });
  });
}
