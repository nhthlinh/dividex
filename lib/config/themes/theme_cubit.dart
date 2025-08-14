import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void loadTheme() {
    final themeString = HiveService.getSettings().themeMode;
    emit(_parseTheme(themeString));
  }

  void setTheme(ThemeMode themeMode) {
    emit(themeMode);
    HiveService.updateTheme(_toString(themeMode));
  }

  void toggleTheme() {
    final nextTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    setTheme(nextTheme);
  }

  ThemeMode _parseTheme(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  String _toString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'light';
    }
  }

  void setThemeFromString(String themeString) {
    final themeMode = _parseTheme(themeString);
    setTheme(themeMode);
  }
}
