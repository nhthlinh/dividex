import 'dart:async';
import 'dart:typed_data';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/home/presentation/pages/profile_page.dart';
import 'package:Dividex/features/home/presentation/pages/setting_page.dart';
import 'package:Dividex/features/image/presentation/widgets/image_update_delete_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserBloc extends Mock implements UserBloc {}

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(FakeUserEvent());
    registerFallbackValue(FakeAuthEvent());
    await HiveService.initialize(reset: true);
  });

  group('user profile - Update profile thanh cong', () {
    late MockUserBloc mockUserBloc;
    late StreamController<UserState> userStateController;

    setUp(() {
      mockUserBloc = MockUserBloc();
      userStateController = StreamController<UserState>.broadcast();

      final seededUser = UserModel(
        id: 'u-profile-1',
        fullName: 'Old Name',
        email: 'profile.user@dividex.test',
        phoneNumber: '0988888888',
        currency: CurrencyEnum.vnd,
      );

      when(() => mockUserBloc.state).thenReturn(UserState(user: seededUser));
      when(
        () => mockUserBloc.stream,
      ).thenAnswer((_) => userStateController.stream);
      when(() => mockUserBloc.close()).thenAnswer((_) async {});
      when(() => mockUserBloc.add(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await userStateController.close();
    });

    testWidgets(
      'Given profile page with valid data, when update name and tap save, then dispatch UpdateMeEvent',
      (WidgetTester tester) async {
        // Given
        const updatedName = 'Updated QA User';

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<UserBloc>.value(
              value: mockUserBloc,
              child: const ProfilePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(
          find.byKey(const Key('profile_name_input')),
          updatedName,
        );
        await tester.pumpAndSettle();

        final saveBtn = find.byKey(const Key('profile_save_button'));
        expect(saveBtn, findsOneWidget);
        final saveBtnWidget = tester.widget<ElevatedButton>(saveBtn);
        expect(saveBtnWidget.onPressed, isNotNull);
        saveBtnWidget.onPressed!.call();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockUserBloc.add(
            any(
              that: isA<UpdateMeEvent>().having(
                (UpdateMeEvent e) => e.name,
                'name',
                updatedName,
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('user profile - Upload avatar thanh cong', () {
    late MockUserBloc mockUserBloc;
    late StreamController<UserState> userStateController;

    setUp(() {
      mockUserBloc = MockUserBloc();
      userStateController = StreamController<UserState>.broadcast();

      final seededUser = UserModel(
        id: 'u-profile-2',
        fullName: 'Avatar User',
        email: 'avatar.user@dividex.test',
        phoneNumber: '0977777777',
        currency: CurrencyEnum.vnd,
      );

      when(() => mockUserBloc.state).thenReturn(UserState(user: seededUser));
      when(
        () => mockUserBloc.stream,
      ).thenAnswer((_) => userStateController.stream);
      when(() => mockUserBloc.close()).thenAnswer((_) async {});
      when(() => mockUserBloc.add(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await userStateController.close();
    });

    testWidgets(
      'Given profile page, when avatar bytes are picked and tap save, then dispatch UpdateMeEvent with avatar',
      (WidgetTester tester) async {
        // Given
        final fakeAvatar = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<UserBloc>.value(
              value: mockUserBloc,
              child: const ProfilePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        final avatarWidget = tester.widget<ImageUpdateDeleteWidget>(
          find.byKey(const Key('profile_avatar_widget')),
        );
        avatarWidget.onFilesPicked(<Uint8List>[fakeAvatar]);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('profile_name_input')),
          'Avatar User Updated',
        );
        await tester.pumpAndSettle();

        final saveBtn = find.byKey(const Key('profile_save_button'));
        expect(saveBtn, findsOneWidget);
        final saveBtnWidget = tester.widget<ElevatedButton>(saveBtn);
        expect(saveBtnWidget.onPressed, isNotNull);
        saveBtnWidget.onPressed!.call();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockUserBloc.add(
            any(
              that: isA<UpdateMeEvent>().having(
                (UpdateMeEvent e) => e.avatar,
                'avatar',
                isNotNull,
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('user profile - Validate input profile (name rong)', () {
    late MockUserBloc mockUserBloc;
    late StreamController<UserState> userStateController;

    setUp(() {
      mockUserBloc = MockUserBloc();
      userStateController = StreamController<UserState>.broadcast();

      final seededUser = UserModel(
        id: 'u-profile-3',
        fullName: 'Valid Name',
        email: 'validate.user@dividex.test',
        phoneNumber: '0966666666',
        currency: CurrencyEnum.vnd,
      );

      when(() => mockUserBloc.state).thenReturn(UserState(user: seededUser));
      when(
        () => mockUserBloc.stream,
      ).thenAnswer((_) => userStateController.stream);
      when(() => mockUserBloc.close()).thenAnswer((_) async {});
      when(() => mockUserBloc.add(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await userStateController.close();
    });

    testWidgets(
      'Given profile form, when name is empty, then save button is disabled and no update event',
      (WidgetTester tester) async {
        // Given
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<UserBloc>.value(
              value: mockUserBloc,
              child: const ProfilePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(find.byKey(const Key('profile_name_input')), '');
        await tester.pumpAndSettle();

        // Then
        final saveBtnFinder = find.byKey(const Key('profile_save_button'));
        expect(saveBtnFinder, findsOneWidget);
        final saveBtnWidget = tester.widget<ElevatedButton>(saveBtnFinder);
        expect(saveBtnWidget.onPressed, isNull);

        verifyNever(() => mockUserBloc.add(any(that: isA<UpdateMeEvent>())));
      },
    );
  });

  group('user profile - Logout quay ve login screen', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
      when(() => mockAuthBloc.add(any())).thenAnswer((_) {});

      await HiveService.saveUser(
        UserLocalModel(
          id: 'u-setting-1',
          email: 'setting.user@dividex.test',
          fullName: 'Setting User',
          avatarUrl: null,
        ),
      );
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given settings page, when tap logout, then dispatch logout event and navigate to login screen',
      (WidgetTester tester) async {
        // Given
        const loginScreenKey = Key('login_screen_marker_after_logout');

        final router = GoRouter(
          initialLocation: '/settings',
          routes: <GoRoute>[
            GoRoute(
              path: '/settings',
              name: AppRouteNames.settings,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: MultiBlocProvider(
                    providers: <BlocProvider<dynamic>>[
                      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
                      BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
                    ],
                    child: const SettingPage(),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/splash-2',
              name: AppRouteNames.splash2,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(
                    child: Text('Login Screen', key: loginScreenKey),
                  ),
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        await tester.pumpAndSettle();

        // When
        final logoutBtn = find.byKey(const Key('settings_logout_button'));
        expect(logoutBtn, findsOneWidget);
        final logoutBtnWidget = tester.widget<ElevatedButton>(logoutBtn);
        expect(logoutBtnWidget.onPressed, isNotNull);
        logoutBtnWidget.onPressed!.call();
        await tester.pumpAndSettle();

        // Then
        verify(() => mockAuthBloc.add(const AuthLogoutRequested())).called(1);
        expect(router.routeInformationProvider.value.uri.path, '/splash-2');
      },
    );
  });
}
