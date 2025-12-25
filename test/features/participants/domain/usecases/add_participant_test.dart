import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/participants/domain/entities/participant.dart';
import '../../../../../lib/features/participants/domain/repositories/participant_repository.dart';
import '../../../../../lib/features/participants/domain/usecases/add_participant.dart';
import '../../../../../lib/features/participants/domain/usecases/validate_participant.dart';
import '../../../../helpers/mock_data.dart';

class MockParticipantRepository extends Mock implements ParticipantRepository {}

void main() {
  late AddParticipant useCase;
  late MockParticipantRepository mockRepository;
  late ValidateParticipant validateParticipant;

  setUpAll(() {
    registerFallbackValue(MockDataFactory.createParticipant());
  });

  setUp(() {
    mockRepository = MockParticipantRepository();
    validateParticipant = ValidateParticipant();
    useCase = AddParticipant(mockRepository, validateParticipant);
  });

  test('should add valid participant', () async {
    // Arrange
    final participant = MockDataFactory.createParticipant();
    when(
      () => mockRepository.addParticipant(any()),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(participant);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.addParticipant(participant)).called(1);
    reset(mockRepository);
  });

  test('should return validation failure for invalid email', () async {
    // Arrange
    final participant = MockDataFactory.createParticipant(
      email: 'invalid-email',
    );

    // Act
    final result = await useCase(participant);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should return failure'),
    );
  });

  test('should return validation failure for empty name', () async {
    // Arrange
    final participant = MockDataFactory.createParticipant(name: '');

    // Act
    final result = await useCase(participant);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should return failure'),
    );
  });
}
