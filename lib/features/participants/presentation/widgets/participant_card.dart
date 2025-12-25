import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/participant.dart';

/// Widget to display a participant in a card
class ParticipantCard extends StatelessWidget {
  final Participant participant;
  final VoidCallback onDelete;

  const ParticipantCard({
    super.key,
    required this.participant,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              participant.name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            participant.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(participant.email),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
