import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_constants.dart';

/// Screen to scan QR codes for reveal
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkCameraAvailability();
  }

  Future<void> _checkCameraAvailability() async {
    try {
      // MobileScanner handles permissions automatically
      // But we can check if controller is available
      if (!mounted) return;
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Camera not available. Please grant camera permission in settings.';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        final token = barcode.rawValue!;
        setState(() {
          _isProcessing = true;
        });

        // Stop scanning
        _controller.stop();

        // Navigate to reveal screen with token
        context.go('${AppConstants.revealRoute}?token=$token');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan QR Code')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Camera not available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _errorMessage = null;
                    });
                    _checkCameraAvailability();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        controller: _controller,
        onDetect: _handleBarcode,
        errorBuilder: (context, error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Camera error: ${error.errorDetails?.message ?? "Unknown error"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please grant camera permission in device settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
