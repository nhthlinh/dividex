import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'navigation_service.dart';

class NotificationService {
  static Future<void> initialize() async {
    // Lắng nghe khi app đang mở
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Lắng nghe khi user click vào thông báo từ FCM
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });

    // Nếu mở app từ thông báo khi app tắt
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }

    // Lắng nghe click từ local notification (Awesome)
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction action) async {
        _handleNotificationClick(action.payload ?? {});
      },
    );
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final Map<String, String> payload = message.data.map((key, value) => MapEntry(key, value.toString()));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'Thông báo',
        body: message.notification?.body ?? '',
        payload: payload,
      ),
    );
  }

  static void _handleNotificationClick(Map<String, dynamic> data) {
    final String target = data['target']?.toString() ?? '/home';
    NavigationService.navigateTo(target);
  }
}
