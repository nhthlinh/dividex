import 'dart:async';

import 'package:Dividex/app.dart';
import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/home/presentation/bloc/bottom_nav_visibility_cubit.dart';
import 'package:Dividex/shared/bloc/app_bloc_observer.dart';
import 'package:Dividex/shared/bootstrap/error_handler.dart';
import 'package:Dividex/shared/bootstrap/firebase_service.dart';
import 'package:Dividex/shared/bootstrap/notification_initializer.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> bootstrap() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();
    await configureDependencies();
    await HiveService.initialize(reset: true);
    await FirebaseService.initialize();
    await NotificationInitializer.initialize();
    await getIt.allReady();
    ErrorHandler.setup();
    Bloc.observer = AppBlocObserver();

    //debugPaintSizeEnabled = true;

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BottomNavVisibilityCubit()),
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => LoadedNotiBloc()),
          BlocProvider(create: (_) => LocaleCubit()..loadLocale()),
          BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
          //ChangeNotifierProvider(create: (_) => AppRefreshNotifier())
        ],
        child: const MyApp(),
      ),
    );
  }, ErrorHandler.handleUncaught);
}
