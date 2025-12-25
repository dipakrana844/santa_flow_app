import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/participant_repository.dart';

/// Use case to remove a participant by ID
class RemoveParticipant {
  final ParticipantRepository repository;

  RemoveParticipant(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.removeParticipant(id);
  }
}
