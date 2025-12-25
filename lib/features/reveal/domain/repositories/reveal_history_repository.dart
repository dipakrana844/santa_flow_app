import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reveal_history.dart';

/// Repository interface for reveal history operations
abstract class RevealHistoryRepository {
  /// Get all reveal history entries
  Future<Either<Failure, List<RevealHistory>>> getHistory();

  /// Get history by event ID
  Future<Either<Failure, List<RevealHistory>>> getHistoryByEventId(
    String eventId,
  );

  /// Get history by participant ID
  Future<Either<Failure, List<RevealHistory>>> getHistoryByParticipantId(
    String participantId,
  );

  /// Add a new history entry
  Future<Either<Failure, void>> addHistory(RevealHistory history);

  /// Clear all history
  Future<Either<Failure, void>> clearHistory();

  /// Remove all history entries for a specific event
  Future<Either<Failure, void>> removeHistoryByEventId(String eventId);
}
