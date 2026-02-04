import 'package:flutter/foundation.dart';

class AppRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
