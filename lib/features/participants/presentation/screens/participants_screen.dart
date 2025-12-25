import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/participant_providers.dart';
import '../widgets/add_participant_form.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/participant_card.dart';
import '../../../events/presentation/providers/event_providers.dart';

/// Screen for managing participants
class ParticipantsScreen extends ConsumerWidget {
  const ParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEventIdAsync = ref.watch(currentEventIdProvider);
    final currentEventAsync = ref.watch(currentEventProvider);

    final participantsAsync = currentEventIdAsync.when(
      data: (eventId) {
        if (eventId == null) {
          return ref.watch(participantsProvider);
        }
        return ref.watch(participantsByEventProvider(eventId));
      },
      loading: () => ref.watch(participantsProvider),
      error: (_, __) => ref.watch(participantsProvider),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Participants'),
            currentEventAsync.when(
              data: (event) => event != null
                  ? Text(event.name, style: const TextStyle(fontSize: 12))
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Show banner if no event is selected
          currentEventIdAsync.when(
            data: (eventId) {
              if (eventId == null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.orange.shade100,
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade800),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No event selected. Please select or create an event to add participants.',
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const AddParticipantForm(),
          const Divider(),
          Expanded(
            child: participantsAsync.when(
              data: (participants) {
                if (participants.isEmpty) {
                  return const EmptyStateWidget(
                    message:
                        'No participants added yet.\nAdd your first participant above!',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(participantsProvider);
                    final currentEventId = await ref.read(
                      currentEventIdProvider.future,
                    );
                    if (currentEventId != null) {
                      ref.invalidate(
                        participantsByEventProvider(currentEventId),
                      );
                    }
                  },
                  child: ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      return ParticipantCard(
                        participant: participant,
                        onDelete: () async {
                          final removeParticipant = ref.read(
                            removeParticipantProvider,
                          );
                          final result = await removeParticipant(
                            participant.id,
                          );

                          result.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(failure.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            (_) {
                              ref.invalidate(participantsProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Participant removed'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(participantsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
