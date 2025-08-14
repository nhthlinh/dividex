import 'dart:ui';

import 'package:Dividex/shared/utils/logger.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void setup() {
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e('Flutter UI Error', error: details.exception, stackTrace: details.stack);
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logger.e('Uncaught App Error', error: error, stackTrace: stack);
      return true;
    };
  }

  static void handleUncaught(Object error, StackTrace stack) {
    logger.e('Uncaught App Error', error: error, stackTrace: stack);
  }
}
