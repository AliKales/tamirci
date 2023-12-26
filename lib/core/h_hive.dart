import 'package:caroby/caroby.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tamirci/core/models/m_iban.dart';

enum HiveBox {
  settings,
}

enum HiveSettings {
  lastScanPath,
  emailVerified,
  emailVerificationSentAt,
  ibans,
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

  static List<MIban> getIbans() {
    List l = HHive.getSettings(HiveSettings.ibans) ?? [];

    final newList = l.cast<Map<dynamic, dynamic>>();

    return newList.map((e) => MIban.fromJson(e.toStringDynamic!)).toList();
  }
}
