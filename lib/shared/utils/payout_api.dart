import 'package:Dividex/shared/utils/sha256.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class PayOutModel {
  final String referenceId;
  final double amount;
  final String description;
  final String toBin;
  final String toAccountNumber;

  PayOutModel({
    required this.amount,
    required this.description,
    required this.referenceId,
    required this.toAccountNumber,
    required this.toBin
  });
}

Future<void> callPayoutApi(PayOutModel data) async {
  const url = 'https://api-merchant.payos.vn/v1/payouts';

  // 🔹 Body
  final body = {
    "referenceId": data.referenceId,
    "amount": data.amount,
    "description": data.description,
    "toBin": data.toBin,
    "toAccountNumber": data.toAccountNumber,
    "category": ["withdraw"]
  };

  final secretKey = dotenv.env['CHECKSUM_KEY'] ?? '';

  // 🔹 Generate signature
  final signature = generateSignature(body, secretKey);

  // 🔹 Idempotency key (random)
  final idempotencyKey = DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(9999).toString();

  print(jsonEncode(body));

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': dotenv.env['CLIENT_ID'] ?? '',
        'x-api-key': dotenv.env['API_KEY'] ?? '',
        'x-idempotency-key': idempotencyKey,
        'x-signature': signature,
      },
      body: jsonEncode(body), 
    );

    debugPrint("Status: ${response.statusCode}");
    debugPrint("Response: ${response.body}");
  } catch (e) {
    debugPrint("Error: $e");
  }
}