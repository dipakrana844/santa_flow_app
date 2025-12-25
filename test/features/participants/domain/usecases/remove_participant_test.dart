import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/participants/domain/repositories/participant_repository.dart';
import '../../../../../lib/features/participants/domain/usecases/remove_participant.dart';

class MockParticipantRepository extends Mock implements ParticipantRepository {}

void main() {
  late RemoveParticipant removeParticipant;
  late MockParticipantRepository mockRepository;

  setUp(() {
    mockRepository = MockParticipantRepository();
    removeParticipant = RemoveParticipant(mockRepository);
  });

  group('RemoveParticipant', () {
    test('should remove participant successfully', () async {
      // Arrange
      const participantId = 'test-id-123';
      when(
        () => mockRepository.removeParticipant(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await removeParticipant(participantId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (_) => expect(true, true),
      );
      verify(() => mockRepository.removeParticipant(participantId)).called(1);
    });

    test('should return CacheFailure when repository fails', () async {
      // Arrange
      const participantId = 'test-id-123';
      const failure = CacheFailure('Failed to remove participant');
      when(
        () => mockRepository.removeParticipant(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await removeParticipant(participantId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Failed to remove participant');
      }, (_) => fail('Should return failure'));
      verify(() => mockRepository.removeParticipant(participantId)).called(1);
    });

    test('should handle empty participant ID', () async {
      // Arrange
      const participantId = '';
      when(
        () => mockRepository.removeParticipant(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await removeParticipant(participantId);

      // Assert
      verify(() => mockRepository.removeParticipant(participantId)).called(1);
      // Note: Empty ID validation would be handled by repository or data source
    });

    test('should propagate repository errors', () async {
      // Arrange
      const participantId = 'test-id-123';
      const failure = CacheFailure('Database error');
      when(
        () => mockRepository.removeParticipant(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await removeParticipant(participantId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Database error'),
        (_) => fail('Should return failure'),
      );
    });
  });
}
