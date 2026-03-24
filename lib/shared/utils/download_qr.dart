import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
final GlobalKey qrKey = GlobalKey();

Future<bool> saveQrImage() async {
  try {
    // Xin quyền
    final permission = await Permission.photos.request();

    if (!permission.isGranted) {
      return false;
    }
    final boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);

    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    final bytes = byteData!.buffer.asUint8List();

    await Gal.putImageBytes(
      bytes,
      name: "vietqr_${DateTime.now().millisecondsSinceEpoch}",
    );

    return true;
  } catch (e) {
    return false;
  }
}