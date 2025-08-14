part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();

  @override
  List<Object?> get props => [];
}

class AuthUnauthenticated extends AuthState {}

class AuthOtpSent extends AuthState {
  final String email;
  const AuthOtpSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthOtpChecked extends AuthState {
  final String email;
  final String otp;
  const AuthOtpChecked({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class AuthOtpSuccess extends AuthState {
  final String email;
  const AuthOtpSuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthOtpTimeout extends AuthState {
  final String email;
  const AuthOtpTimeout({required this.email});

  @override
  List<Object?> get props => [email];
}

