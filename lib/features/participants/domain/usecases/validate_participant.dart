import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../entities/participant.dart';

/// Use case to validate participant data
class ValidateParticipant {
  Either<Failure, void> call(Participant participant) {
    // Validate name
    if (participant.name.trim().isEmpty) {
      return const Left(ValidationFailure(AppConstants.validationNameRequired));
    }

    if (participant.name.trim().length < AppConstants.minNameLength) {
      return const Left(ValidationFailure(AppConstants.validationNameTooShort));
    }

    if (participant.name.length > AppConstants.maxNameLength) {
      return Left(
        ValidationFailure(
          'Name must be at most ${AppConstants.maxNameLength} characters',
        ),
      );
    }

    // Validate email
    if (participant.email.trim().isEmpty) {
      return const Left(
        ValidationFailure(AppConstants.validationEmailRequired),
      );
    }

    if (!_isValidEmail(participant.email)) {
      return const Left(ValidationFailure(AppConstants.validationEmailInvalid));
    }

    if (participant.email.length > AppConstants.maxEmailLength) {
      return Left(
        ValidationFailure(
          'Email must be at most ${AppConstants.maxEmailLength} characters',
        ),
      );
    }

    return const Right(null);
  }

  /// Validates email format using regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
