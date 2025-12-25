import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../events/presentation/providers/event_providers.dart';
import '../../../matching/domain/entities/secret_santa_match.dart';
import '../../../participants/domain/entities/participant.dart';
import '../../../participants/presentation/providers/participant_providers.dart';
import '../../domain/entities/reveal_history.dart';
import '../../domain/entities/reveal_token.dart';
import '../providers/reveal_providers.dart';

/// State of the reveal process
enum RevealState { loading, error, revealed }

/// Screen to reveal Secret Santa match
class RevealScreen extends ConsumerStatefulWidget {
  final String token;

  const RevealScreen({super.key, required this.token});

  @override
  ConsumerState<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends ConsumerState<RevealScreen> {
  final _confettiController = ConfettiController(
    duration: const Duration(seconds: 5),
  );

  RevealState _state = RevealState.loading;
  String? _receiverName;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processReveal();
    });
  }

  /// Main method to process the reveal flow
  Future<void> _processReveal() async {
    if (!mounted) return;

    setState(() {
      _state = RevealState.loading;
      _errorMessage = null;
    });

    try {
      // Step 1: Validate token
      final validToken = await _validateToken();
      if (validToken == null) return;

      // Step 2: Get match and participants in parallel
      final match = await _getMatch(validToken);
      if (match == null) return;

      // Get participants filtered by event
      final participants = await ref.read(
        participantsByEventProvider(match.eventId).future,
      );
      final receiver = _findParticipant(participants, match.receiverId);
      final giver = _findParticipant(participants, match.giverId);

      if (receiver == null || giver == null) {
        _setError('Participant information not found');
        return;
      }

      // Step 3: Save reveal data (parallel operations)
      final revealedAt = DateTime.now();
      await Future.wait([
        _markTokenAsRevealed(validToken, revealedAt),
        _saveRevealHistory(giver, receiver, match, revealedAt),
      ]);

      // Step 4: Show reveal with animation
      if (mounted) {
        setState(() {
          _state = RevealState.revealed;
          _receiverName = receiver.name;
        });
        await HapticFeedbackHelper.heavyImpact();
        _confettiController.play();
      }
    } catch (e) {
      _setError('Failed to reveal match: ${e.toString()}');
    }
  }

  /// Validate the reveal token
  Future<RevealToken?> _validateToken() async {
    try {
      final validateToken = ref.read(validateRevealTokenProvider);
      final tokenResult = await validateToken(widget.token);

      return tokenResult.fold((failure) {
        _setError(failure.message);
        return null;
      }, (token) => token);
    } catch (e) {
      _setError('Failed to validate token: ${e.toString()}');
      return null;
    }
  }

  /// Get match by token
  Future<SecretSantaMatch?> _getMatch(RevealToken validToken) async {
    try {
      final getMatchByToken = ref.read(getMatchByTokenProvider);
      final matchResult = await getMatchByToken(widget.token);

      return matchResult.fold((failure) {
        _setError(failure.message);
        return null;
      }, (match) => match);
    } catch (e) {
      _setError('Failed to get match: ${e.toString()}');
      return null;
    }
  }

  /// Find participant by ID
  Participant? _findParticipant(List<Participant> participants, String id) {
    try {
      return participants.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mark token as revealed
  Future<void> _markTokenAsRevealed(
    RevealToken token,
    DateTime revealedAt,
  ) async {
    try {
      final repository = ref.read(revealTokenRepositoryProvider);
      await repository.markTokenAsRevealed(token.id, revealedAt);
    } catch (e) {
      // Log error but don't block reveal
      debugPrint('Failed to mark token as revealed: $e');
    }
  }

  /// Save reveal history
  Future<void> _saveRevealHistory(
    Participant giver,
    Participant receiver,
    SecretSantaMatch match,
    DateTime revealedAt,
  ) async {
    try {
      final historyRepository = ref.read(revealHistoryRepositoryProvider);
      final currentEventId = await ref.read(currentEventIdProvider.future);

      final history = RevealHistory(
        id: const Uuid().v4(),
        participantId: giver.id,
        participantName: giver.name,
        matchId: match.id,
        receiverId: receiver.id,
        receiverName: receiver.name,
        revealedAt: revealedAt,
        eventId: currentEventId ?? match.eventId,
      );

      await historyRepository.addHistory(history);
    } catch (e) {
      // Log error but don't block reveal
      debugPrint('Failed to save reveal history: $e');
    }
  }

  /// Set error state
  void _setError(String message) {
    if (mounted) {
      setState(() {
        _state = RevealState.error;
        _errorMessage = message;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reveal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use go_router's pop, with fallback to home if no previous route
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppConstants.homeRoute);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildContent(context),
              ),
            ),
          ),
          // Confetti effect
          if (_state == RevealState.revealed)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14 / 2,
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.1,
              ),
            ),
        ],
      ),
    );
  }

  /// Build content based on current state
  Widget _buildContent(BuildContext context) {
    switch (_state) {
      case RevealState.loading:
        return _buildLoadingState(context);
      case RevealState.error:
        return _buildErrorState(context);
      case RevealState.revealed:
        return _buildRevealedState(context);
    }
  }

  /// Build loading state widget
  Widget _buildLoadingState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text(
          'Preparing your reveal...',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build error state widget
  Widget _buildErrorState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 24),
        Text(
          _errorMessage ?? 'An error occurred',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _processReveal,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  /// Build revealed state widget
  Widget _buildRevealedState(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.card_giftcard, size: 100, color: Colors.red),
          const SizedBox(height: 32),
          Text(
            'Your Secret Santa is...',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                _receiverName ?? 'Unknown',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            '🎉 Happy Holidays! 🎉',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
