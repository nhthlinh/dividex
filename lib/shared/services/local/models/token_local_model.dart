import 'package:hive/hive.dart';

part 'token_local_model.g.dart';

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