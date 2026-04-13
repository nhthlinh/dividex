import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Deep sort Map (tương đương object trong JS) với tùy chọn sort array
Map<String, dynamic> deepSortMap(
  Map<String, dynamic> map, {
  bool sortArrays = false,
}) {
  final sortedKeys = map.keys.toList()..sort();

  return {
    for (final key in sortedKeys) key: _sortValue(map[key], sortArrays),
  };
}

dynamic _sortValue(dynamic value, bool sortArrays) {
  if (value is Map<String, dynamic>) {
    return deepSortMap(value, sortArrays: sortArrays);
  } else if (value is List) {
    if (sortArrays) {
      // Sort array + sort recursive các phần tử là object
      final sortedList = value.map((item) {
        if (item is Map<String, dynamic>) {
          return deepSortMap(item, sortArrays: sortArrays);
        }
        return item;
      }).toList();

      sortedList.sort((a, b) {
        if (a is! Map && b is! Map) {
          return a.toString().compareTo(b.toString());
        }
        // So sánh object bằng JSON string (giống JS)
        return jsonEncode(a).compareTo(jsonEncode(b));
      });
      return sortedList;
    } else {
      // Giữ nguyên thứ tự array, chỉ sort recursive bên trong
      return value.map((item) {
        if (item is Map<String, dynamic>) {
          return deepSortMap(item, sortArrays: sortArrays);
        }
        return item;
      }).toList();
    }
  }
  return value;
}

/// Tạo HMAC signature (tương đương createSignatureBrowser)
Future<String> generateSignature(
  String secretKey,
  Map<String, dynamic> jsonData, {
  bool encodeUri = true,
  bool sortArrays = false,
  String algorithm = 'SHA-256', // 'SHA-1', 'SHA-256', 'SHA-512'
}) async {
  // Bước 1: Deep sort Map
  final sortedData = deepSortMap(jsonData, sortArrays: sortArrays);

  // Bước 2: Tạo query string
  final queryParts = <String>[];

  for (final entry in sortedData.entries) {
    dynamic value = entry.value;

    // Xử lý array và object nested → chuyển thành JSON string
    if (value is List || (value is Map && value.isNotEmpty)) {
      value = jsonEncode(value);
    }

    // null/undefined → ''
    final stringValue = (value == null) ? '' : value.toString();

    if (encodeUri) {
      queryParts.add(
        '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(stringValue)}',
      );
    } else {
      queryParts.add('${entry.key}=$stringValue');
    }
  }

  final queryString = queryParts.join('&');

  // Bước 3: HMAC với package crypto
  final keyBytes = utf8.encode(secretKey);
  final messageBytes = utf8.encode(queryString);

  late final Digest digest;

  switch (algorithm.toUpperCase()) {
    case 'SHA-1':
      digest = Hmac(sha1, keyBytes).convert(messageBytes);
      break;
    case 'SHA-512':
      digest = Hmac(sha512, keyBytes).convert(messageBytes);
      break;
    case 'SHA-256':
    default:
      digest = Hmac(sha256, keyBytes).convert(messageBytes);
      break;
  }

  // Trả về hex lowercase (giống Web Crypto API)
  return digest.toString(); // crypto package đã trả hex string
}

/// Verify signature
Future<bool> verifySignatureFlutter(
  String secretKey,
  Map<String, dynamic> jsonData,
  String expectedSignature, {
  bool encodeUri = true,
  bool sortArrays = false,
  String algorithm = 'SHA-256',
}) async {
  final computed = await generateSignature(
    secretKey,
    jsonData,
    encodeUri: encodeUri,
    sortArrays: sortArrays,
    algorithm: algorithm,
  );

  return computed.toLowerCase() == expectedSignature.toLowerCase();
}