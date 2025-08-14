class SessionManager {
  static String? _accessToken;
  static String? _refreshToken;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;

  static void updateToken(String token) {
    _accessToken = token;
  }

  static void clear() {
    _accessToken = null;
    _refreshToken = null;
  }
}
