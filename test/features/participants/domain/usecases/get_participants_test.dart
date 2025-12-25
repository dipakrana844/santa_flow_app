import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/participants/domain/entities/participant.dart';
import '../../../../../lib/features/participants/domain/repositories/participant_repository.dart';
import '../../../../../lib/features/participants/domain/usecases/get_participants.dart';
import '../../../../helpers/mock_data.dart';

class MockParticipantRepository extends Mock implements ParticipantRepository {}

void main() {
  late GetParticipants useCase;
  late MockParticipantRepository mockRepository;

  setUp(() {
    mockRepository = MockParticipantRepository();
    useCase = GetParticipants(mockRepository);
  });

  test('should get participants from repository', () async {
    // Arrange
    final participants = MockDataFactory.createParticipants(count: 3);
    when(
      () => mockRepository.getParticipants(),
    ).thenAnswer((_) async => Right(participants));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(participants));
    verify(() => mockRepository.getParticipants()).called(1);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    final failure = CacheFailure('Failed to get participants');
    when(
      () => mockRepository.getParticipants(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getParticipants()).called(1);
  });
}
