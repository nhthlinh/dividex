import 'dart:async';
import 'package:flutter/foundation.dart';

/// Nghe một `Stream` và gọi `notifyListeners()` khi có sự kiện.
///
/// Dùng để buộc `GoRouter` (hoặc bất kỳ listener nào) refresh
/// khi stream phát dữ liệu — ví dụ: thay đổi trạng thái đăng nhập.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Tạo và đăng ký lắng nghe trên `stream`.
  /// Sử dụng `asBroadcastStream()` để cho phép nhiều listener nếu cần.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // thông báo ngay khi khởi tạo
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel(); // huỷ đăng ký khi không còn cần thiết
    super.dispose();
  }
}
