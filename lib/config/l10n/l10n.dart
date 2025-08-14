import 'package:flutter/material.dart';

class L10n {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'vi': return 'Tiếng Việt';
      default: return 'Unknown';
    }
  }
}
