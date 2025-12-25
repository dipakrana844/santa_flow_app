import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../participants/domain/entities/participant.dart';
import '../../domain/entities/secret_santa_match.dart';

/// Use case to generate Secret Santa matches
class GenerateMatches {
  final _random = Random();
  final _uuid = const Uuid();

  /// Generate matches for a list of participants
  ///
  /// Ensures:
  /// - No self-matching (giverId ≠ receiverId)
  /// - Everyone gives to exactly one person
  /// - Everyone receives from exactly one person
  /// - Minimum 3 participants required
  Either<Failure, List<SecretSantaMatch>> call(
    List<Participant> participants,
    String eventId,
  ) {
    // Validate minimum participants
    if (participants.length < AppConstants.minParticipants) {
      return const Left(InsufficientParticipantsFailure());
    }

    // Validate all participants have IDs
    if (participants.any((p) => p.id.isEmpty)) {
      return const Left(
        ValidationFailure('All participants must have valid IDs'),
      );
    }

    try {
      final matches = _generateValidMatches(participants, eventId);
      return Right(matches);
    } catch (e) {
      return Left(
        MatchingFailure('Failed to generate matches: ${e.toString()}'),
      );
    }
  }

  /// Generate valid matches using Fisher-Yates shuffle with constraints
  List<SecretSantaMatch> _generateValidMatches(
    List<Participant> participants,
    String eventId,
  ) {
    final participantIds = participants.map((p) => p.id).toList();
    final matches = <SecretSantaMatch>[];

    // Create a list of receivers (excluding self)
    var receivers = List<String>.from(participantIds);

    // Shuffle receivers
    for (int i = receivers.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = receivers[i];
      receivers[i] = receivers[j];
      receivers[j] = temp;
    }

    // Create matches ensuring no self-matching
    for (int i = 0; i < participantIds.length; i++) {
      final giverId = participantIds[i];
      String receiverId;

      // Find a receiver that is not the giver
      int attempts = 0;
      do {
        // If we've tried too many times, use a different approach
        if (attempts > 100) {
          // Fallback: use the next participant in the list (circular)
          final nextIndex = (i + 1) % participantIds.length;
          receiverId = participantIds[nextIndex];
          break;
        }

        // Try to find a receiver that's not the giver
        final availableReceivers = receivers
            .where((r) => r != giverId)
            .toList();
        if (availableReceivers.isEmpty) {
          // Edge case: only one participant (shouldn't happen due to validation)
          receiverId = giverId;
          break;
        }

        receiverId =
            availableReceivers[_random.nextInt(availableReceivers.length)];
        receivers.remove(receiverId);
        attempts++;
      } while (receiverId == giverId && attempts < 100);

      // If still self-matching, use circular assignment
      if (receiverId == giverId) {
        final nextIndex = (i + 1) % participantIds.length;
        receiverId = participantIds[nextIndex];
      }

      matches.add(
        SecretSantaMatch(
          id: _uuid.v4(),
          giverId: giverId,
          receiverId: receiverId,
          eventId: eventId,
        ),
      );
    }

    // Validate the matches
    _validateMatches(matches, participantIds);

    return matches;
  }

  /// Validate that matches are correct
  void _validateMatches(
    List<SecretSantaMatch> matches,
    List<String> participantIds,
  ) {
    // Check: no self-matching
    for (final match in matches) {
      if (match.giverId == match.receiverId) {
        throw Exception('Self-matching detected: ${match.giverId}');
      }
    }

    // Check: everyone gives to exactly one person
    final giverIds = matches.map((m) => m.giverId).toSet();
    if (giverIds.length != participantIds.length) {
      throw Exception('Not all participants are givers');
    }

    // Check: everyone receives from exactly one person
    final receiverIds = matches.map((m) => m.receiverId).toSet();
    if (receiverIds.length != participantIds.length) {
      throw Exception('Not all participants are receivers');
    }

    // Check: all participant IDs are covered
    for (final id in participantIds) {
      if (!giverIds.contains(id)) {
        throw Exception('Participant $id is not a giver');
      }
      if (!receiverIds.contains(id)) {
        throw Exception('Participant $id is not a receiver');
      }
    }
  }
}
