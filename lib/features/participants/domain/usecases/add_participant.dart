import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/participant.dart';
import '../repositories/participant_repository.dart';
import 'validate_participant.dart';

/// Use case to add a new participant
class AddParticipant {
  final ParticipantRepository repository;
  final ValidateParticipant validateParticipant;

  AddParticipant(this.repository, this.validateParticipant);

  Future<Either<Failure, void>> call(Participant participant) async {
    // Validate participant first
    final validationResult = validateParticipant(participant);
    if (validationResult.isLeft()) {
      return validationResult;
    }

    // Check for duplicate email in the same event
    if (participant.eventId != null) {
      final duplicateCheck = await repository.checkParticipantExists(
        participant.email,
        participant.eventId!,
      );

      return duplicateCheck.fold((failure) => Left(failure), (exists) {
        if (exists) {
          return const Left(
            ValidationFailure(
              'A participant with this email already exists for this event',
            ),
          );
        }
        return repository.addParticipant(participant);
      });
    }

    // If no eventId, proceed with adding (shouldn't happen in normal flow)
    return repository.addParticipant(participant);
  }
}
