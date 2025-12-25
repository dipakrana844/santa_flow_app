import 'package:flutter/services.dart';

/// Helper class for haptic feedback
class HapticFeedbackHelper {
  HapticFeedbackHelper._();

  /// Light impact feedback (for button presses)
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact feedback (for important actions)
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact feedback (for significant events)
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection feedback (for selection changes)
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate feedback (for errors)
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }
}
