class AuthCredentials {
  final String email;
  final String password;

  const AuthCredentials({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
