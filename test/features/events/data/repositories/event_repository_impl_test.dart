import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/events/data/datasources/event_local_data_source.dart';
import '../../../../../lib/features/events/data/models/event_model.dart';
import '../../../../../lib/features/events/data/repositories/event_repository_impl.dart';
import '../../../../helpers/mock_data.dart';

class MockEventLocalDataSource extends Mock implements EventLocalDataSource {}

void main() {
  late EventRepositoryImpl repository;
  late MockEventLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(MockDataFactory.createEvent().toModel());
  });

  setUp(() {
    mockDataSource = MockEventLocalDataSource();
    repository = EventRepositoryImpl(mockDataSource);
  });

  group('getEvents', () {
    test('should return events when data source succeeds', () async {
      // Arrange
      final events = [
        MockDataFactory.createEvent(name: 'Christmas 2024'),
        MockDataFactory.createEvent(name: 'New Year 2025'),
      ];
      final models = events.map((e) => e.toModel()).toList();

      when(() => mockDataSource.getEvents()).thenAnswer((_) async => models);

      // Act
      final result = await repository.getEvents();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedEvents,
      ) {
        expect(retrievedEvents.length, 2);
        expect(retrievedEvents[0].name, 'Christmas 2024');
      });
      verify(() => mockDataSource.getEvents()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.getEvents(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getEvents();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get events'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('getEventById', () {
    test('should return event when found', () async {
      // Arrange
      const eventId = 'event-123';
      final event = MockDataFactory.createEvent(
        id: eventId,
        name: 'Test Event',
      );
      final model = event.toModel();

      when(
        () => mockDataSource.getEventById(any()),
      ).thenAnswer((_) async => model);

      // Act
      final result = await repository.getEventById(eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (
        retrievedEvent,
      ) {
        expect(retrievedEvent, isNotNull);
        expect(retrievedEvent!.id, eventId);
        expect(retrievedEvent.name, 'Test Event');
      });
      verify(() => mockDataSource.getEventById(eventId)).called(1);
    });

    test('should return null when event not found', () async {
      // Arrange
      const eventId = 'non-existent-event';
      when(
        () => mockDataSource.getEventById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getEventById(eventId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (retrievedEvent) => expect(retrievedEvent, null),
      );
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.getEventById(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getEventById(eventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to get event'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('addEvent', () {
    test('should add event successfully', () async {
      // Arrange
      final event = MockDataFactory.createEvent(name: 'New Event');
      final model = event.toModel();

      when(
        () => mockDataSource.addEvent(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.addEvent(event);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.addEvent(model)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final event = MockDataFactory.createEvent(name: 'New Event');
      when(
        () => mockDataSource.addEvent(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.addEvent(event);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to add event'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('updateEvent', () {
    test('should update event successfully', () async {
      // Arrange
      final event = MockDataFactory.createEvent(
        id: 'event-123',
        name: 'Updated Event',
      );
      final model = event.toModel();

      when(
        () => mockDataSource.updateEvent(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateEvent(event);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.updateEvent(model)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final event = MockDataFactory.createEvent(name: 'Updated Event');
      when(
        () => mockDataSource.updateEvent(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.updateEvent(event);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to update event'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('removeEvent', () {
    test('should remove event successfully', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.removeEvent(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.removeEvent(eventId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.removeEvent(eventId)).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      const eventId = 'event-123';
      when(
        () => mockDataSource.removeEvent(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.removeEvent(eventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to remove event'));
      }, (_) => fail('Should return failure'));
    });
  });

  group('clearEvents', () {
    test('should clear all events successfully', () async {
      // Arrange
      when(
        () => mockDataSource.clearEvents(),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.clearEvents();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.clearEvents()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(
        () => mockDataSource.clearEvents(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.clearEvents();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('Failed to clear events'));
      }, (_) => fail('Should return failure'));
    });
  });
}
