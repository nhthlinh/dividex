import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationInitializer {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Channel for app notifications',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
        )
      ],
      debug: true,
    );
  }
}
