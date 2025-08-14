// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokenLocalModelAdapter extends TypeAdapter<TokenLocalModel> {
  @override
  final int typeId = 2;

  @override
  TokenLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenLocalModel(
      accessToken: fields[0] as String?,
      refreshToken: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TokenLocalModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
