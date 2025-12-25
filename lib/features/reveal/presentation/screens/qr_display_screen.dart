import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Screen to display QR code for reveal
class QrDisplayScreen extends StatelessWidget {
  final String token;
  final String participantName;

  const QrDisplayScreen({
    super.key,
    required this.token,
    required this.participantName,
  });

  void _copyToken() {
    Clipboard.setData(ClipboardData(text: token));
    // Note: We can't show SnackBar here since this is a StatelessWidget
    // The caller should handle feedback
  }

  void _shareToken(BuildContext context) {
    Share.share(
      'Your Secret Santa reveal token: $token\n\nScan the QR code with the Secret Santa app to reveal your match!',
      subject: 'Your Secret Santa Reveal',
    );
  }

  void _shareViaEmail(BuildContext context) {
    // Format email content with clear instructions
    final emailBody =
        '''
Hello $participantName,

Your Secret Santa reveal is ready! 

To reveal your match:
1. Open the Secret Santa app
2. Tap the QR scanner icon
3. Scan the QR code in the image below
   
Or use the reveal token: $token

The QR code contains your unique reveal token. Scan it with the app to see who you're giving a gift to!

Happy Holidays!
''';

    Share.share(
      emailBody,
      subject: 'Your Secret Santa Reveal - $participantName',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your QR Code')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan to reveal your match!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              QrImageView(
                data: token,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                participantName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _copyToken();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Token copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Token'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _shareToken(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _shareViaEmail(context),
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Scan this QR code with the Secret Santa app to reveal your match!',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
