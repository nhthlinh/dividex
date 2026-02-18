import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> sendFcmTokenToBackend(bool isLogin) async {
  if (isLogin) {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        // Gọi API update FCM token lên server
        final authRemote = await getIt.getAsync<AuthRemoteDataSource>();
        await authRemote.updateFcmToken(fcmToken);
      }
    } catch (e) {
      debugPrint('Error sending FCM token: $e');
    }
  } else {
    try {
      // Gọi API để xóa FCM token trên server
      final authRemote = await getIt.getAsync<AuthRemoteDataSource>();
      await authRemote.updateFcmToken('');
    } catch (e) {
      // Logging nếu cần
      debugPrint('Error deleting FCM token: $e');
    }
  }
}
