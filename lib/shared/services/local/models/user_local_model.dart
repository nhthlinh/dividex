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

  @HiveField(6)
  final String? preferredCurrency;

  @HiveField(7)
  final int? countUserLogin;

  UserLocalModel({ 
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    this.password,
    this.phoneNumber,
    this.preferredCurrency,
    this.countUserLogin,
  });

  UserLocalModel copyWith({
    String? id,
    String? email,
    String? fullName,
    ImageModel? avatarUrl,
    String? password,
    String? phoneNumber,
    String? preferredCurrency,
    int? countUserLogin,
  }) {
    return UserLocalModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      countUserLogin: countUserLogin ?? this.countUserLogin,
    );
  }
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
      preferredCurrency: fields[6] as String?,
      countUserLogin: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserLocalModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.preferredCurrency)
      ..writeByte(7)
      ..write(obj.countUserLogin);
  }
}
