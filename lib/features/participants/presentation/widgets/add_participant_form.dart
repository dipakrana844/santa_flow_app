import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/participant.dart';
import '../providers/participant_providers.dart';
import '../../../events/presentation/providers/event_providers.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';

/// Form widget to add a new participant
class AddParticipantForm extends ConsumerStatefulWidget {
  const AddParticipantForm({super.key});

  @override
  ConsumerState<AddParticipantForm> createState() => _AddParticipantFormState();
}

class _AddParticipantFormState extends ConsumerState<AddParticipantForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Get current event ID
      final currentEventId = await ref.read(currentEventIdProvider.future);

      final participant = Participant(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        eventId: currentEventId,
      );

      final addParticipant = ref.read(addParticipantProvider);
      final result = await addParticipant(participant);

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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Participant added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _nameController.clear();
          _emailController.clear();
          // Invalidate both providers
          ref.invalidate(participantsProvider);
          if (currentEventId != null) {
            ref.invalidate(participantsByEventProvider(currentEventId));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter participant name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await HapticFeedbackHelper.lightImpact();
                _submit();
              },
              child: const Text('Add Participant'),
            ),
          ],
        ),
      ),
    );
  }
}
