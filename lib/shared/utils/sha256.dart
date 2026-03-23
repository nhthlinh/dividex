import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateSignature(Map<String, dynamic> body, String secretKey) {
  final queryString = buildQueryString(body);

  final hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
  final digest = hmacSha256.convert(utf8.encode(queryString));
  print(queryString);
  print(digest.toString());
  return digest.toString();
}

String customEncode(String value) {
  return Uri.encodeComponent(value)
      .replaceAll('-', '%2D')
      .replaceAll('%20', '%20') // giữ space
      .replaceAll('!', '%21')
      .replaceAll('\'', '%27')
      .replaceAll('(', '%28')
      .replaceAll(')', '%29')
      .replaceAll('*', '%2A');
}

String buildQueryString(Map<String, dynamic> data) {
  final sortedKeys = data.keys.toList()..sort();

  final List<String> pairs = [];

  for (var key in sortedKeys) {
    var value = data[key];

    // 🔹 Convert List → JSON string (NO SPACE)
    if (value is List) {
      value = jsonEncode(value);
    }

    // 🔹 Convert number (tránh 10000.0)
    if (value is double) {
      if (value == value.toInt()) {
        value = value.toInt();
      }
    }

    final encodedKey = customEncode(key);
    final encodedValue = customEncode(value.toString());

    pairs.add('$encodedKey=$encodedValue');
  }

  return pairs.join('&');
}