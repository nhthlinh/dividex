import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class FancyCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const FancyCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: FancyBackgroundPainter(),
        child: Container(
          width: 327,
          height: 220,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class FancyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = AppThemes.primary1Color; 
    final paint2 = Paint()..color = AppThemes.primary3Color;
    final paint3 = Paint()..color = AppThemes.primary5Color;

    // nền chính
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint2);

    // nửa hình tròn to bên trái
    canvas.drawCircle(Offset(0, size.height), size.height * 0.8, paint1);

    // hình tròn nhỏ bên phải
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2),
        size.height * 0.4, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
