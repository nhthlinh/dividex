import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('vi'));

  void loadLocale() {
    final localeCode = HiveService.getSettings().localeCode;
    emit(Locale(localeCode));
  }

  Future<void> changeLocale(String languageCode) async {
    await HiveService.updateLocale(languageCode);
    emit(Locale(languageCode));
  }
}
