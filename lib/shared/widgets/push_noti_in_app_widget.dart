import 'package:Dividex/config/routes/router.dart';
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
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) {
    return;
  }

  final overlayEntry = OverlayEntry(
    builder: (context) => _AnimatedBorderToast(
      type: type,
      message: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: getToastColor(type)),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

class _AnimatedBorderToast extends StatefulWidget {
  final Text message;
  final ToastType type;

  const _AnimatedBorderToast({required this.message, required this.type});

  @override
  State<_AnimatedBorderToast> createState() => _AnimatedBorderToastState();
}

class _AnimatedBorderToastState extends State<_AnimatedBorderToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Thời gian trượt vào
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),  // Từ bên phải
      end: const Offset(-0.05, 0.0),               // Vị trí cuối cùng
    ).animate(_animation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: 90,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.9,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Theme.of(context).colorScheme.surface, 
          elevation: 8.0, 
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.message,
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: BorderProgressPainter(
                    progress: _controller,
                    color: getToastColor(widget.type),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BorderProgressPainter extends CustomPainter {
  final Animation<double> progress;
  final Color color;

  BorderProgressPainter({required this.progress, required this.color})
    : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)));

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      final totalLength = metric.length * progress.value;

      final pathToDraw = metric.extractPath(0, totalLength);

      canvas.drawPath(pathToDraw, paint);
    }
  }

  @override
  bool shouldRepaint(BorderProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
