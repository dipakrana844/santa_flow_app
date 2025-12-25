import 'package:flutter/material.dart';
import '../../domain/entities/event.dart';

/// Widget to display event budget information
class BudgetDisplayWidget extends StatelessWidget {
  final Event event;

  const BudgetDisplayWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    if (event.budget == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_money, size: 18, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            'Budget: \$${event.budget!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
