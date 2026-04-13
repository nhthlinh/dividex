import 'dart:convert';

import 'package:Dividex/shared/utils/jwt_decoder.dart';
import 'package:flutter_test/flutter_test.dart';

String _base64UrlEncodeJson(Map<String, dynamic> map) {
  final bytes = utf8.encode(jsonEncode(map));
  return base64Url.encode(bytes).replaceAll('=', '');
}

String _buildToken(Map<String, dynamic> payload) {
  final header = _base64UrlEncodeJson({'alg': 'HS256', 'typ': 'JWT'});
  final body = _base64UrlEncodeJson(payload);
  return '$header.$body.signature';
}

void main() {
  group('getCurrentUserIdFromToken', () {
    test('returns user id when sub contains id', () {
      final token = _buildToken({
        'sub': {'id': 'user-123'},
      });

      final result = getCurrentUserIdFromToken(token);

      expect(result, 'user-123');
    });

    test('returns null when sub is missing', () {
      final token = _buildToken({'role': 'user'});

      final result = getCurrentUserIdFromToken(token);

      expect(result, isNull);
    });

    test('returns null when sub is not an object', () {
      final token = _buildToken({'sub': 'user-123'});

      final result = getCurrentUserIdFromToken(token);

      expect(result, isNull);
    });

    test('returns null for malformed token', () {
      final result = getCurrentUserIdFromToken('not-a-jwt-token');

      expect(result, isNull);
    });
  });
}
