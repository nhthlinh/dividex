import 'package:Dividex/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();

  @override
  List<Object?> get props => [];
}

class AuthRegisterRequested extends AuthEvent {
  final UserModel userData;
  final String password;

  const AuthRegisterRequested({required this.userData, required this.password});

  @override
  List<Object?> get props => [userData, password];
}

class AuthOtpRequested extends AuthEvent {
  final String email;

  const AuthOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthOtpCheckRequested extends AuthEvent {
  final String email;
  final String otp;

  const AuthOtpCheckRequested({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}

class AuthChangePasswordRequested extends AuthEvent {
  final String email;
  final String newPassword;
  final String oldPassword;

  const AuthChangePasswordRequested({
    required this.email,
    required this.newPassword,
    required this.oldPassword,
  });

  @override
  List<Object?> get props => [email, newPassword, oldPassword];
}