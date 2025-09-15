import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter/material.dart';

/// Hiển thị một thông báo tùy chỉnh không tự tắt.
///
/// [message]: Nội dung tin nhắn của thông báo.
/// [type]: Loại thông báo (info, success, error) để xác định màu sắc.
/// [onTap]: Callback được gọi khi người dùng nhấn vào thông báo.
/// [onClose]: Callback được gọi khi người dùng nhấn nút đóng (X).
void showCustomNotification({
  required String message,
  ToastType type = ToastType.info,
}) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) {
    return;
  }

  OverlayEntry? overlayEntry; // Khai báo là nullable
  overlayEntry = OverlayEntry(
    builder: (context) => _PersistentNotification(
      message: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: getToastColor(type), // Màu chữ theo loại thông báo
              fontWeight: FontWeight.bold, // Làm nổi bật tin nhắn
            ),
      ),
      type: type,
      onTap: () {
        overlayEntry?.remove(); // Đóng thông báo khi nhấn
        //context.pushNamed(AppRouteNames.notification); // Chuyển hướng đến trang thông báo
      },
      onClose: () {
        overlayEntry?.remove(); // Đóng thông báo khi nhấn nút X
      },
    ),
  );

  overlay.insert(overlayEntry);
}

class _PersistentNotification extends StatefulWidget {
  final Text message;
  final ToastType type;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const _PersistentNotification({
    required this.message,
    required this.type,
    this.onTap,
    this.onClose,
  });

  @override 
  State<_PersistentNotification> createState() => _PersistentNotificationState();
}

class _PersistentNotificationState extends State<_PersistentNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _animation;

  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Thời gian trượt vào
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // bắt đầu ngoài bên phải
      end: const Offset(-0.05, 0.0), // kết thúc cách trái 5%
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
          color: Colors.transparent, 
          elevation: 8.0, 
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector( 
            onTap: widget.onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
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
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      widget.onClose?.call();
                      _controller.reverse().then((_) {
                        if (mounted) {
                          Navigator.of(context).pop(); // Đóng thông báo
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          
          ),
        ),
      ),
    );
  }

}