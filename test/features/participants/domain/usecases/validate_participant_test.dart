import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/core/constants/app_constants.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/participants/domain/entities/participant.dart';
import '../../../../../lib/features/participants/domain/usecases/validate_participant.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  late ValidateParticipant validateParticipant;

  setUp(() {
    validateParticipant = ValidateParticipant();
  });

  group('ValidateParticipant', () {
    test('should return Right for valid participant', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (_) => expect(true, true),
      );
    });

    test('should return ValidationFailure for empty name', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: '',
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationNameRequired);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for name with only whitespace', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: '   ',
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationNameRequired);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for name too short', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'A',
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationNameTooShort);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for name too long', () {
      // Arrange
      final longName = 'A' * (AppConstants.maxNameLength + 1);
      final participant = MockDataFactory.createParticipant(
        name: longName,
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(
          failure.message,
          'Name must be at most ${AppConstants.maxNameLength} characters',
        );
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for empty email', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: '',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationEmailRequired);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for email with only whitespace', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: '   ',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationEmailRequired);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for invalid email format', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: 'invalid-email',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationEmailInvalid);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for email without @', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: 'johnexample.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationEmailInvalid);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for email without domain', () {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: 'john@',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, AppConstants.validationEmailInvalid);
      }, (_) => fail('Should return failure'));
    });

    test('should return ValidationFailure for email too long', () {
      // Arrange
      // Create email that exceeds max length (100 chars)
      final longEmail = 'a' * (AppConstants.maxEmailLength + 1) + '@test.com';
      final participant = MockDataFactory.createParticipant(
        name: 'John Doe',
        email: longEmail,
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(
          failure.message,
          'Email must be at most ${AppConstants.maxEmailLength} characters',
        );
      }, (_) => fail('Should return failure'));
    });

    test('should accept valid email formats', () {
      // Arrange
      final validEmails = [
        'test@example.com',
        'user.name@example.co.uk',
        'user+tag@example.com',
        'user_name@example-domain.com',
        '123@example.com',
      ];

      for (final email in validEmails) {
        final participant = MockDataFactory.createParticipant(
          name: 'John Doe',
          email: email,
        );

        // Act
        final result = validateParticipant(participant);

        // Assert
        expect(result.isRight(), true, reason: 'Email $email should be valid');
      }
    });

    test('should accept name at minimum length', () {
      // Arrange
      final minLengthName = 'A' * AppConstants.minNameLength;
      final participant = MockDataFactory.createParticipant(
        name: minLengthName,
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isRight(), true);
    });

    test('should accept name at maximum length', () {
      // Arrange
      final maxLengthName = 'A' * AppConstants.maxNameLength;
      final participant = MockDataFactory.createParticipant(
        name: maxLengthName,
        email: 'john@example.com',
      );

      // Act
      final result = validateParticipant(participant);

      // Assert
      expect(result.isRight(), true);
    });
  });
}
