import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/presentation/friend_card.dart';
import 'package:Dividex/shared/services/local/hive_boxes.dart';
import 'package:Dividex/shared/services/local/hive_keys.dart';
import 'package:Dividex/shared/services/local/models/setting_local_model.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpTestHive();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SettingsLocalModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TokenLocalModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserLocalModelAdapter());
    }

    final settingsBox = await Hive.openBox<SettingsLocalModel>(HiveBox.settings);
    final tokenBox = await Hive.openBox<TokenLocalModel>(HiveBox.token);
    final userBox = await Hive.openBox<UserLocalModel>(HiveBox.user);

    await settingsBox.put(HiveKey.settings, SettingsLocalModel());
    await tokenBox.put(HiveKey.token, TokenLocalModel(accessToken: null, refreshToken: null));
    await userBox.put(
      HiveKey.user,
      UserLocalModel(id: 'me-1', email: 'me@test.com', fullName: 'Current User', avatarUrl: null),
    );
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  testWidgets('renders friend name and accepted trailing icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FriendCard(
            friend: FriendModel(friendUid: 'f-1', fullName: 'Alice Doe'),
            type: FriendCardType.acepted,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    while (tester.takeException() != null) {
      // Ignore NetworkImage load exceptions from test environment.
    }

    expect(find.text('Alice Doe'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_outlined), findsOneWidget);
  });
}
