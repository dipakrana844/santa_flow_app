import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure for cache/local storage operations
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure for insufficient participants
class InsufficientParticipantsFailure extends Failure {
  const InsufficientParticipantsFailure()
    : super('At least 3 participants are required for Secret Santa');
}

/// Failure for matching algorithm errors
class MatchingFailure extends Failure {
  const MatchingFailure(super.message);
}

/// Failure for network operations (future use)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for server errors (future use)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
