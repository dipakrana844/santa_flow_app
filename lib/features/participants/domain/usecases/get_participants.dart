import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/participant.dart';
import '../repositories/participant_repository.dart';

/// Use case to get all participants
class GetParticipants {
  final ParticipantRepository repository;

  GetParticipants(this.repository);

  Future<Either<Failure, List<Participant>>> call() {
    return repository.getParticipants();
  }
}
