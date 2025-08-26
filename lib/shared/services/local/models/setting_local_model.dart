import 'package:hive/hive.dart';

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


class SettingsLocalModelAdapter extends TypeAdapter<SettingsLocalModel> {
  @override
  final int typeId = 1;

  @override
  SettingsLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsLocalModel(
      themeMode: fields[0] as String,
      localeCode: fields[1] as String,
      lastLogin: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsLocalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.localeCode)
      ..writeByte(2)
      ..write(obj.lastLogin);
  }
}