import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event.dart';
import '../providers/event_providers.dart';

/// Screen for editing event details
class EventSettingsScreen extends ConsumerStatefulWidget {
  final Event? event;
  final String? eventId;

  const EventSettingsScreen({super.key, this.event, this.eventId})
    : assert(
        event != null || eventId != null,
        'Either event or eventId must be provided',
      );

  /// Factory constructor to create screen from event ID
  factory EventSettingsScreen.fromEventId({required String eventId}) {
    return EventSettingsScreen(eventId: eventId);
  }

  @override
  ConsumerState<EventSettingsScreen> createState() =>
      _EventSettingsScreenState();
}

class _EventSettingsScreenState extends ConsumerState<EventSettingsScreen> {
  TextEditingController? _nameController;
  TextEditingController? _budgetController;
  DateTime? _selectedDate;
  bool _isSaving = false;
  Event? _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    if (_event != null) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    if (_event == null) return;
    _nameController = TextEditingController(text: _event!.name);
    _budgetController = TextEditingController(
      text: _event!.budget?.toStringAsFixed(2) ?? '',
    );
    _selectedDate = _event!.date;
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _budgetController?.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (_nameController == null || _nameController!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event name is required'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Parse budget if provided
    double? budget;
    if (_budgetController != null && _budgetController!.text.isNotEmpty) {
      final budgetValue = double.tryParse(_budgetController!.text);
      if (budgetValue != null && budgetValue > 0) {
        budget = budgetValue;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid budget amount'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }
    }

    if (_event == null || _nameController == null || _selectedDate == null)
      return;

    final updatedEvent = _event!.copyWith(
      name: _nameController!.text.trim(),
      date: _selectedDate!,
      budget: budget,
    );

    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.updateEvent(updatedEvent);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
        );
      },
      (_) {
        ref.invalidate(eventsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      },
    );

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If eventId is provided, fetch the event
    if (widget.eventId != null && _event == null) {
      final eventAsync = ref.watch(eventByIdProvider(widget.eventId!));

      return Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        body: eventAsync.when(
          data: (event) {
            if (event == null) {
              return const Center(child: Text('Event not found'));
            }
            // Initialize controllers once event is loaded
            if (_event == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _event = event;
                    _initializeControllers();
                  });
                }
              });
              return const Center(child: CircularProgressIndicator());
            }
            return _buildContent(context);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(eventByIdProvider(widget.eventId!)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // If event is provided directly, build normally
    if (_event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.check), onPressed: _saveEvent),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_event == null || _nameController == null || _selectedDate == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              hintText: 'Enter event name',
              prefixIcon: Icon(Icons.event),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Date'),
            subtitle: Text(_selectedDate!.toString().split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate!,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _budgetController,
            decoration: const InputDecoration(
              labelText: 'Budget (optional)',
              hintText: 'Enter budget amount',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSaving ? null : _saveEvent,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
