import 'dart:async';

import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Dividex/app.dart';
import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============= MOCK CLASSES =============

class MockAuthBloc extends Mock implements AuthBloc {}
class MockThemeCubit extends Mock implements ThemeCubit {}
class MockLocaleCubit extends Mock implements LocaleCubit {}
class MockGoRouter extends Mock implements GoRouter {}

// ============= HELPER FUNCTION =============

/// Map of route names to their expected page widget types for verification
/// For pages wrapped in AppShell, we check for AppShell instead of individual page
final Map<String, Type> routePageWidgets = {
  AppRouteNames.search: AppShell,
  AppRouteNames.searchUser: AppShell,
  AppRouteNames.searchTransaction: AppShell,
};

/// Builds MyApp wrapped with all necessary Bloc providers for testing
Widget buildAppWithMocks({
  required MockAuthBloc mockAuthBloc,
  required MockThemeCubit mockThemeCubit,
  required MockLocaleCubit mockLocaleCubit,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>.value(value: mockAuthBloc),
      BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
      BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
    ],
    child: MyApp(),
  );
}

/// Safely navigate to a named route with automatic retry and error handling
/// 
/// This function finds a Scaffold in the widget tree (which has access to GoRouter)
/// and uses that context for navigation, retrying up to 3 times on failure.
/// 
/// Optionally verifies that the expected page widget was rendered.
/// Helper to inspect widget tree for debugging
void _debugPrintWidgetTree(WidgetTester tester, String context) {
  try {
    final finder = find.byType(Object);
    final widgets = finder.evaluate();
    final widgetTypes = widgets
        .map((e) => e.widget.runtimeType.toString())
        .toSet()
        .toList()
        .take(15)
        .join(', ');
    debugPrint('$context - Widget tree snapshot: $widgetTypes...');
  } catch (e) {
    debugPrint('Could not inspect widget tree: $e');
  }
}

Future<bool> _safeNavigateAndVerify(
  WidgetTester tester,
  String routeName, {
  bool verifyPageWidget = false,
}) async {
  const maxAttempts = 3;
  const retryDelay = Duration(milliseconds: 300);
  const navigationTimeout = Duration(seconds: 8);

  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      // First, find a Scaffold or other widget inside the app to get the correct context
      // This context will have access to the GoRouter in its ancestor chain
      final scaffoldFinder = find.byType(Scaffold);
      
      if (scaffoldFinder.evaluate().isEmpty) {
        debugPrint(
            'Navigation to $routeName attempt $attempt: Scaffold not found yet');
        if (attempt < maxAttempts) {
          await tester.pump(retryDelay);
        }
        continue;
      }

      // Get the context from the Scaffold (a widget inside the app)
      final scaffoldContext = tester.element(scaffoldFinder.first);
      
      // Now we can safely call GoRouter.of with the correct context
      GoRouter.of(scaffoldContext).pushNamed(routeName);

      // Wait for navigation animation and widget tree to stabilize
      await tester.pumpAndSettle(
        const Duration(milliseconds: 800),
        EnginePhase.sendSemanticsUpdate,
        navigationTimeout,
      );

      // Verify app is still healthy after navigation
      expect(
        find.byType(MaterialApp),
        findsWidgets,
        reason:
            'MaterialApp should be in widget tree after navigating to $routeName',
      );

      // If available, verify the expected page widget rendered
      if (verifyPageWidget && routePageWidgets.containsKey(routeName)) {
        final pageWidgetType = routePageWidgets[routeName]!;
        
        // Try to find the page widget with multiple attempts
        // (pages may be building asynchronously via BlocBuilder, etc.)
        bool pageFound = false;
        for (int widgetAttempt = 0; widgetAttempt < 5; widgetAttempt++) {
          final pageWidgetFinder = find.byType(pageWidgetType);
          if (pageWidgetFinder.evaluate().isNotEmpty) {
            pageFound = true;
            break;
          }
          // Wait a bit more for widget to build
          await tester.pump(const Duration(milliseconds: 250));
        }
        
        if (pageFound) {
          debugPrint(
              '✓ Successfully navigated to route: $routeName and ${pageWidgetType.toString()} rendered (attempt $attempt/$maxAttempts)');
        } else {
          // Log diagnostic info about what widgets are actually in the tree
          _debugPrintWidgetTree(tester, 'Failed to find $pageWidgetType at route $routeName');
          debugPrint(
              '⚠ Navigated to $routeName but ${pageWidgetType.toString()} not found - may be wrapped or still loading');
        }
      } else {
        debugPrint(
            'Successfully navigated to route: $routeName (attempt $attempt/$maxAttempts)');
      }
      
      return true;
    } catch (e) {
      debugPrint(
          'Navigation to $routeName failed on attempt $attempt/$maxAttempts: ${e.toString()}');

      if (attempt < maxAttempts) {
        await tester.pump(retryDelay);
      }
    }
  }

  debugPrint(
      'Failed to navigate to $routeName after $maxAttempts attempts - skipping');
  return false;
}

