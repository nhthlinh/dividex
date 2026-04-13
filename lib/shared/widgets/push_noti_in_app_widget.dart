import 'package:Dividex/config/routes/router.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum ToastType {
  info, // Blue
  success, // Green
  error, // Red
}

Color getToastColor(ToastType type) {
  switch (type) {
    case ToastType.info:
      return Colors.blue;
    case ToastType.success:
      return Colors.green;
    case ToastType.error:
      return Colors.red;
  }
}

void showCustomToast(String message, {ToastType type = ToastType.info}) {
  final context = navigatorKey.currentState?.overlay?.context;
  if (context == null) return;

  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    duration: const Duration(seconds: 2),
    backgroundColor: getToastColor(type),
    icon: Icon(
      type == ToastType.success
          ? Icons.check_circle
          : type == ToastType.error
              ? Icons.error
              : Icons.info,
      color: Colors.white,
    ),
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
  ).show(context);
}

class AppFlushbar extends StatelessWidget {
  final String message;
  final ToastType type;

  const AppFlushbar({
    super.key,
    required this.message,
    this.type = ToastType.info,
  });

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2),
      backgroundColor: getToastColor(type),
      icon: Icon(
        type == ToastType.success
            ? Icons.check_circle
            : type == ToastType.error
                ? Icons.error
                : Icons.info,
        color: Colors.white,
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}