import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/event_providers.dart';
import '../../domain/entities/event.dart';
import '../../../participants/presentation/providers/participant_providers.dart';
import '../../../matching/presentation/providers/matching_providers.dart';
import '../../../reveal/presentation/providers/reveal_providers.dart';

/// Screen for managing events
class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEventDialog(context, ref),
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No events yet.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first event!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          final currentEventIdAsync = ref.watch(currentEventIdProvider);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(eventsProvider);
            },
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final isCurrentEvent = currentEventIdAsync.maybeWhen(
                  data: (id) => id == event.id,
                  orElse: () => false,
                );

                return ListTile(
                  leading: Icon(
                    isCurrentEvent ? Icons.event_available : Icons.event,
                    color: isCurrentEvent ? Colors.green : null,
                  ),
                  title: Text(event.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${event.date.toString().split(' ')[0]}'),
                      if (event.budget != null)
                        Text(
                          'Budget: \$${event.budget!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                  selected: isCurrentEvent,
                  onTap: () async {
                    final currentEventId = ref.read(
                      currentEventIdProvider.notifier,
                    );
                    await currentEventId.setCurrentEvent(event.id);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCurrentEvent)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.check_circle, color: Colors.green),
                        ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          context.push(
                            '${AppConstants.eventSettingsRoute}/${event.id}',
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteEvent(context, ref, event.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final budgetController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Event Name'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(selectedDate.toString().split(' ')[0]),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: budgetController,
                  decoration: const InputDecoration(
                    labelText: 'Budget (optional)',
                    hintText: 'Enter budget amount',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  // Parse budget if provided
                  double? budget;
                  if (budgetController.text.isNotEmpty) {
                    final budgetValue = double.tryParse(budgetController.text);
                    if (budgetValue != null && budgetValue > 0) {
                      budget = budgetValue;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid budget amount'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                  }

                  final event = Event(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    date: selectedDate,
                    budget: budget,
                    createdAt: DateTime.now(),
                  );
                  final repository = ref.read(eventRepositoryProvider);
                  final result = await repository.addEvent(event);
                  result.fold(
                    (failure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message)));
                    },
                    (_) async {
                      // Auto-select the newly created event
                      final currentEventId = ref.read(
                        currentEventIdProvider.notifier,
                      );
                      await currentEventId.setCurrentEvent(event.id);
                      ref.invalidate(eventsProvider);
                      Navigator.pop(context);
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteEvent(BuildContext context, WidgetRef ref, String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: const Text(
          'This will delete the event and all associated data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Check if this is the current event
              final currentEventId = await ref.read(
                currentEventIdProvider.future,
              );
              final isCurrentEvent = currentEventId == eventId;

              // Perform cascade delete
              try {
                // 1. Get matches for the event to delete tokens
                final matchRepository = ref.read(matchRepositoryProvider);
                final matchesResult = await matchRepository.getMatchesByEventId(
                  eventId,
                );

                await matchesResult.fold(
                  (failure) async {
                    // Log but continue
                  },
                  (matches) async {
                    // 2. Delete tokens for all matches
                    final tokenRepository = ref.read(
                      revealTokenRepositoryProvider,
                    );
                    for (final match in matches) {
                      await tokenRepository.removeTokensByMatchId(match.id);
                    }
                  },
                );

                // 3. Delete participants by event
                final participantRepository = ref.read(
                  participantRepositoryProvider,
                );
                await participantRepository.removeParticipantsByEventId(
                  eventId,
                );

                // 4. Delete history by event
                final historyRepository = ref.read(
                  revealHistoryRepositoryProvider,
                );
                await historyRepository.removeHistoryByEventId(eventId);

                // 5. Delete matches by event
                await matchRepository.clearMatchesByEventId(eventId);

                // 6. Delete the event
                final eventRepository = ref.read(eventRepositoryProvider);
                final result = await eventRepository.removeEvent(eventId);

                await result.fold(
                  (failure) async {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message)));
                    }
                  },
                  (_) async {
                    // 7. Handle current event selection
                    if (isCurrentEvent) {
                      final currentEventIdNotifier = ref.read(
                        currentEventIdProvider.notifier,
                      );
                      // Get remaining events
                      final eventsList = await ref.read(eventsProvider.future);
                      if (eventsList.isNotEmpty) {
                        // Select first available event
                        await currentEventIdNotifier.setCurrentEvent(
                          eventsList.first.id,
                        );
                      } else {
                        // Clear selection if no events left
                        await currentEventIdNotifier.clearCurrentEvent();
                      }
                    }

                    // Invalidate providers
                    ref.invalidate(eventsProvider);
                    ref.invalidate(currentEventIdProvider);
                    ref.invalidate(currentEventProvider);

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Event and all associated data deleted',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting event: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
