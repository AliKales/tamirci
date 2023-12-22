import 'package:hive_flutter/hive_flutter.dart';

enum HiveBox {
  settings,
}

enum HiveSettings {
  lastScanPath,
  emailVerified,
  emailVerificationSentAt,
}

final class HHive {
  const HHive._();

  static late Box _settings;

  static Future<void> init() async {
    await Hive.initFlutter();
    _settings = await Hive.openBox(HiveBox.settings.name);
    putSettings(HiveSettings.lastScanPath, null);
  }

  static dynamic getSettings(HiveSettings settings) {
    return _settings.get(settings.name);
  }

  static Future<void> putSettings(HiveSettings settings, dynamic val) async {
    await _settings.put(settings.name, val);
  }
}
