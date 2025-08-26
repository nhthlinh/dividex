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

class AuthEmailSent extends AuthState {
  final String email;
  const AuthEmailSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthEmailChecked extends AuthState {
  final String email;
  final bool isValid;
  const AuthEmailChecked({required this.email, required this.isValid});

  @override
  List<Object?> get props => [email, isValid];
}

class AuthEmailTimeout extends AuthState {
  final String email;
  const AuthEmailTimeout({required this.email});

  @override
  List<Object?> get props => [email];
}

