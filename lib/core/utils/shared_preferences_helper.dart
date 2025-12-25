import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for SharedPreferences operations
class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  /// Check if this is the first launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark first launch as completed
  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
  }

  /// Check if onboarding has been completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }
}
