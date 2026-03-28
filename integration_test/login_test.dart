import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/otp_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/login_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/reset_pass_page.dart';
import 'package:Dividex/features/auth/presentation/pages/register_flow/register_page.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(FakeAuthEvent());
    await HiveService.initialize(reset: true);
  });

  group('Login_1 - Login thanh cong voi email + password dung', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given valid credentials, when tapping login, then navigate to home',
      (WidgetTester tester) async {
        // Given
        const validEmail = 'qa.login1@dividex.test';
        const validPassword = 'Password@123';
        const homePageKey = Key('home_page_marker');

        final router = GoRouter(
          initialLocation: '/login',
          routes: <GoRoute>[
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: const LoginPage(),
                );
              },
            ),
            GoRoute(
              path: '/home',
              name: AppRouteNames.home,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Home Screen', key: homePageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthLoginRequested) {
            expect(event.email, validEmail);
            expect(event.password, validPassword);
            Future<void>.microtask(
              () => authStateController.add(const AuthAuthenticated()),
            );
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('login_email_input')),
          validEmail,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('login_password_input')),
          validPassword,
        );
        await tester.pumpAndSettle();

        // 🔥 đóng keyboard (QUAN TRỌNG)
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // finder button
        final loginBtn = find
            .byKey(const Key('login_submit_button'))
            .hitTestable();

        // 🔥 chọn đúng scrollable (vertical chính)
        final scrollable = find.byType(Scrollable).first;

        // scroll tới button
        await tester.dragUntilVisible(
          loginBtn,
          scrollable,
          const Offset(0, -300),
        );

        // đảm bảo visible
        await tester.ensureVisible(loginBtn);

        // tap
        await tester.tap(loginBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(homePageKey), findsOneWidget);

        verify(
          () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
        ).called(1);
      },
    );
  });

  group('Login_2 - Login that bai khi sai password', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given valid email but wrong password, when tapping login, then stay on login and show error',
      (WidgetTester tester) async {
        // Given
        const validEmail = 'qa.login1@dividex.test';
        const wrongPassword = 'WrongPassword@123';
        const homePageKey = Key('home_page_marker');
        const loginPageKey = Key('login_page_key');

        final router = GoRouter(
          initialLocation: '/login',
          routes: <GoRoute>[
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  key: loginPageKey,
                  body: BlocProvider<AuthBloc>.value(
                    value: mockAuthBloc,
                    child: const LoginPage(),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/home',
              name: AppRouteNames.home,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Home Screen', key: homePageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthLoginRequested) {
            // Mock: nếu sai password thì emit AuthUnauthenticated (error state)
            if (event.email == validEmail && event.password == wrongPassword) {
              Future<void>.microtask(
                () => authStateController.add(AuthUnauthenticated()),
              );
            }
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('login_email_input')),
          validEmail,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('login_password_input')),
          wrongPassword,
        );
        await tester.pumpAndSettle();

        // 🔥 đóng keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Tìm button
        final loginBtn = find
            .byKey(const Key('login_submit_button'))
            .hitTestable();

        // Scroll tới button
        final scrollable = find.byType(Scrollable).first;
        await tester.dragUntilVisible(
          loginBtn,
          scrollable,
          const Offset(0, -300),
        );

        await tester.ensureVisible(loginBtn);

        // Tap login button
        await tester.tap(loginBtn);
        await tester.pumpAndSettle();

        // Then
        // Kiểm tra vẫn ở trang login (home page KHÔNG hiển thị)
        expect(find.byKey(homePageKey), findsNothing);

        // Kiểm tra trang login vẫn tồn tại
        expect(find.byKey(loginPageKey), findsOneWidget);

        // Kiểm tra AuthBloc đã nhận được event login
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
        ).called(1);
      },
    );
  });

  group('Login_3 - Login that bai khi email khong ton tai', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given non-existing email, when tapping login, then stay on login',
      (WidgetTester tester) async {
        // Given
        const nonExistingEmail = 'notfound.user@dividex.test';
        const validPassword = 'Password@123';
        const homePageKey = Key('home_page_marker');
        const loginPageKey = Key('login_page_key_not_found');

        final router = GoRouter(
          initialLocation: '/login',
          routes: <GoRoute>[
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  key: loginPageKey,
                  body: BlocProvider<AuthBloc>.value(
                    value: mockAuthBloc,
                    child: const LoginPage(),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/home',
              name: AppRouteNames.home,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Home Screen', key: homePageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthLoginRequested &&
              event.email == nonExistingEmail &&
              event.password == validPassword) {
            Future<void>.microtask(
              () => authStateController.add(AuthUnauthenticated()),
            );
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('login_email_input')),
          nonExistingEmail,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('login_password_input')),
          validPassword,
        );
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final loginBtn = find
            .byKey(const Key('login_submit_button'))
            .hitTestable();
        final scrollable = find.byType(Scrollable).first;
        await tester.dragUntilVisible(
          loginBtn,
          scrollable,
          const Offset(0, -300),
        );

        await tester.ensureVisible(loginBtn);
        await tester.tap(loginBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(homePageKey), findsNothing);
        expect(find.byKey(loginPageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
        ).called(1);
      },
    );
  });

  group('Login_4 - Validate email sai format', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given invalid email format, when tapping login, then do not submit login event',
      (WidgetTester tester) async {
        // Given
        const invalidEmail = 'invalid-email-format';
        const validPassword = 'Password@123';
        const homePageKey = Key('home_page_marker');

        final router = GoRouter(
          initialLocation: '/login',
          routes: <GoRoute>[
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: const LoginPage(),
                );
              },
            ),
            GoRoute(
              path: '/home',
              name: AppRouteNames.home,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Home Screen', key: homePageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((_) {});

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
        await tester.enterText(
          find.byKey(const Key('login_email_input')),
          invalidEmail,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('login_password_input')),
          validPassword,
        );
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final loginBtn = find
            .byKey(const Key('login_submit_button'))
            .hitTestable();
        final scrollable = find.byType(Scrollable).first;
        await tester.dragUntilVisible(
          loginBtn,
          scrollable,
          const Offset(0, -300),
        );

        await tester.ensureVisible(loginBtn);
        await tester.tap(loginBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(homePageKey), findsNothing);
        verifyNever(
          () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
        );
      },
    );
  });

  group('Login_5 - Khong cho login khi de trong field', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
      when(() => mockAuthBloc.add(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given empty email and password, when opening login page, then login button is disabled',
      (WidgetTester tester) async {
        // Given
        final router = GoRouter(
          initialLocation: '/login',
          routes: <GoRoute>[
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: const LoginPage(),
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
        final loginBtnFinder = find.byKey(const Key('login_submit_button'));

        // Then
        expect(loginBtnFinder, findsOneWidget);
        final loginButtonWidget = tester.widget<ElevatedButton>(loginBtnFinder);
        expect(loginButtonWidget.onPressed, isNull);
        verifyNever(
          () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
        );
      },
    );
  });

  group('Register_1 - Register thanh cong', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given valid register data, when tapping register, then navigate to home',
      (WidgetTester tester) async {
        // Given
        const fullName = 'QA Register User';
        const email = 'register.success@dividex.test';
        const phone = '0987654321';
        const password = 'Password@123';
        const homePageKey = Key('register_home_page_marker');

        final router = GoRouter(
          initialLocation: '/register',
          routes: <GoRoute>[
            GoRoute(
              path: '/register',
              name: AppRouteNames.register,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: const RegisterPage(),
                );
              },
            ),
            GoRoute(
              path: '/home',
              name: AppRouteNames.home,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Home Screen', key: homePageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthRegisterRequested) {
            expect(event.userData.fullName, fullName);
            expect(event.userData.email, email);
            expect(event.userData.phoneNumber, phone);
            expect(event.password, password);

            Future<void>.microtask(
              () => authStateController.add(const AuthAuthenticated()),
            );
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('register_name_input')),
          fullName,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_email_input')),
          email,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_phone_input')),
          phone,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_password_input')),
          password,
        );
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final registerBtn = find
            .byKey(const Key('register_submit_button'))
            .hitTestable();
        final scrollable = find.byType(Scrollable).first;
        await tester.dragUntilVisible(
          registerBtn,
          scrollable,
          const Offset(0, -300),
        );

        await tester.ensureVisible(registerBtn);
        await tester.tap(registerBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(homePageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthRegisterRequested>())),
        ).called(1);
      },
    );
  });

  group('Register_2 - Register fail khi email da ton tai', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given existing email, when tapping register, then stay on register page',
      (WidgetTester tester) async {
        // Given
        const fullName = 'QA Existing User';
        const existingEmail = 'existing@dividex.test';
        const phone = '0987654321';
        const password = 'Password@123';
        const homePageKey = Key('register_home_page_marker_fail');
        const registerPageKey = Key('register_page_marker_fail');

        final router = GoRouter(
          initialLocation: '/register',
          routes: <GoRoute>[
            GoRoute(
              path: '/register',
              name: AppRouteNames.register,
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  key: registerPageKey,
                  body: BlocProvider<AuthBloc>.value(
                    value: mockAuthBloc,
                    child: const RegisterPage(),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/home',
              name: AppRouteNames.home,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Home Screen', key: homePageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthRegisterRequested &&
              event.userData.email == existingEmail &&
              event.password == password) {
            Future<void>.microtask(
              () => authStateController.add(AuthUnauthenticated()),
            );
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('register_name_input')),
          fullName,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_email_input')),
          existingEmail,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_phone_input')),
          phone,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_password_input')),
          password,
        );
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final registerBtn = find
            .byKey(const Key('register_submit_button'))
            .hitTestable();
        final scrollable = find.byType(Scrollable).first;
        await tester.dragUntilVisible(
          registerBtn,
          scrollable,
          const Offset(0, -300),
        );

        await tester.ensureVisible(registerBtn);
        await tester.tap(registerBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(homePageKey), findsNothing);
        expect(find.byKey(registerPageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthRegisterRequested>())),
        ).called(1);
      },
    );
  });

  group('OTP_1 - OTP verify dung cho doi password', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});

      await HiveService.saveUser(
        UserLocalModel(
          id: 'u-otp-1',
          email: 'otp.user@dividex.test',
          fullName: 'Otp User',
          avatarUrl: null,
        ),
      );
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given correct otp, when submit otp, then navigate to reset password page',
      (WidgetTester tester) async {
        // Given
        const otp = '123456';
        const email = 'otp.user@dividex.test';
        const resetPageKey = Key('reset_password_page_marker');

        final router = GoRouter(
          initialLocation: '/login/otp',
          routes: <GoRoute>[
            GoRoute(
              path: '/login/otp',
              name: AppRouteNames.otp,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: const OTPInputPage(nextRoute: AppRouteNames.resetPass),
                );
              },
            ),
            GoRoute(
              path: '/reset-pass/:token',
              name: AppRouteNames.resetPass,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(
                    child: Text('Reset Password Page', key: resetPageKey),
                  ),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthOtpSubmitted &&
              event.otp == otp &&
              event.email == email) {
            Future<void>.microtask(
              () => authStateController.add(
                const AuthEmailChecked(
                  email: email,
                  token: 'reset-token-123',
                  isValid: true,
                ),
              ),
            );
          }
        });

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
        await tester.enterText(find.byKey(const Key('otp_input')), otp);
        await tester.pumpAndSettle();

        final otpSubmitBtn = find
            .byKey(const Key('otp_submit_button'))
            .hitTestable();
        await tester.ensureVisible(otpSubmitBtn);
        await tester.tap(otpSubmitBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(resetPageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthOtpSubmitted>())),
        ).called(1);
      },
    );
  });

  group('OTP_2 - OTP sai hoac het han khong cho vao man doi password', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});

      await HiveService.saveUser(
        UserLocalModel(
          id: 'u-otp-2',
          email: 'otp.fail@dividex.test',
          fullName: 'Otp Fail User',
          avatarUrl: null,
        ),
      );
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given invalid or expired otp, when submit otp, then stay on otp page',
      (WidgetTester tester) async {
        // Given
        const invalidOtp = '000000';
        const otpPageKey = Key('otp_page_marker_invalid');
        const resetPageKey = Key('reset_password_page_marker_invalid');

        final router = GoRouter(
          initialLocation: '/login/otp',
          routes: <GoRoute>[
            GoRoute(
              path: '/login/otp',
              name: AppRouteNames.otp,
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  key: otpPageKey,
                  body: BlocProvider<AuthBloc>.value(
                    value: mockAuthBloc,
                    child: const OTPInputPage(
                      nextRoute: AppRouteNames.resetPass,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/reset-pass/:token',
              name: AppRouteNames.resetPass,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(
                    child: Text('Reset Password Page', key: resetPageKey),
                  ),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthOtpSubmitted && event.otp == invalidOtp) {
            Future<void>.microtask(
              () => authStateController.add(AuthUnauthenticated()),
            );
          }
        });

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
        await tester.enterText(find.byKey(const Key('otp_input')), invalidOtp);
        await tester.pumpAndSettle();

        final otpSubmitBtn = find
            .byKey(const Key('otp_submit_button'))
            .hitTestable();
        await tester.ensureVisible(otpSubmitBtn);
        await tester.tap(otpSubmitBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(resetPageKey), findsNothing);
        expect(find.byKey(otpPageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthOtpSubmitted>())),
        ).called(1);
      },
    );
  });

  group('ResetPassword_1 - Reset password thanh cong va quay ve login', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given valid token and new password, when submit reset, then navigate to login',
      (WidgetTester tester) async {
        // Given
        const token = 'valid-reset-token';
        const newPassword = 'NewPassword@123';
        const loginPageKey = Key('login_page_after_reset_success');

        final router = GoRouter(
          initialLocation: '/reset-pass/$token',
          routes: <GoRoute>[
            GoRoute(
              path: '/reset-pass/:token',
              name: AppRouteNames.resetPass,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: ResetPassPage(token: state.pathParameters['token']!),
                );
              },
            ),
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Login Screen', key: loginPageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthResetPasswordRequested &&
              event.token == token &&
              event.newPassword == newPassword) {
            Future<void>.microtask(
              () => authStateController.add(AuthResetPasswordSuccess()),
            );
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('reset_password_input')),
          newPassword,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('reset_confirm_password_input')),
          newPassword,
        );
        await tester.pumpAndSettle();

        final resetSubmitBtn = find
            .byKey(const Key('reset_submit_button'))
            .hitTestable();
        await tester.ensureVisible(resetSubmitBtn);
        await tester.tap(resetSubmitBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(loginPageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthResetPasswordRequested>())),
        ).called(1);
      },
    );
  });

  group('ResetPassword_2 - Reset password fail do token khong hop le', () {
    late MockAuthBloc mockAuthBloc;
    late StreamController<AuthState> authStateController;

    setUp(() async {
      mockAuthBloc = MockAuthBloc();
      authStateController = StreamController<AuthState>.broadcast();

      when(() => mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => authStateController.stream);
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authStateController.close();
    });

    testWidgets(
      'Given invalid token, when submit reset, then stay on reset password page',
      (WidgetTester tester) async {
        // Given
        const invalidToken = 'invalid-reset-token';
        const newPassword = 'NewPassword@123';
        const resetPageKey = Key('reset_password_page_invalid_token');
        const loginPageKey = Key('login_page_after_reset_fail');

        final router = GoRouter(
          initialLocation: '/reset-pass/$invalidToken',
          routes: <GoRoute>[
            GoRoute(
              path: '/reset-pass/:token',
              name: AppRouteNames.resetPass,
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  key: resetPageKey,
                  body: BlocProvider<AuthBloc>.value(
                    value: mockAuthBloc,
                    child: ResetPassPage(token: state.pathParameters['token']!),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/login',
              name: AppRouteNames.login,
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(child: Text('Login Screen', key: loginPageKey)),
                );
              },
            ),
          ],
        );

        when(() => mockAuthBloc.add(any())).thenAnswer((Invocation invocation) {
          final event = invocation.positionalArguments.first as AuthEvent;
          if (event is AuthResetPasswordRequested &&
              event.token == invalidToken &&
              event.newPassword == newPassword) {
            Future<void>.microtask(
              () => authStateController.add(
                const AuthResetPasswordFailure(
                  message: 'invalid_or_expired_otp',
                ),
              ),
            );
          }
        });

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
        await tester.enterText(
          find.byKey(const Key('reset_password_input')),
          newPassword,
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('reset_confirm_password_input')),
          newPassword,
        );
        await tester.pumpAndSettle();

        final resetSubmitBtn = find
            .byKey(const Key('reset_submit_button'))
            .hitTestable();
        await tester.ensureVisible(resetSubmitBtn);
        await tester.tap(resetSubmitBtn);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(loginPageKey), findsNothing);
        expect(find.byKey(resetPageKey), findsOneWidget);
        verify(
          () => mockAuthBloc.add(any(that: isA<AuthResetPasswordRequested>())),
        ).called(1);
      },
    );
  });
}
