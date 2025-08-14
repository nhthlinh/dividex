// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsLocalModelAdapter extends TypeAdapter<SettingsLocalModel> {
  @override
  final int typeId = 1;

  @override
  SettingsLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsLocalModel(
      themeMode: fields[0] as String?,
      localeCode: fields[1] as String?,
      lastLogin: fields[2] as DateTime?,
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
