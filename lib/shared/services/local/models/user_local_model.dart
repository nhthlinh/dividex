import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class UserLocalModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? fullName;

  @HiveField(3)
  final ImageModel? avatarUrl;

  @HiveField(4)
  final String? password;

  @HiveField(5)
  final String? phoneNumber;

  UserLocalModel({ 
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    this.password,
    this.phoneNumber,
  });
}

class UserLocalModelAdapter extends TypeAdapter<UserLocalModel> {
  @override
  final int typeId = 3;

  @override
  UserLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLocalModel(
      id: fields[0] as String?,
      email: fields[1] as String?,
      fullName: fields[2] as String?,
      avatarUrl: fields[3] as ImageModel?,
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
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.phoneNumber);
  }
}
