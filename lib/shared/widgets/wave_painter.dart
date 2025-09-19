import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  // Màu sắc của sóng
  final Color color = AppThemes.primary6Color;

  WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();

    // Bắt đầu từ đáy bên trái
    path.moveTo(0, size.height);

    // Di chuyển lên theo dạng sóng
    path.lineTo(0, size.height * 0.2);

    path.cubicTo(
      size.width * 0.2, size.height * 0.4,
      size.width * 0.35, size.height * 0.8,
      size.width * 0.5, size.height * 0.6,
    );

    path.cubicTo(
      size.width * 0.65, size.height * 0.4,
      size.width * 0.8, size.height * 0.8,
      size.width, size.height * 0.5,
    );

    // Kéo xuống đáy bên phải
    path.lineTo(size.width, size.height);

    // Đóng path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
