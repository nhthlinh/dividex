import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class TokenLocalModel extends HiveObject {
  @HiveField(0)
  final String? accessToken;

  @HiveField(1)
  final String? refreshToken;

  TokenLocalModel({
    required this.accessToken,
    required this.refreshToken,
  });
}

class TokenLocalModelAdapter extends TypeAdapter<TokenLocalModel> {
  @override
  final int typeId = 2;

  @override
  TokenLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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
}
