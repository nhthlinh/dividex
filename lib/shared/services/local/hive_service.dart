import 'package:Dividex/shared/services/local/hive_boxes.dart';
import 'package:Dividex/shared/services/local/hive_keys.dart';
import 'package:Dividex/shared/services/local/models/setting_local_model.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static bool _isTestMode = false;
  static TokenLocalModel? _mockToken;
  static String _mockLocale = 'vi';

  static void enableTestMode({String locale = 'vi'}) {
    _isTestMode = true;
    _mockLocale = locale;
  }

  static SettingsLocalModel getSettings() {
    if (_isTestMode) {
      return SettingsLocalModel(localeCode: _mockLocale);
    }
    final settings =
        getSettingsBox().get(HiveKey.settings) ?? SettingsLocalModel();
    return settings;
  }

  static TokenLocalModel? getToken() {
    if (_isTestMode) return _mockToken;
    return getTokenBox().get(HiveKey.token);
  }

  static Future<void> saveToken(TokenLocalModel token) async {
    if (_isTestMode) {
      _mockToken = token;
      return;
    }
    await getTokenBox().put(HiveKey.token, token);
  }

  // Initialize Hive and open all boxes
  static Future<void> initialize({bool reset = false}) async {
    await Hive.initFlutter();
    if (reset) {
      await Hive.close(); 
      await Hive.deleteFromDisk(); 
    }

    Hive.registerAdapter(SettingsLocalModelAdapter());
    Hive.registerAdapter(TokenLocalModelAdapter());
    Hive.registerAdapter(UserLocalModelAdapter());

    await Hive.openBox<SettingsLocalModel>(HiveBox.settings);
    await Hive.openBox<TokenLocalModel>(HiveBox.token);
    await Hive.openBox<UserLocalModel>(HiveBox.user);

  }

  //========================== SETTINGS ==========================//

  static Box<SettingsLocalModel> getSettingsBox() =>
      Hive.box<SettingsLocalModel>(HiveBox.settings);

  static Future<void> saveSettings(SettingsLocalModel settings) async {
    await getSettingsBox().put(HiveKey.settings, settings);
  }

  // static SettingsLocalModel getSettings() {
  //   final settings =
  //       getSettingsBox().get(HiveKey.settings) ?? SettingsLocalModel();
  //   return settings;
  // }

  static Future<void> updateTheme(String theme) async {
    final current = getSettings();
    final updated = current.copyWith(themeMode: theme);
    await saveSettings(updated);
  }

  static Future<void> updateLocale(String locale) async {
    final current = getSettings();
    final updated = current.copyWith(localeCode: locale);
    await saveSettings(updated);
  }

  static Future<void> updateLastLogin(DateTime dateTime) async {
    final current = getSettings();
    final updated = current.copyWith(lastLogin: dateTime);
    await saveSettings(updated);
  }

  //========================== TOKEN ==========================//
  static Box<TokenLocalModel> getTokenBox() => Hive.box<TokenLocalModel>(HiveBox.token);

  // static Future<void> saveToken(TokenLocalModel token) async {
  //   await getTokenBox().put(HiveKey.token, token);
  // }

  // static TokenLocalModel? getToken() {
  //   return getTokenBox().get(HiveKey.token);
  // }

  static Future<void> clearToken() async {
    await getTokenBox().delete(HiveKey.token);
  }

  //========================== USER ==========================//
  static Box<UserLocalModel> getUserBox() => Hive.box<UserLocalModel>(HiveBox.user);

  static Future<void> saveUser(UserLocalModel user) async {
    await getUserBox().put(HiveKey.user, user);
  }

  static UserLocalModel getUser() {
    return getUserBox().get(HiveKey.user) ?? UserLocalModel(id: '', fullName: '', email: '', avatarUrl: '');
  }

  static Future<void> clearUser() async {
    await getUserBox().delete(HiveKey.user);
  }

  static void mockToken({
    required String accessToken,
    required String refreshToken,
  }) {
    _mockToken = TokenLocalModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}