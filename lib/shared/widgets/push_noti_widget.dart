import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showCustomNotification({
  required String message,
  ToastType type = ToastType.info,
}) {

  final context = navigatorKey.currentContext;
  if (context == null) return; // Đảm bảo context tồn tại trước khi hiển thị thông báo

  Flushbar(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: BorderRadius.circular(8),
    duration: Duration(seconds: 2),
    backgroundColor: getToastColor(type),
    icon: Icon(
      type == ToastType.success ? Icons.check_circle : type == ToastType.error ? Icons.error : Icons.info,
      color: Colors.white,
    ),
    messageText: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
  ).show(context);
}