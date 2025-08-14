import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/setting_local_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SettingsService extends ChangeNotifier {
  late SettingsLocalModel _settings;

  SettingsLocalModel get settings => _settings;

  Future<void> init() async {
    _settings = HiveService.getSettings();
    debugPrint('[SettingsService] Loaded settings: $_settings');
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    final themeStr = themeMode.name; // 'light', 'dark', 'system'
    _settings = _settings.copyWith(themeMode: themeStr);
    await HiveService.saveSettings(_settings);
    notifyListeners();
    debugPrint('[SettingsService] Theme updated to $themeStr');
  }

  Future<void> updateLocale(String localeCode) async {
    _settings = _settings.copyWith(localeCode: localeCode);
    await HiveService.saveSettings(_settings);
    notifyListeners();
    debugPrint('[SettingsService] Locale updated to $localeCode');
  }

  Future<void> updateLastLogin(DateTime time) async {
    _settings = _settings.copyWith(lastLogin: time);
    await HiveService.saveSettings(_settings);
    debugPrint('[SettingsService] Last login updated to $time');
  }

  ThemeMode getThemeMode() {
    switch (_settings.themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Locale getLocale() {
    return Locale(_settings.localeCode);
  }
}
