import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/matching/domain/entities/secret_santa_match.dart';
import '../../../../../lib/features/matching/domain/usecases/generate_matches.dart';
import '../../../../../lib/features/participants/domain/entities/participant.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  late GenerateMatches useCase;

  setUp(() {
    useCase = GenerateMatches();
  });

  test('should generate matches for valid participants', () {
    // Arrange
    final participants = MockDataFactory.createParticipants(count: 3);
    final eventId = 'event-1';

    // Act
    final result = useCase(participants, eventId);

    // Assert
    expect(result.isRight(), true);
    result.fold((failure) => fail('Should not return failure'), (matches) {
      expect(matches.length, 3);
      // Check no self-matching
      for (final match in matches) {
        expect(match.giverId, isNot(match.receiverId));
      }
      // Check all participants are included
      final giverIds = matches.map((m) => m.giverId).toSet();
      final receiverIds = matches.map((m) => m.receiverId).toSet();
      expect(giverIds.length, 3);
      expect(receiverIds.length, 3);
    });
  });

  test('should return failure for insufficient participants', () {
    // Arrange
    final participants = MockDataFactory.createParticipants(count: 2);
    final eventId = 'event-1';

    // Act
    final result = useCase(participants, eventId);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<InsufficientParticipantsFailure>()),
      (_) => fail('Should return failure'),
    );
  });

  test('should return failure for empty participants', () {
    // Arrange
    final participants = <Participant>[];
    final eventId = 'event-1';

    // Act
    final result = useCase(participants, eventId);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<InsufficientParticipantsFailure>()),
      (_) => fail('Should return failure'),
    );
  });

  test('should ensure no self-matching', () {
    // Arrange
    final participants = MockDataFactory.createParticipants(count: 5);
    final eventId = 'event-1';

    // Act
    final result = useCase(participants, eventId);

    // Assert
    result.fold((failure) => fail('Should not return failure'), (matches) {
      for (final match in matches) {
        expect(match.giverId, isNot(match.receiverId));
      }
    });
  });
}
