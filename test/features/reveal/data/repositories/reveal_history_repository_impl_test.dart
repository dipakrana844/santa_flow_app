import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/reveal/data/datasources/reveal_history_local_data_source.dart';
import '../../../../../lib/features/reveal/data/models/reveal_history_model.dart';
import '../../../../../lib/features/reveal/data/repositories/reveal_history_repository_impl.dart';
import '../../../../../lib/features/reveal/domain/entities/reveal_history.dart';

class MockRevealHistoryLocalDataSource extends Mock
    implements RevealHistoryLocalDataSource {}

RevealHistory _createRevealHistory({
  String? id,
  String? participantId,
  String? participantName,
  String? matchId,
  String? receiverId,
  String? receiverName,
  DateTime? revealedAt,
  String? eventId,
}) {
  const uuid = Uuid();
  return RevealHistory(
    id: id ?? uuid.v4(),
    participantId: participantId ?? uuid.v4(),
    participantName: participantName ?? 'John Doe',
    matchId: matchId ?? uuid.v4(),
    receiverId: receiverId ?? uuid.v4(),
    receiverName: receiverName ?? 'Jane Smith',
    revealedAt: revealedAt ?? DateTime.now(),
    eventId: eventId ?? uuid.v4(),
  );
}

void main() {
  late RevealHistoryRepositoryImpl repository;
  late MockRevealHistoryLocalDataSource mockDataSource;

  setUpAll(() {
    final revealHistory = _createRevealHistory();
    registerFallbackValue(revealHistory.toModel());
  });

  setUp(() {
    mockDataSource = MockRevealHistoryLocalDataSource();
    repository = RevealHistoryRepositoryImpl(mockDataSource);
  });

  group('getHistory', () {
    test('should return history entries when data source succeeds', () async {
      // Arrange
      final history1 = _createRevealHistory();
      final history2 = _createRevealHistory();
      final models = [history1.toModel(), history2.toModel()];

      when(() => mockDataSource.getHistory()).thenAnswer((_) async => models);

      // Act
      final result = await repository.getHistory();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedHistory,
      ) {
        expect(retrievedHistory.length, 2);
        expect(retrievedHistory[0].participantName, 'John Doe');
      });
      verify(() => mockDataSource.getHistory()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.getHistory(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getHistory();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get history'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getHistoryByEventId', () {
    test('should return history for specific event', () async {
      // Arrange
      const eventId = 'event-123';
      final history1 = _createRevealHistory(eventId: eventId);
      final history2 = _createRevealHistory(eventId: eventId);
      final models = [history1.toModel(), history2.toModel()];

      when(
        () => mockDataSource.getHistoryByEventId(any()),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getHistoryByEventId(eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedHistory,
      ) {
        expect(retrievedHistory.length, 2);
        expect(retrievedHistory.every((h) => h.eventId == eventId), true);
      });
      verify(() => mockDataSource.getHistoryByEventId(eventId)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.getHistoryByEventId(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getHistoryByEventId(eventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get history by event'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getHistoryByParticipantId', () {
    test('should return history for specific participant', () async {
      // Arrange
      const participantId = 'participant-123';
      final history1 = _createRevealHistory(participantId: participantId);
      final history2 = _createRevealHistory(participantId: participantId);
      final models = [history1.toModel(), history2.toModel()];

      when(
        () => mockDataSource.getHistoryByParticipantId(any()),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getHistoryByParticipantId(participantId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedHistory,
      ) {
        expect(retrievedHistory.length, 2);
        expect(
          retrievedHistory.every((h) => h.participantId == participantId),
          true,
        );
      });
      verify(
        () => mockDataSource.getHistoryByParticipantId(participantId),
      ).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const participantId = 'participant-123';
      when(
        () => mockDataSource.getHistoryByParticipantId(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getHistoryByParticipantId(participantId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(
          failure.message,
          contains('Failed to get history by participant'),
        );
      }, (_) => fail('Should return failure'));
    });
  });

  group('addHistory', () {
    test('should add history entry successfully', () async {
      // Arrange
      final history = _createRevealHistory();
      final model = history.toModel();

      when(
        () => mockDataSource.addHistory(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.addHistory(history);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.addHistory(model)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final history = _createRevealHistory();
      when(
        () => mockDataSource.addHistory(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.addHistory(history);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to add history'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('clearHistory', () {
    test('should clear all history successfully', () async {
      // Arrange
      when(
        () => mockDataSource.clearHistory(),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.clearHistory();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.clearHistory()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.clearHistory(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.clearHistory();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to clear history'));
      }, (_) => fail('Should return failure'));
    });
  });
}
