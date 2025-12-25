import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../events/presentation/providers/event_providers.dart';
import '../../../participants/domain/entities/participant.dart';
import '../../../participants/presentation/providers/participant_providers.dart';
import '../../../reveal/domain/usecases/generate_reveal_tokens.dart';
import '../../../reveal/presentation/providers/reveal_providers.dart';
import '../../domain/entities/secret_santa_match.dart';
import '../providers/matching_providers.dart';

/// Screen for generating and viewing Secret Santa matches
class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  final _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );
  bool _isGenerating = false;
  List<SecretSantaMatch> _matches = [];

  String? _lastEventId;

  @override
  void initState() {
    super.initState();
    // Load existing matches when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingMatches();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// Load matches for the current event, clearing if event changed
  Future<void> _loadExistingMatches() async {
    try {
      final currentEventId = await ref.read(currentEventIdProvider.future);

      // Clear matches if event changed or is null
      if (currentEventId != _lastEventId) {
        if (mounted) {
          setState(() {
            _matches = [];
            _lastEventId = currentEventId;
          });
        }
      }

      // Load matches only if event is selected
      if (currentEventId != null) {
        final matches = await ref.read(
          matchesByEventProvider(currentEventId).future,
        );
        if (mounted && currentEventId == _lastEventId) {
          setState(() {
            _matches = matches;
          });
        }
      }
    } catch (e) {
      // Silently fail - matches might not exist yet
      if (mounted) {
        setState(() {
          _matches = [];
        });
      }
    }
  }

  /// Get participants for a specific event only (no fallback to all participants)
  Future<List<Participant>> _getParticipantsForMatch(String eventId) async {
    try {
      return await ref.read(participantsByEventProvider(eventId).future);
    } catch (e) {
      // Return empty list instead of falling back to all participants
      // This ensures we only show participants from the correct event
      return [];
    }
  }

  Future<void> _reshuffleMatches() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Re-shuffle Matches?'),
        content: const Text(
          'This will clear existing matches and generate new ones. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Re-shuffle'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Clear existing matches
      final currentEventId = await ref.read(currentEventIdProvider.future);
      if (currentEventId != null) {
        final repository = ref.read(matchRepositoryProvider);
        await repository.clearMatchesByEventId(currentEventId);

        // Clear tokens for this event's matches
        final tokenRepository = ref.read(revealTokenRepositoryProvider);
        // Get all tokens and filter by event (we'll need to get matches first)
        final matches = await repository.getMatchesByEventId(currentEventId);
        matches.fold((failure) {}, (matchesList) async {
          for (final match in matchesList) {
            final tokensResult = await tokenRepository.getTokensByMatchId(
              match.id,
            );
            tokensResult.fold((failure) {}, (tokens) async {
              for (final token in tokens) {
                await tokenRepository.updateToken(
                  token.copyWith(isRevealed: false, revealedAt: null),
                );
              }
            });
          }
        });
      }

      // Generate new matches
      await _generateMatches();
    }
  }

  Future<void> _generateMatches() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Get current event ID
      final currentEventId = await ref.read(currentEventIdProvider.future);
      if (currentEventId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an event first'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _isGenerating = false;
        });
        return;
      }

      // Get participants for current event
      final participants = await ref.read(
        participantsByEventProvider(currentEventId).future,
      );

      if (participants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.errorNoParticipants),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _isGenerating = false;
        });
        return;
      }

      // Generate matches
      final generateMatches = ref.read(generateMatchesProvider);
      final result = generateMatches(participants, currentEventId);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (matches) async {
          // Save matches
          final repository = ref.read(matchRepositoryProvider);
          final saveResult = await repository.saveMatches(matches);

          saveResult.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save matches: ${failure.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (_) async {
              // Generate and save reveal tokens
              final generateTokens = GenerateRevealTokens();
              final tokensResult = generateTokens(matches);

              tokensResult.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to generate tokens: ${failure.message}',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                (tokens) async {
                  // Save tokens
                  final tokenRepository = ref.read(
                    revealTokenRepositoryProvider,
                  );
                  for (final token in tokens) {
                    await tokenRepository.addToken(token);
                  }

                  setState(() {
                    _matches = matches;
                  });
                  await HapticFeedbackHelper.heavyImpact();
                  _confettiController.play();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppConstants.successMatchesGenerated),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEventAsync = ref.watch(currentEventProvider);

    // Listen for event changes and reload matches when event changes
    ref.listen<AsyncValue<String?>>(currentEventIdProvider, (previous, next) {
      next.whenData((eventId) {
        if (eventId != _lastEventId && mounted) {
          // Event changed, reload matches
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadExistingMatches();
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Matching'),
            currentEventAsync.when(
              data: (event) => event != null
                  ? Text(event.name, style: const TextStyle(fontSize: 12))
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR Code',
            onPressed: () {
              context.push(AppConstants.qrScannerRoute);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await _loadExistingMatches();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Show banner if no event is selected
                  FutureBuilder<String?>(
                    future: ref.read(currentEventIdProvider.future),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == null) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange.shade800,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Please select an event first to generate matches.',
                                  style: TextStyle(
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // Generate/Re-shuffle buttons
                  if (_matches.isEmpty)
                    ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateMatches,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.shuffle),
                      label: Text(
                        _isGenerating ? 'Generating...' : 'Generate Matches',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isGenerating ? null : _reshuffleMatches,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Re-shuffle'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isGenerating ? null : _generateMatches,
                            icon: _isGenerating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.shuffle),
                            label: Text(
                              _isGenerating ? 'Generating...' : 'Generate New',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Matches list
                  if (_matches.isNotEmpty) ...[
                    Text(
                      'Matches Generated:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ..._matches.map((match) {
                      // Get current event ID to filter matches
                      return FutureBuilder<String?>(
                        future: ref.read(currentEventIdProvider.future),
                        builder: (context, eventSnapshot) {
                          // Only show match if it belongs to current event
                          if (!eventSnapshot.hasData ||
                              eventSnapshot.data != match.eventId) {
                            return const SizedBox.shrink();
                          }

                          return FutureBuilder<List<Participant>>(
                            future: _getParticipantsForMatch(match.eventId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              final participants = snapshot.data!;
                              final giver = participants.firstWhere(
                                (p) => p.id == match.giverId,
                                orElse: () => Participant(
                                  id: match.giverId,
                                  name: 'Unknown',
                                  email: '',
                                ),
                              );
                              final receiver = participants.firstWhere(
                                (p) => p.id == match.receiverId,
                                orElse: () => Participant(
                                  id: match.receiverId,
                                  name: 'Unknown',
                                  email: '',
                                ),
                              );

                              return FadeInUp(
                                duration: const Duration(milliseconds: 300),
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      child: Text(
                                        giver.name[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      giver.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text('Gives to ${receiver.name}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.qr_code),
                                      onPressed: () async {
                                        // Get token for this match
                                        final tokenRepository = ref.read(
                                          revealTokenRepositoryProvider,
                                        );
                                        final tokensResult =
                                            await tokenRepository
                                                .getTokensByMatchId(match.id);

                                        tokensResult.fold(
                                          (failure) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Failed to get token: ${failure.message}',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          (tokens) {
                                            if (tokens.isNotEmpty) {
                                              final token = tokens.first;
                                              // Navigate using go_router with query parameters
                                              final encodedName =
                                                  Uri.encodeComponent(
                                                    giver.name,
                                                  );
                                              context.push(
                                                '${AppConstants.qrDisplayRoute}?token=${token.token}&name=$encodedName',
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'QR code not available for this match',
                                                  ),
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.shuffle,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No matches generated yet.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Click the button above to generate matches!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Confetti effect
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
}
