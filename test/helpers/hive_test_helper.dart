import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Helper class for Hive testing setup
class HiveTestHelper {
  /// Initialize Hive for testing
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Create a test box
  static Future<Box<dynamic>> createTestBox(String name) async {
    return await Hive.openBox(name);
  }

  /// Clear a test box
  static Future<void> clearBox(Box<dynamic> box) async {
    await box.clear();
  }

  /// Close a test box
  static Future<void> closeBox(Box<dynamic> box) async {
    await box.close();
  }

  /// Close all boxes and clean up
  static Future<void> cleanup() async {
    await Hive.close();
  }
}
