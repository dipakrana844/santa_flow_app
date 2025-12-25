import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/participants/data/datasources/participant_local_data_source.dart';
import '../../../../../lib/features/participants/data/models/participant_model.dart';
import '../../../../../lib/features/participants/data/repositories/participant_repository_impl.dart';
import '../../../../../lib/features/participants/domain/entities/participant.dart';
import '../../../../helpers/mock_data.dart';

class MockParticipantLocalDataSource extends Mock
    implements ParticipantLocalDataSource {}

void main() {
  late ParticipantRepositoryImpl repository;
  late MockParticipantLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(MockDataFactory.createParticipant().toModel());
  });

  setUp(() {
    mockDataSource = MockParticipantLocalDataSource();
    repository = ParticipantRepositoryImpl(mockDataSource);
  });

  group('getParticipants', () {
    test('should return participants when data source succeeds', () async {
      // Arrange
      final models = MockDataFactory.createParticipants(
        count: 3,
      ).map((p) => p.toModel()).toList();
      when(
        () => mockDataSource.getParticipants(),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getParticipants();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        participants,
      ) {
        expect(participants.length, 3);
        expect(participants[0].name, 'John Doe');
      });
      verify(() => mockDataSource.getParticipants()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.getParticipants(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getParticipants();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getParticipantsByEventId', () {
    test('should return filtered participants by event', () async {
      // Arrange
      final eventId = 'event-1';
      final models = MockDataFactory.createParticipants(
        count: 2,
        eventId: eventId,
      ).map((p) => p.toModel()).toList();
      when(
        () => mockDataSource.getParticipantsByEventId(eventId),
      ).thenAnswer((_) async => models);

      // Act
      final result = await repository.getParticipantsByEventId(eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        participants,
      ) {
        expect(participants.length, 2);
        expect(participants.every((p) => p.eventId == eventId), true);
      });
    });
  });

  group('addParticipant', () {
    test('should add participant successfully', () async {
      // Arrange
      final participant = MockDataFactory.createParticipant();
      when(
        () => mockDataSource.addParticipant(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.addParticipant(participant);

      // Assert
      expect(result, const Right(null));
      verify(() => mockDataSource.addParticipant(any())).called(1);
    });

    test('should return failure when add fails', () async {
      // Arrange
      final participant = MockDataFactory.createParticipant();
      when(
        () => mockDataSource.addParticipant(any()),
      ).thenThrow(Exception('Add failed'));

      // Act
      final result = await repository.addParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