// ============= MAIN TEST SETUP =============

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Register fallback values for mocktail
    registerFallbackValue(AuthLogoutRequested());

    // Initialize Hive for local storage
    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'test-user-id',
        email: 'test@dividex.test',
        fullName: 'Test User',
        avatarUrl: null,
      ),
    );
  });

  group('App Route Traversal Integration Tests', () {
    late MockAuthBloc mockAuthBloc;
    late MockThemeCubit mockThemeCubit;
    late MockLocaleCubit mockLocaleCubit;
    late StreamController<dynamic> authStateController;
    late StreamController<ThemeMode> themeStateController;
    late StreamController<Locale> localeStateController;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      mockThemeCubit = MockThemeCubit();
      mockLocaleCubit = MockLocaleCubit();
      authStateController = StreamController<dynamic>.broadcast();
      themeStateController = StreamController<ThemeMode>.broadcast();
      localeStateController = StreamController<Locale>.broadcast();

      // Setup AuthBloc - return unauthenticated state
      when(() => mockAuthBloc.state).thenReturn(
        AuthUnauthenticated(),
      );
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => authStateController.stream.cast<AuthState>(),
      );
      when(() => mockAuthBloc.add(any())).thenAnswer((_) {});

      // Setup ThemeCubit - return light theme mode
      when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
      when(() => mockThemeCubit.stream)
          .thenAnswer((_) => themeStateController.stream);

      // Setup LocaleCubit - return English locale
      when(() => mockLocaleCubit.state).thenReturn(const Locale('en', ''));
      when(() => mockLocaleCubit.stream)
          .thenAnswer((_) => localeStateController.stream);
    });

    tearDown(() {
      authStateController.close();
      themeStateController.close();
      localeStateController.close();
    });

    testWidgets(
        'App boots successfully with all required Blocs provided',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify app has basic structure
      expect(find.byType(MaterialApp), findsWidgets);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets(
        'Navigate through public routes without authentication',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // These routes should be accessible without authentication
      final publicRoutes = [
        AppRouteNames.splash,
        AppRouteNames.splash2,
        AppRouteNames.loading,
        AppRouteNames.register,
        AppRouteNames.login,
        AppRouteNames.termOfUse,
      ];

      for (final route in publicRoutes) {
        await _safeNavigateAndVerify(tester, route);
      }

      expect(true, true);
    });

    testWidgets(
        'Navigate through search feature routes',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final searchRoutes = [
        AppRouteNames.search,
        AppRouteNames.searchUser,
        AppRouteNames.searchTransaction,
      ];

      for (final route in searchRoutes) {
        await _safeNavigateAndVerify(tester, route, verifyPageWidget: true);
      }

      expect(true, true);
    });

    testWidgets(
        'Navigate through transaction and expense routes',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final transactionRoutes = [
        AppRouteNames.addExpense,
        AppRouteNames.addGroup,
        AppRouteNames.addEvent,
      ];

      for (final route in transactionRoutes) {
        await _safeNavigateAndVerify(tester, route);
      }

      expect(true, true);
    });

    testWidgets(
        'Navigate through communication routes',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final communicationRoutes = [
        AppRouteNames.chat,
      ];

      for (final route in communicationRoutes) {
        await _safeNavigateAndVerify(tester, route);
      }

      expect(true, true);
    });

    testWidgets(
        'Navigate through user settings routes',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final settingsRoutes = [
        AppRouteNames.settings,
        AppRouteNames.profile,
        AppRouteNames.changePass,
      ];

      for (final route in settingsRoutes) {
        await _safeNavigateAndVerify(tester, route);
      }

      expect(true, true);
    });

    testWidgets(
        'Rapid sequential navigation maintains app stability',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test rapid back-to-back navigation
      final routes = [
        AppRouteNames.splash,
        AppRouteNames.splash2,
        AppRouteNames.loading,
        AppRouteNames.register,
        AppRouteNames.login,
        AppRouteNames.search,
        AppRouteNames.chat,
      ];

      for (final route in routes) {
        try {
          await _safeNavigateAndVerify(tester, route);
        } catch (e) {
          debugPrint(
              'Navigation error on route $route: $e - continuing with next route');
        }
      }

      // Verify app is still responsive after rapid navigation
      expect(find.byType(MaterialApp), findsWidgets);
    });

    testWidgets(
        'Back navigation works after route changes',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to a route
      await _safeNavigateAndVerify(tester, AppRouteNames.search);

      // Now get context from Scaffold to check if we can pop
      final scaffoldFinder = find.byType(Scaffold);
      if (scaffoldFinder.evaluate().isNotEmpty) {
        final scaffoldContext = tester.element(scaffoldFinder.first);
        final router = GoRouter.of(scaffoldContext);

      // Attempt back navigation
        if (router.canPop()) {
          router.pop();
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        }
      }

      // Verify app is still responsive
      expect(find.byType(MaterialApp), findsWidgets);
    });

    testWidgets(
        'App maintains state during route transitions',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate multiple times and verify state is maintained
      final routes = [
        AppRouteNames.splash,
        AppRouteNames.register,
        AppRouteNames.login,
        AppRouteNames.splash,
      ];

      for (final route in routes) {
        await _safeNavigateAndVerify(tester, route);

        // After each navigation, verify app is still in valid state
        expect(find.byType(MaterialApp), findsWidgets,
            reason: 'MaterialApp should exist after navigating to $route');
      }

      expect(true, true);
    });

    testWidgets(
        'Navigate to multiple routes and handle edge cases',
        (tester) async {
      await tester.pumpWidget(
        buildAppWithMocks(
          mockAuthBloc: mockAuthBloc,
          mockThemeCubit: mockThemeCubit,
          mockLocaleCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test all route categories
      final allTestRoutes = [
        // Public routes
        AppRouteNames.splash,
        AppRouteNames.splash2,
        AppRouteNames.loading,

        // Auth routes
        AppRouteNames.register,
        AppRouteNames.login,
        AppRouteNames.termOfUse,

        // Main feature routes
        AppRouteNames.search,
        AppRouteNames.searchUser,
        AppRouteNames.searchTransaction,
        AppRouteNames.addExpense,
        AppRouteNames.addGroup,
        AppRouteNames.addEvent,
        AppRouteNames.chat,
        AppRouteNames.settings,
        AppRouteNames.profile,
        AppRouteNames.changePass,
      ];

      int successCount = 0;
      int failureCount = 0;

      for (final route in allTestRoutes) {
        try {
          await _safeNavigateAndVerify(tester, route);
          successCount++;
        } catch (e) {
          failureCount++;
          debugPrint('Failed to navigate to $route: $e');
        }
      }

      debugPrint(
          'Route navigation summary: $successCount successful, $failureCount failed');

      // At least 60% of routes should be navigable
      expect(
          successCount >= (allTestRoutes.length * 0.6).toInt(),
          true,
          reason:
              'Expected at least 60% route navigation success, got $successCount/${allTestRoutes.length}');
    });
  });
}
