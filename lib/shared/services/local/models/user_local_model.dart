import 'package:hive/hive.dart';

part 'user_local_model.g.dart';

@HiveType(typeId: 3)
class UserLocalModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? avatarUrl;

  @HiveField(4)
  final String? password;

  @HiveField(5)
  final String? phoneNumber;

  UserLocalModel({ 
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
    this.password,
    this.phoneNumber,
  });
}
