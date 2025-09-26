import 'package:Dividex/config/routes/go_router_refresh_stream.dart';
import 'package:Dividex/config/routes/page_builder.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/email_input_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/login_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/otp_page.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/reset_pass_page.dart';
import 'package:Dividex/features/auth/presentation/pages/register_flow/register_page.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/pages/add_event_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/add_expense_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/choose_event_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/split_page.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_request_bloc_and_event.dart'
    as request_bloc;
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/pages/add_group_page.dart';
import 'package:Dividex/features/search/presentation/bloc/search_users_bloc.dart'
    as search_bloc;
import 'package:Dividex/features/friend/presentation/pages/friend_page.dart';
import 'package:Dividex/features/search/presentation/pages/search_page.dart';
import 'package:Dividex/features/search/presentation/pages/search_user_page.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/pages/choose_members_page.dart';
import 'package:Dividex/features/auth/presentation/pages/change_pass_page.dart';
import 'package:Dividex/features/home/presentation/pages/home_page.dart';
import 'package:Dividex/features/home/presentation/pages/setting_page.dart';
import 'package:Dividex/features/home/presentation/pages/term_of_service_page.dart';
import 'package:Dividex/features/splash/presentation/pages/splash_page.dart';
import 'package:Dividex/features/splash/presentation/pages/splash_page_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  static const String friend = 'friend';

  static const String mail = 'mail';
  static const String settings = 'settings';

  static const String termOfUse = 'term-of-use';
  static const String changePass = 'change-password';

  static const String loading = 'loading';

  static const String search = 'search';
  static const String searchUser = 'search-user';
  static const String searchTransaction = 'search-transaction';
  // static const String chat = 'chat';

  static const String addExpense = 'add-expense';
  static const String addGroup = 'add-group';
  static const String addEvent = 'add-event';

  static const String chooseMember = 'choose-member';
  static const String chooseEvent = 'choose-event';
  static const String customSplit = 'custom-split';
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
        routes: [
          GoRoute(
            path: 'friend',
            name: AppRouteNames.friend,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<LoadedFriendsBloc>(
                    create: (context) => LoadedFriendsBloc(),
                  ),
                  BlocProvider<search_bloc.SearchUsersBloc>(
                    create: (context) => search_bloc.SearchUsersBloc(),
                  ),
                  BlocProvider<request_bloc.FriendRequestBloc>(
                    key: const ValueKey("receivedRequests"),
                    create: (_) => request_bloc.FriendRequestBloc(),
                  ),
                  BlocProvider<request_bloc.FriendRequestBloc>(
                    key: const ValueKey("sentRequests"),
                    create: (_) => request_bloc.FriendRequestBloc(),
                  ),
                ],
                child: const FriendPage(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        name: AppRouteNames.search,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: const SearchPage());
        },
        routes: [
          GoRoute(
            path: 'search-user',
            name: AppRouteNames.searchUser,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: BlocProvider(
                create: (context) => search_bloc.SearchUsersBloc(),
                child: const SearchUserPage(),
              ),
            ),
          ),
        ],
      ),
      // GoRoute(
      //   path: '/mail',
      //   name: AppRouteNames.mail,
      //   pageBuilder: (BuildContext context, GoRouterState state) {
      //     return buildPageWithDefaultTransition(
      //       child: AppShell(
      //         currentIndex: 2,
      //         child: Layout(
      //           title: "Trang mail",
      //           child: Column(
      //             children: const [
      //               Text("Nội dung trang mail"),
      //               SizedBox(height: 16),
      //               Text("Thêm nội dung khác ở đây"),
      //               SizedBox(height: 16),
      //               Text("V.v..."),
      //               SizedBox(height: 16),
      //               Text("Nội dung bổ sung"),
      //               SizedBox(height: 16),
      //               Text("Và nhiều hơn nữa"),
      //             ],
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
      GoRoute(
        path: '/settings',
        name: AppRouteNames.settings,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: SettingPage());
        },
      ),

      GoRoute(
        path: '/add-group',
        name: AppRouteNames.addGroup,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            child: BlocProvider<GroupBloc>(
              create: (context) => GroupBloc(),
              child: AddGroupPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/add-expense',
        name: AppRouteNames.addExpense,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            child: BlocProvider<ExpenseBloc>(
              create: (context) => ExpenseBloc(),
              child: AddExpensePage(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/add-event',
        name: AppRouteNames.addEvent,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            child: BlocProvider<EventBloc>(
              create: (context) => EventBloc(),
              child: AddEventPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/terms-of-use',
        name: AppRouteNames.termOfUse,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            child: const TermsOfServicePage(),
          );
        },
      ),
      GoRoute(
        path: '/change-password',
        name: AppRouteNames.changePass,
        pageBuilder: (context, state) =>
            buildPageWithDefaultTransition(child: ChangePassPage()),
      ),
      GoRoute(
        path: '/choose-members',
        name: AppRouteNames.chooseMember,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => LoadedUsersBloc(),
            child: ChooseMembersPage(
              id: extra['id'] as String?,
              type: extra['type'] as LoadType,
              initialSelectedMembers:
                  extra['initialSelected'] as List<UserModel>?,
              onSelectedMembersChanged:
                  extra['onChanged'] as ValueChanged<List<UserModel>>,
              isMultiSelect: extra['isMultiSelect'] as bool,
            ),
          );
        },
      ),
      GoRoute(
        path: '/choose-event',
        name: AppRouteNames.chooseEvent,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => EventDataBloc(),
            child: ChooseEventPage(
              initialSelectedEvent:
                  extra['initialSelected'] as EventModel?,
              onSelectedEventChanged:
                  extra['onChanged'] as ValueChanged<EventModel>,
            ),
          );
        },
      ),
      GoRoute(
        path: '/split', 
        name: AppRouteNames.customSplit,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => LoadedUsersBloc(),
            child: SplitPage( 
              eventId: extra['eventId'] as String? ?? '',
              type: extra['type'] as LoadType,
              initialType: extra['initialType'] as SplitTypeEnum,
              initialSelected:
                  extra['initialSelected'] as List<UserDebt>,
              initialUsers: extra['initialUsers'] as List<UserModel>,
              onChanged: (list) =>
                  (extra['onChanged'] as ValueChanged<List<UserDebt>>)(list),
              amount: extra['amount'] as double,
            ),
          );
        },
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
        if (loc == '/terms-of-use') {
          return null; // cho vào xem điều khoản và đổi mật khẩu
        }
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
