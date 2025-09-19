import 'package:Dividex/config/routes/go_router_refresh_stream.dart';
import 'package:Dividex/config/routes/page_builder.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/email_input_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/login_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/otp_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/reset_pass_page.dart';
import 'package:Dividex/features/auth/presentation/pages/register_flow/register_page.dart';
import 'package:Dividex/features/home/presentation/pages/app_shell.dart';
import 'package:Dividex/features/home/presentation/pages/change_pass_page.dart';
import 'package:Dividex/features/home/presentation/pages/home_page.dart';
import 'package:Dividex/features/home/presentation/pages/setting_page.dart';
import 'package:Dividex/features/home/presentation/pages/term_of_service_page.dart';
import 'package:Dividex/features/splash/presentation/pages/splash_page.dart';
import 'package:Dividex/features/splash/presentation/pages/splash_page_2.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animations/animations.dart';

// Định nghĩa các tên route để sử dụng Type-safe routing
class AppRouteNames {
  static const String splash = 'splash';
  static const String splash2 = 'splash-2';

  static const String register = 'register';

  static const String login = 'login';

  static const String requestEmail = 'request-email';
  static const String otp = 'otp';
  static const String resetPass = 'reset-pass';

  static const String home = 'home';
  static const String search = 'search';
  static const String mail = 'mail';
  static const String settings = 'settings';

  static const String termOfUse = 'term-of-use';
  static const String changePass = 'change-password';

  static const String loading = 'loading';

  // static const String addExpense = 'add-expense';
  // static const String addGroup = 'add-group';
  // static const String addEvent = 'add-event';
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
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: const SplashPage());
        },
      ),
      GoRoute(
        path: '/splash-2',
        name: AppRouteNames.splash2,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: const SplashPage2());
        },
      ),
      GoRoute(
        path: '/loading',
        name: AppRouteNames.loading,
        builder: (context, state) => Scaffold(
          body: Center(
            child: ColoredBox(
              color: Colors.transparent,
              child: SpinKitFadingCircle(color: AppThemes.primary3Color),
            ),
          ),
        ),
      ),

      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        pageBuilder: (context, state) =>
            buildPageWithDefaultTransition(child: RegisterPage()),
      ),
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        pageBuilder: (context, state) =>
            buildPageWithDefaultTransition(child: const LoginPage()),
        routes: [
          GoRoute(
            path: 'request-email',
            name: AppRouteNames.requestEmail,
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition(child: EmailInputPage());
            },
          ),
          GoRoute(
            path: 'otp',
            name: AppRouteNames.otp,
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition(
                child: OTPInputPage.fromState(state),
              );
            },
          ),
          GoRoute(
            path: '/reset-pass/:token',
            name: AppRouteNames.resetPass,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final token = state.pathParameters['token'];
              return buildPageWithDefaultTransition(
                child: ResetPassPage(token: token ?? ''),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: AppRouteNames.home,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: const HomePage());
        },
      ),
      GoRoute(
        path: '/search',
        name: AppRouteNames.search,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            child: AppShell(
              currentIndex: 1,
              child: Layout(
                title: "Trang tìm kiếm",
                child: Column(
                  children: const [
                    Text("Nội dung trang tìm kiếm"),
                    SizedBox(height: 16),
                    Text("Thêm nội dung khác ở đây"),
                    SizedBox(height: 16),
                    Text("V.v..."),
                    SizedBox(height: 16),
                    Text("Nội dung bổ sung"),
                    SizedBox(height: 16),
                    Text("Và nhiều hơn nữa"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/mail',
        name: AppRouteNames.mail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            child: AppShell(
              currentIndex: 2,
              child: Layout(
                title: "Trang mail",
                child: Column(
                  children: const [
                    Text("Nội dung trang mail"),
                    SizedBox(height: 16),
                    Text("Thêm nội dung khác ở đây"),
                    SizedBox(height: 16),
                    Text("V.v..."),
                    SizedBox(height: 16),
                    Text("Nội dung bổ sung"),
                    SizedBox(height: 16),
                    Text("Và nhiều hơn nữa"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: AppRouteNames.settings,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: SettingPage());
        },
      ),

      // GoRoute(
      //   path: '/add-expense',
      //   name: AppRouteNames.addExpense,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final extra = state.extra as int?;
      //     return AddExpensePage(expenseId: extra ?? 0);
      //   },
      // ),
      // GoRoute(
      //   path: '/add-group',
      //   name: AppRouteNames.addGroup,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final extra = state.extra as int?;
      //     return BlocProvider<LoadedGroupsBloc>(
      //       create: (context) => LoadedGroupsBloc(),
      //       child: AddGroupPage(groupId: extra ?? 0),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/chat',
      //   name: AppRouteNames.chat,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final extra = state.extra as int?;
      //     return BlocProvider<LoadedGroupsBloc>(
      //       create: (context) => LoadedGroupsBloc(),
      //       child: ChatScreen(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/add-event',
      //   name: AppRouteNames.addEvent,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final extra = state.extra as int?;
      //     return AddEventPage(eventId: extra ?? 0);
      //   },
      // ),
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
        pageBuilder: (context, state) =>
            buildPageWithDefaultTransition(child: ChangePassPage()),
      ),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final loc = state.matchedLocation;

      final isSplash = loc == '/';
      final isLoading = loc == '/loading';
      final isLogin = loc.startsWith('/login');
      final isRegister = loc.startsWith('/register');
      final isAuthFlow = isLogin || isRegister;

      // Khi app vừa mở hoặc đang loading -> cho ở splash/loading
      if (authState is AuthInitial) {
        // để yên ở splash, đừng ép đi đâu
        return isSplash ? null : '/';
      }

      if (authState is AuthLoading) {
        return isLoading ? null : '/loading';
      }

      // Nếu chưa login
      if (authState is AuthUnauthenticated) {
        // đang ở login/register thì cho ở yên
        if (isAuthFlow || isSplash) return null;
        // còn lại ép về login
        return '/splash-2';
      }

      // Nếu đổi mật khẩu
      if (authState is AuthEmailSent) {
        return '/login/otp';
      } 
      if (authState is AuthEmailChecked) {
        return '/login/reset-pass/${authState.token}';
      }

      // Nếu đã login
      if (authState is AuthAuthenticated) {
        // nếu vào login/register thì chuyển về home
        if (isAuthFlow || isSplash || isLoading) return '/home';
      }

      return null; // giữ nguyên
    },

    errorBuilder: (context, state) {
      // Xử lý lỗi nếu cần
      return Scaffold(body: Center(child: Text('Error: ${state.error}')));
    },
  );
}
