
import 'package:Dividex/features/user/data/models/user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final int? countUserLogin;

  AuthResponseModel({required this.accessToken, required this.refreshToken, required this.user, required this.countUserLogin});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      countUserLogin: json['user']['count_use_app'] as int?,
    );
  }
}
