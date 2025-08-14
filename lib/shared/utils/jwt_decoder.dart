import 'package:jwt_decoder/jwt_decoder.dart';

String? getCurrentUserIdFromToken(String token) {
  try {
    final decodedToken = JwtDecoder.decode(token);
    final sub = decodedToken['sub'];
    if (sub is Map<String, dynamic>) {
      return sub['id'] as String?;
    }
    return null;
  } catch (e) {
    print('Lỗi khi decode token: $e');
    return null;
  }
}
