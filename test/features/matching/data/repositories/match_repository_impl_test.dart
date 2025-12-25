import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/matching/data/datasources/match_local_data_source.dart';
import '../../../../../lib/features/matching/data/models/match_model.dart';
import '../../../../../lib/features/matching/data/repositories/match_repository_impl.dart';
import '../../../../helpers/mock_data.dart';

class MockMatchLocalDataSource extends Mock implements MatchLocalDataSource {}

void main() {
  late MatchRepositoryImpl repository;
  late MockMatchLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMatchLocalDataSource();
    repository = MatchRepositoryImpl(mockDataSource);
  });

  group('getMatches', () {
    test('should return matches when data source succeeds', () async {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 3);
      final matches = MockDataFactory.createMatches(participants: participants);
      final models = matches.map((m) => m.toModel()).toList();

      when(() => mockDataSource.getMatches()).thenAnswer((_) async => models);

      // Act
      final result = await repository.getMatches();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedMatches,
      ) {
        expect(retrievedMatches.length, 3);
        expect(retrievedMatches[0].giverId, matches[0].giverId);
      });
      verify(() => mockDataSource.getMatches()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.getMatches(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getMatches();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get matches'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getMatchesByEventId', () {
    test('should return matches for specific event', () async {
      // Arrange
      const eventId = 'event-123';
      final participants = MockDataFactory.createParticipants(
        count: 3,
        eventId: eventId,
      );
      final matches = MockDataFactory.createMatches(
        participants: participants,
        eventId: eventId,
      );
      final models = matches.map((m) => m.toModel()).toList();

      when(
        () => mockDataSource.getMatchesByEventId(any()),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getMatchesByEventId(eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedMatches,
      ) {
        expect(retrievedMatches.length, 3);
        expect(retrievedMatches.every((m) => m.eventId == eventId), true);
      });
      verify(() => mockDataSource.getMatchesByEventId(eventId)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.getMatchesByEventId(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getMatchesByEventId(eventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get matches by event'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getMatchByGiverId', () {
    test('should return match when found', () async {
      // Arrange
      const giverId = 'giver-123';
      const eventId = 'event-123';
      final match = MockDataFactory.createMatch(
        giverId: giverId,
        eventId: eventId,
      );
      final model = match.toModel();

      when(
        () => mockDataSource.getMatchByGiverId(any(), any()),
      ).thenAnswer((_) async => model);

      // Act
      final result = await repository.getMatchByGiverId(giverId, eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedMatch,
      ) {
        expect(retrievedMatch, isNotNull);
        expect(retrievedMatch!.giverId, giverId);
        expect(retrievedMatch.eventId, eventId);
      });
      verify(
        () => mockDataSource.getMatchByGiverId(giverId, eventId),
      ).called(1);
    });

    test('should return null when match not found', () async {
      // Arrange
      const giverId = 'non-existent-giver';
      const eventId = 'event-123';
      when(
        () => mockDataSource.getMatchByGiverId(any(), any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getMatchByGiverId(giverId, eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (retrievedMatch) => expect(retrievedMatch, null),
      );
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const giverId = 'giver-123';
      const eventId = 'event-123';
      when(
        () => mockDataSource.getMatchByGiverId(any(), any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getMatchByGiverId(giverId, eventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get match by giver'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getMatchById', () {
    test('should return match when found', () async {
      // Arrange
      const matchId = 'match-123';
      final match = MockDataFactory.createMatch(id: matchId);
      final model = match.toModel();

      when(
        () => mockDataSource.getMatchById(any()),
      ).thenAnswer((_) async => model);

      // Act
      final result = await repository.getMatchById(matchId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedMatch,
      ) {
        expect(retrievedMatch, isNotNull);
        expect(retrievedMatch!.id, matchId);
      });
      verify(() => mockDataSource.getMatchById(matchId)).called(1);
    });

    test('should return null when match not found', () async {
      // Arrange
      const matchId = 'non-existent-match';
      when(
        () => mockDataSource.getMatchById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getMatchById(matchId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (retrievedMatch) => expect(retrievedMatch, null),
      );
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const matchId = 'match-123';
      when(
        () => mockDataSource.getMatchById(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getMatchById(matchId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get match by id'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('saveMatches', () {
    test('should save matches successfully', () async {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 3);
      final matches = MockDataFactory.createMatches(participants: participants);
      final models = matches.map((m) => m.toModel()).toList();

      when(
        () => mockDataSource.saveMatches(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.saveMatches(matches);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.saveMatches(models)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 3);
      final matches = MockDataFactory.createMatches(participants: participants);

      when(
        () => mockDataSource.saveMatches(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.saveMatches(matches);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to save matches'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('clearMatches', () {
    test('should clear all matches successfully', () async {
      // Arrange
      when(
        () => mockDataSource.clearMatches(),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.clearMatches();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.clearMatches()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.clearMatches(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.clearMatches();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to clear matches'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('clearMatchesByEventId', () {
    test('should clear matches for specific event successfully', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.clearMatchesByEventId(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.clearMatchesByEventId(eventId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.clearMatchesByEventId(eventId)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.clearMatchesByEventId(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.clearMatchesByEventId(eventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to clear matches by event'));
      }, (_) => fail('Should return failure'));
    });
  });
}
