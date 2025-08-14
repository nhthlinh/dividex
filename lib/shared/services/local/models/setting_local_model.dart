import 'package:hive/hive.dart';

part 'setting_local_model.g.dart';

@HiveType(typeId: 1)
class SettingsLocalModel extends HiveObject {
  @HiveField(0)
  final String themeMode;

  @HiveField(1)
  final String localeCode;

  @HiveField(2)
  final DateTime lastLogin;

  SettingsLocalModel({
    String? themeMode,
    String? localeCode,
    DateTime? lastLogin,
  })  : themeMode = themeMode ?? 'system',
        localeCode = localeCode ?? 'en',
        lastLogin = lastLogin ?? DateTime.now();

  SettingsLocalModel copyWith({
    String? themeMode,
    String? localeCode,
    DateTime? lastLogin,
  }) {
    return SettingsLocalModel(
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'SettingsLocalModel(themeMode: $themeMode, localeCode: $localeCode, lastLogin: $lastLogin)';
  }
}
