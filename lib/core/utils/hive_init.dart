import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Initialize Hive for local storage
class HiveInit {
  HiveInit._();

  static Box<dynamic>? _participantsBox;
  static Box<dynamic>? _matchesBox;
  static Box<dynamic>? _eventsBox;
  static Box<dynamic>? _settingsBox;
  static Box<dynamic>? _revealTokensBox;
  static Box<dynamic>? _revealHistoryBox;

  /// Initialize Hive and open all boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Open all boxes with explicit configuration to ensure persistence
    _participantsBox = await Hive.openBox(AppConstants.participantsBoxName);
    _matchesBox = await Hive.openBox(AppConstants.matchesBoxName);
    _eventsBox = await Hive.openBox(AppConstants.eventsBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    _revealTokensBox = await Hive.openBox(AppConstants.revealTokensBoxName);
    _revealHistoryBox = await Hive.openBox(AppConstants.revealHistoryBoxName);
  }

  /// Get participants box
  static Box<dynamic> get participantsBox {
    if (_participantsBox == null) {
      throw Exception('Hive not initialized. Call HiveInit.init() first.');
    }
    return _participantsBox!;
  }

  /// Get matches box
  static Box<dynamic> get matchesBox {
    if (_matchesBox == null) {
      throw Exception('Hive not initialized. Call HiveInit.init() first.');
    }
    return _matchesBox!;
  }

  /// Get events box
  static Box<dynamic> get eventsBox {
    if (_eventsBox == null) {
      throw Exception('Hive not initialized. Call HiveInit.init() first.');
    }
    return _eventsBox!;
  }

  /// Get settings box
  static Box<dynamic> get settingsBox {
    if (_settingsBox == null) {
      throw Exception('Hive not initialized. Call HiveInit.init() first.');
    }
    return _settingsBox!;
  }

  /// Get reveal tokens box
  static Box<dynamic> get revealTokensBox {
    if (_revealTokensBox == null) {
      throw Exception('Hive not initialized. Call HiveInit.init() first.');
    }
    return _revealTokensBox!;
  }

  /// Get reveal history box
  static Box<dynamic> get revealHistoryBox {
    if (_revealHistoryBox == null) {
      throw Exception('Hive not initialized. Call HiveInit.init() first.');
    }
    return _revealHistoryBox!;
  }

  /// Close all boxes (useful for testing)
  static Future<void> closeAll() async {
    await Hive.close();
    _participantsBox = null;
    _matchesBox = null;
    _eventsBox = null;
    _settingsBox = null;
    _revealTokensBox = null;
    _revealHistoryBox = null;
  }
}
