import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> navigateTo(String routeName) async {
    if (navigatorKey.currentState == null) return;
    navigatorKey.currentState!.pushNamed(routeName);
  }
}
