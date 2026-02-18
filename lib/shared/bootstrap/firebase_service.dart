import 'package:Dividex/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        if (kDebugMode) {
          debugPrint('[FirebaseService] Firebase already initialized');
        }
      }
    } catch (e) {
      if (e.toString().contains(
        'A Firebase App named "[DEFAULT]" already exists',
      )) {
        if (kDebugMode) {
          debugPrint(
            '[FirebaseService] Duplicate Firebase initialization caught and ignored.',
          );
        }
      } else {
        rethrow; // Chỉ throw lại lỗi nếu không phải lỗi duplicate
      }
    }
  }
}
