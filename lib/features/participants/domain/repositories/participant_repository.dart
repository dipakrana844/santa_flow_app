import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/participant.dart';

/// Repository interface for participant operations
abstract class ParticipantRepository {
  /// Get all participants
  Future<Either<Failure, List<Participant>>> getParticipants();

  /// Get participants by event ID
  Future<Either<Failure, List<Participant>>> getParticipantsByEventId(
    String eventId,
  );

  /// Add a new participant
  Future<Either<Failure, void>> addParticipant(Participant participant);

  /// Remove a participant by ID
  Future<Either<Failure, void>> removeParticipant(String id);

  /// Clear all participants
  Future<Either<Failure, void>> clearParticipants();

  /// Check if a participant with the given email exists for the event
  Future<Either<Failure, bool>> checkParticipantExists(
    String email,
    String eventId,
  );

  /// Remove all participants for a specific event
  Future<Either<Failure, void>> removeParticipantsByEventId(String eventId);
}
