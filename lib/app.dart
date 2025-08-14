
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:Dividex/shared/widgets/notification_toast_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  void _initFCMListeners() {
    if (_initialized || navigatorKey.currentContext == null) return;
    _initialized = true;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showCustomNotification(
        message: message.notification?.body ?? 'You have a new notification',
        type: ToastType.info,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showCustomNotification(
        message: message.notification?.body ?? 'You have a new notification',
        type: ToastType.info,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => _initFCMListeners());

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'DiviDex',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
