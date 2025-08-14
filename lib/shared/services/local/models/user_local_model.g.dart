// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLocalModelAdapter extends TypeAdapter<UserLocalModel> {
  @override
  final int typeId = 3;

  @override
  UserLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLocalModel(
      id: fields[0] as String?,
      email: fields[1] as String?,
      name: fields[2] as String?,
      avatarUrl: fields[3] as String?,
      password: fields[4] as String?,
      phoneNumber: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserLocalModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
