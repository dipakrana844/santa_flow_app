import 'package:flutter/material.dart';

/// Screen for help and tutorials
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Tutorials')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Getting Started', [
            '1. Create an event or select an existing one',
            '2. Add at least 3 participants with their names and emails',
            '3. Generate matches using the matching screen',
            '4. Share QR codes with participants',
            '5. Participants scan QR codes to reveal their matches',
          ], Icons.play_circle_outline),
          const SizedBox(height: 24),
          _buildSection(context, 'Managing Events', [
            'Create multiple events for different occasions',
            'Switch between events using the events screen',
            'Set a budget for each event (optional)',
            'Edit event details anytime',
            'Delete events when no longer needed',
          ], Icons.event),
          const SizedBox(height: 24),
          _buildSection(context, 'Adding Participants', [
            'Participants are linked to the current event',
            'Each participant needs a name and email',
            'Email is used for sharing reveal links',
            'You can remove participants before generating matches',
          ], Icons.people),
          const SizedBox(height: 24),
          _buildSection(context, 'Generating Matches', [
            'Requires at least 3 participants',
            'Algorithm ensures no self-matching',
            'Each person gives to exactly one person',
            'Use re-shuffle to generate new matches',
            'Matches are saved automatically',
          ], Icons.shuffle),
          const SizedBox(height: 24),
          _buildSection(context, 'Revealing Matches', [
            'Each participant gets a unique QR code',
            'QR codes can be shared via email or link',
            'Scan QR code to reveal your match',
            'Tokens expire after 30 days',
            'View reveal history in settings',
          ], Icons.qr_code),
          const SizedBox(height: 24),
          _buildSection(context, 'FAQ', [
            'Q: Can I change matches after generating?',
            'A: Yes, use the re-shuffle button to generate new matches.',
            '',
            'Q: What if someone loses their QR code?',
            'A: You can share the reveal link via email from the QR display screen.',
            '',
            'Q: Can I use this for multiple events?',
            'A: Yes! Create separate events for different occasions.',
          ], Icons.help_outline),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> items,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!item.startsWith('Q:') && !item.startsWith('A:'))
                      const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
