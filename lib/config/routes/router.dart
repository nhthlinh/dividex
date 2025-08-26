import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/go_router_refresh_stream.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/email_input_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/login_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/otp_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/reset_pass_page.dart';
import 'package:Dividex/features/auth/presentation/pages/register_flow/register_page.dart';
import 'package:Dividex/features/home/presentation/pages/add_event_page.dart';
import 'package:Dividex/features/home/presentation/pages/add_expense_page.dart';
import 'package:Dividex/features/home/presentation/pages/add_group_page.dart';
import 'package:Dividex/features/home/presentation/pages/home_page.dart';
import 'package:Dividex/features/home/presentation/pages/term_of_service_page.dart';
import 'package:Dividex/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Định nghĩa các tên route để sử dụng Type-safe routing
class AppRouteNames {
  static const String splash = 'splash';

  static const String register = 'register';

  static const String login = 'login';
  static const String requestEmail = 'request-email';
  static const String otp = 'otp';
  static const String resetPass = 'reset-pass';

  static const String home = 'home';

  static const String termOfUse = 'term-of-use';
  static const String changePass = 'change-password';

  static const String loading = 'loading';

  static const String addExpense = 'add-expense';
  static const String addGroup = 'add-group';
  static const String addEvent = 'add-event';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();

  return GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteNames.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/loading',
        name: AppRouteNames.loading,
        builder: (BuildContext context, GoRouterState state) {
          return BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthAuthenticated || current is AuthUnauthenticated,
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.goNamed(AppRouteNames.home);
              }
              if (state is AuthUnauthenticated) {
                context.goNamed(AppRouteNames.login);
              }
            },
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
        routes: [
          GoRoute(
            path: 'request-email',
            name: AppRouteNames.requestEmail,
            builder: (context, state) => const EmailInputPage(),
          ),
          GoRoute(
            path: 'otp',
            name: AppRouteNames.otp,
            builder: (context, state) => OTPInputPage.fromState(state),
          ),
          GoRoute(
            path: '/reset-pass',
            name: AppRouteNames.resetPass,
            builder: (context, state) {
              final token = state.uri.queryParameters['token'];
              if (token == null) {
                // Handle the case where token is not provided
                return const Scaffold(
                  body: Center(child: Text('Token is required for password reset')),
                );
              }
              return ResetPassPage(token: token);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: AppRouteNames.home,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as int?;
          return HomePage(selectedIndex: extra ?? 0);
        },
      ),
      GoRoute(
        path: '/add-expense',
        name: AppRouteNames.addExpense,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as int?;
          return AddExpensePage(expenseId: extra ?? 0);
        },
      ),
      GoRoute(
        path: '/add-group',
        name: AppRouteNames.addGroup,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as int?;
          return AddGroupPage(groupId: extra ?? 0);
        },
      ),
      GoRoute(
        path: '/add-event',
        name: AppRouteNames.addEvent,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as int?;
          return AddEventPage(eventId: extra ?? 0);
        },
      ),
      GoRoute(
        path: '/terms-of-use',
        name: AppRouteNames.termOfUse,
        builder: (BuildContext context, GoRouterState state) {
          return TermsOfServicePage();
        },
      ),
      GoRoute(
        path: '/change-password',
        name: AppRouteNames.changePass,
        builder: (BuildContext context, GoRouterState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.settingChangePass), // "Change Password"
            ),
            body: SizedBox.shrink()
          );
        },
      ),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final loc = state.matchedLocation;
      final isSplash = loc == '/';
      final isInLoginFlow = loc.startsWith('/login');
      final isInRegisterFlow = loc.startsWith('/register');
      final isAuthFlow = isInLoginFlow || isInRegisterFlow;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthLoading || authState is AuthInitial;

      // ✅ Đang loading hoặc init => giữ ở splash
      if (isLoading) return isSplash ? null : '/loading';

      // ✅ Nếu chưa login, đang không ở login/register/splash => về login
      if (!isAuthenticated && !isAuthFlow && !isSplash && !isLoading && loc != '/loading') {
        return '/login';
      }

      // ✅ Nếu đã login mà lại vào login/register => về home
      if (isAuthenticated && isAuthFlow) {
        return '/home';
      }

      return null; // không redirect
    },
    errorBuilder: (context, state) {
      // Xử lý lỗi nếu cần
      return Scaffold(body: Center(child: Text('Error: ${state.error}')));
    },
  );
}
