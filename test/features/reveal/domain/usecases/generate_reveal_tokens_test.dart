import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/matching/domain/entities/secret_santa_match.dart';
import '../../../../../lib/features/reveal/domain/entities/reveal_token.dart';
import '../../../../../lib/features/reveal/domain/usecases/generate_reveal_tokens.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  late GenerateRevealTokens generateRevealTokens;

  setUp(() {
    generateRevealTokens = GenerateRevealTokens();
  });

  group('GenerateRevealTokens', () {
    test('should generate tokens for multiple matches', () {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 5);
      final matches = MockDataFactory.createMatches(participants: participants);

      // Act
      final result = generateRevealTokens(matches);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        expect(tokens.length, matches.length);
        for (int i = 0; i < tokens.length; i++) {
          expect(tokens[i].participantId, matches[i].giverId);
          expect(tokens[i].matchId, matches[i].id);
        }
      });
    });

    test('should generate unique tokens for each match', () {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 5);
      final matches = MockDataFactory.createMatches(participants: participants);

      // Act
      final result = generateRevealTokens(matches);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        // Check all token IDs are unique
        final tokenIds = tokens.map((t) => t.id).toSet();
        expect(tokenIds.length, tokens.length);

        // Check all token strings are unique
        final tokenStrings = tokens.map((t) => t.token).toSet();
        expect(tokenStrings.length, tokens.length);
      });
    });

    test('should set expiration date to 30 days from now', () {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 3);
      final matches = MockDataFactory.createMatches(participants: participants);
      final now = DateTime.now();
      final expectedExpiration = now.add(const Duration(days: 30));

      // Act
      final result = generateRevealTokens(matches);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        for (final token in tokens) {
          // Allow 1 second tolerance for test execution time
          final difference = token.expiresAt.difference(expectedExpiration);
          expect(difference.inSeconds.abs(), lessThan(2));
          expect(token.expiresAt.isAfter(now), true);
        }
      });
    });

    test('should generate tokens for empty match list', () {
      // Arrange
      final matches = <SecretSantaMatch>[];

      // Act
      final result = generateRevealTokens(matches);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (tokens) => expect(tokens.isEmpty, true),
      );
    });

    test('should generate tokens for single match', () {
      // Arrange
      // Create a single match directly
      final match = MockDataFactory.createMatch();

      // Act
      final result = generateRevealTokens([match]);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        expect(tokens.length, 1);
        expect(tokens[0].participantId, match.giverId);
        expect(tokens[0].matchId, match.id);
        expect(tokens[0].isRevealed, false);
      });
    });

    test('should set isRevealed to false for all tokens', () {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 5);
      final matches = MockDataFactory.createMatches(participants: participants);

      // Act
      final result = generateRevealTokens(matches);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        for (final token in tokens) {
          expect(token.isRevealed, false);
          expect(token.revealedAt, null);
        }
      });
    });

    test('should generate tokens with valid UUIDs', () {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 3);
      final matches = MockDataFactory.createMatches(participants: participants);

      // Act
      final result = generateRevealTokens(matches);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        for (final token in tokens) {
          // UUID v4 format: 8-4-4-4-12 hex characters
          final uuidRegex = RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
            caseSensitive: false,
          );
          expect(uuidRegex.hasMatch(token.id), true);
          expect(uuidRegex.hasMatch(token.token), true);
        }
      });
    });
  });
}
