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
import 'package:Dividex/features/event_expense/presentation/pages/all_expense_report.dart';
import 'package:Dividex/features/event_expense/presentation/pages/choose_event_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/edit_expense_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/event_report.dart';
import 'package:Dividex/features/event_expense/presentation/pages/event_setting.dart';
import 'package:Dividex/features/event_expense/presentation/pages/expense_detail_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/split_page.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_request_bloc_and_event.dart'
    as request_bloc;
import 'package:Dividex/features/friend/presentation/pages/friend_profile_page.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/pages/add_group_page.dart';
import 'package:Dividex/features/group/presentation/pages/group_detail.dart';
import 'package:Dividex/features/group/presentation/pages/group_page.dart';
import 'package:Dividex/features/group/presentation/pages/group_report.dart';
import 'package:Dividex/features/group/presentation/pages/group_setting.dart';
import 'package:Dividex/features/group/presentation/pages/hard_delete_expense.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/features/home/presentation/pages/account_detail_page.dart';
import 'package:Dividex/features/home/presentation/pages/account_page.dart';
import 'package:Dividex/features/home/presentation/pages/add_account_page.dart';
import 'package:Dividex/features/home/presentation/pages/profile_page.dart';
import 'package:Dividex/features/home/presentation/pages/transfer_confirm_page.dart';
import 'package:Dividex/features/home/presentation/pages/transfer_page.dart';
import 'package:Dividex/features/home/presentation/pages/transfer_success_page.dart';
import 'package:Dividex/features/home/presentation/pages/withdraw_page.dart';
import 'package:Dividex/features/home/presentation/pages/withdraw_success_page.dart';
import 'package:Dividex/features/home/presentation/recharge_report.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/recharge/presentation/pages/recharge_page.dart';
import 'package:Dividex/features/search/presentation/bloc/search_transaction_bloc.dart';
import 'package:Dividex/features/search/presentation/bloc/search_users_bloc.dart'
    as search_bloc;
import 'package:Dividex/features/friend/presentation/pages/friend_page.dart';
import 'package:Dividex/features/search/presentation/pages/search_page.dart';
import 'package:Dividex/features/search/presentation/pages/search_transaction_page.dart';
import 'package:Dividex/features/search/presentation/pages/search_user_page.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
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

  static const String profile = 'profile';

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

  static const String group = 'group';
  static const String groupDetail = 'group-detail';
  static const String groupReport = 'group-report';
  static const String groupSetting = 'group-setting';
  static const String eventReport = 'event-report';
  static const String listExpenseDeleted = 'list-expense-delete';
  static const String eventSetting = 'event-setting';
  static const String expenseDetail = 'expense-detail';
  static const String expenseEdit = 'expense-edit';

  static const String account = 'account';
  static const String addAccount = 'add-account';
  static const String accountDetail = 'accountDetail';

  static const String transfer = 'transfer';
  static const String transferConfirm = 'transfer-confirm';
  static const String transferSuccess = 'transfer-success';

  static const String withdraw = 'withdraw';
  static const String withdrawSuccess = 'withdraw-success';

  static const String recharge = 'recharge';

  static const String friendProfile = 'friend-profile';
  static const String walletReport = 'wallet-report';
  static const String transactionReport = 'transaction-report';
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
          return buildPageWithDefaultTransition(child: SplashPage());
        },
      ),
      GoRoute(
        path: '/splash-2',
        name: AppRouteNames.splash2,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: SplashPage2());
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
            buildPageWithDefaultTransition(child: LoginPage()),
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
          return buildPageWithDefaultTransition(child: HomePage());
        },
        routes: [
          GoRoute(
            path: '/expense/:id',
            name: AppRouteNames.expenseDetail,
            pageBuilder: (context, state) {
              final expenseId = state.pathParameters['id']!;
              return buildPageWithDefaultTransition(
                child: BlocProvider<ExpenseBloc>(
                  create: (context) => ExpenseBloc(),
                  child: ExpenseDetail(expenseId: expenseId),
                ),
              );
            },
          ),
          GoRoute(
            path: '/expense/edit/:id',
            name: AppRouteNames.expenseEdit,
            pageBuilder: (context, state) {
              final expenseId = state.pathParameters['id']!;
              return buildPageWithDefaultTransition(
                child: BlocProvider<ExpenseBloc>(
                  create: (context) => ExpenseBloc(),
                  child: EditExpensePage(expenseId: expenseId),
                ),
              );
            },
          ),

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
                child: FriendPage(),
              ),
            ),
          ),
          GoRoute(
            path: 'group',
            name: AppRouteNames.group,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                child: BlocProvider<LoadedGroupsBloc>(
                  create: (context) => LoadedGroupsBloc(),
                  child: GroupPage(),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'report/:groupId',
                name: AppRouteNames.groupReport,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final groupId = state.pathParameters['groupId']!;

                  return buildPageWithDefaultTransition(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<GroupBloc>(
                          create: (context) => GroupBloc(),
                        ),
                        BlocProvider<LoadedGroupsEventsBloc>(
                          create: (context) => LoadedGroupsEventsBloc(),
                        ),
                        BlocProvider<LoadedUsersBloc>(
                          create: (context) => LoadedUsersBloc(),
                        ),
                      ],
                      child: GroupReportPage(
                        groupId: groupId,
                      ),
                    ),
                  );
                },
              ),

              GoRoute(
                path: 'setting/:groupId',
                name: AppRouteNames.groupSetting,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final groupId = state.pathParameters['groupId']!;
                  final extra = state.extra as Map<String, dynamic>?;
                  final groupName = extra?['groupName'] as String?;
                  final groupAvatar = extra?['groupAvatar'] as ImageModel?;
                  final leaderId = extra?['leaderId'] as String?;

                  return buildPageWithDefaultTransition(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<LoadedUsersBloc>(
                          create: (context) => LoadedUsersBloc(),
                        ),
                        BlocProvider<GroupBloc>(
                          create: (context) => GroupBloc(),
                        ),
                      ],
                      child: GroupSettingPage(
                        groupId: groupId,
                        groupLeaderId: leaderId ?? '',
                        groupName: groupName ?? '',
                        groupAvatarUrl: groupAvatar,
                      ),
                    ),
                  );
                },
              ),

              GoRoute(
                path: ':groupId',
                name: AppRouteNames.groupDetail,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final groupId = state.pathParameters['groupId']!;
                  return buildPageWithDefaultTransition(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<ExpenseDataBloc>(
                          create: (context) => ExpenseDataBloc(),
                        ),
                        BlocProvider<GroupBloc>(
                          create: (context) => GroupBloc(),
                        ),
                      ],
                      child: GroupDetailPage(groupId: groupId),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'setting/:eventId',
                    name: AppRouteNames.eventSetting,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final eventId = state.pathParameters['eventId']!;
                      final groupId = state.pathParameters['groupId'];

                      final extra = state.extra as Map<String, dynamic>?;
                      final eventName = extra?['eventName'] as String?;
                      return buildPageWithDefaultTransition(
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<LoadedUsersBloc>(
                              create: (context) => LoadedUsersBloc(),
                            ),
                            BlocProvider<EventBloc>(
                              create: (context) => EventBloc(),
                            ),
                          ],
                          child: EventSettingPage(
                            eventId: eventId,
                            groupId: groupId ?? '',
                            eventName: eventName ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'list-expense-deleted',
                    name: AppRouteNames.listExpenseDeleted,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final groupId = state.pathParameters['groupId'];
                      final extra = state.extra as Map<String, dynamic>?;
                      final groupName = extra?['groupName'] as String?;
                      final groupAvatar = extra?['groupAvatar'] as String?;
                      return buildPageWithDefaultTransition(
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<ExpenseDataBloc>(
                              create: (context) => ExpenseDataBloc(),
                            ),
                            BlocProvider<ExpenseBloc>(
                              create: (context) => ExpenseBloc(),
                            ),
                          ],
                          child: HardDeleteExpensePage(
                            groupId: groupId ?? '',
                            groupName: groupName ?? '',
                            groupAvatarUrl: groupAvatar ?? '',
                          ),
                        ),
                      );
                    },
                  ),

                  GoRoute(
                    path: ':eventId',
                    name: AppRouteNames.eventReport,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final eventId = state.pathParameters['eventId']!;
                      final groupId = state.pathParameters['groupId'];
                      final extra = state.extra as Map<String, dynamic>?;
                      final eventName = extra?['eventName'] as String?;
                      final groupName = extra?['groupName'] as String?;
                      final groupAvatar = extra?['groupAvatar'] as String?;
                      return buildPageWithDefaultTransition(
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<ExpenseDataBloc>(
                              create: (context) => ExpenseDataBloc(),
                            ),
                            BlocProvider<EventBloc>(
                              create: (context) => EventBloc(),
                            ),
                          ],
                          child: EventReportPage(
                            eventId: eventId,
                            groupId: groupId ?? '',
                            eventName: eventName ?? '',
                            groupName: groupName ?? '',
                            groupAvatarUrl: groupAvatar ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: 'account',
            name: AppRouteNames.account,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                child: BlocProvider(
                  create: (context) => AccountBloc(),
                  child: AccountPage(),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'add-account',
                name: AppRouteNames.addAccount,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return buildPageWithDefaultTransition(
                    child: BlocProvider<AccountBloc>(
                      create: (context) => AccountBloc(),
                      child: AddAccountPage(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'account-detail/:id',
                name: AppRouteNames.accountDetail,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final id = state.pathParameters['id']!;
                  final account = state.extra as BankAccount?;
                  return buildPageWithDefaultTransition(
                    child: BlocProvider<AccountBloc>(
                      create: (context) => AccountBloc(),
                      child: AccountDetailPage(id: id, account: account),
                    ),
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: 'transfer',
            name: AppRouteNames.transfer,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final extra = state.extra as Map<String, dynamic>?;
              final receiver = extra?['toUser'] as UserModel?;
              final amount = extra?['amount'] as double?;
              final currency = extra?['currency'] as CurrencyEnum?;
              final groupId = extra?['groupId'] as String?;
              return buildPageWithDefaultTransition(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<LoadedFriendsBloc>(
                      create: (context) => LoadedFriendsBloc(),
                    ),
                    BlocProvider<RechargeBloc>(
                      create: (context) => RechargeBloc(),
                    ),
                  ],
                  child: TransferPage(
                    toUser: receiver,
                    amount: amount,
                    currency: currency,
                    groupId: groupId,
                  ),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'confirm',
                name: AppRouteNames.transferConfirm,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final toUser = extra?['toUser'] as UserModel;
                  final originalAmount = extra?['originalAmount'] as double;
                  final realAmount = extra?['realAmount'] as double;
                  final currency = extra?['currency'] as CurrencyEnum?;
                  final description = extra?['description'] as String?;
                  final groupId = extra?['groupId'] as String?;

                  return buildPageWithDefaultTransition(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<RechargeBloc>(
                          create: (context) => RechargeBloc(),
                        ),
                        BlocProvider<UserBloc>(create: (context) => UserBloc()),
                      ],
                      child: TransferConfirmPage(
                        toUser: toUser,
                        originalAmount: originalAmount,
                        realAmount: realAmount,
                        currency: currency ?? CurrencyEnum.vnd,
                        description: description,
                        groupId: groupId,
                      ),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'transfer-success',
                name: AppRouteNames.transferSuccess,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final toUser = extra?['toUser'] as UserModel;
                  final amount = extra?['amount'] as double;
                  final currency = extra?['currency'] as CurrencyEnum?;
                  return buildPageWithDefaultTransition(
                    child: TransferSuccessPage(
                      toUser: toUser,
                      amount: amount,
                      currency: currency ?? CurrencyEnum.vnd,
                    ),
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: 'withdraw',
            name: AppRouteNames.withdraw,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<RechargeBloc>(
                      create: (context) => RechargeBloc(),
                    ),
                    BlocProvider<AccountBloc>(
                      create: (context) => AccountBloc(),
                    ),
                  ],
                  child: WithdrawPage(),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'withdraw-success',
                name: AppRouteNames.withdrawSuccess,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final toAccount = extra?['toAccount'] as BankAccount;
                  final amount = extra?['amount'] as double;

                  return buildPageWithDefaultTransition(
                    child: WithdrawSuccessPage(
                      toAccount: toAccount,
                      amount: amount,
                    ),
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: 'recharge',
            name: AppRouteNames.recharge,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                child: BlocProvider<RechargeBloc>(
                  create: (context) => RechargeBloc(),
                  child: RechargePage(),
                ),
              );
            },
          ),

           GoRoute(
            path: 'transaction-report',
            name: AppRouteNames.transactionReport,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<ExpenseDataBloc>(
                      create: (context) => ExpenseDataBloc(),
                    ),
                    BlocProvider<ExpenseBloc>(
                      create: (context) => ExpenseBloc(),
                    ),
                  ],
                  child: AllExpenseReportPage(),
                ),
              );
            },
          ),

          GoRoute(
            path: 'wallet-report',
            name: AppRouteNames.walletReport,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<RechargeBloc>(
                      create: (context) => RechargeBloc(),
                    ),
                    BlocProvider<LoadedHistoryBloc>(
                      create: (context) => LoadedHistoryBloc(),
                    ),
                  ],
                  child: RechargeReport(),
                ),
              );
            },
          ),
        
        ],
      ),
      GoRoute(
        path: '/search',
        name: AppRouteNames.search,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(child: SearchPage());
        },
        routes: [
          GoRoute(
            path: 'search-user',
            name: AppRouteNames.searchUser,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: BlocProvider(
                create: (context) => search_bloc.SearchUsersBloc(),
                child: SearchUserPage(),
              ),
            ),
          ),
          GoRoute(
            path: 'search-transaction',
            name: AppRouteNames.searchTransaction,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: BlocProvider(
                create: (context) => SearchTransactionBloc(),
                child: SearchTransactionPage(),
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
          return buildPageWithDefaultTransition(
            child: BlocProvider(
              create: (context) => UserBloc(),
              child: SettingPage(),
            ),
          );
        },
      ),

      GoRoute(
        path: '/profile',
        name: AppRouteNames.profile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            child: BlocProvider(
              create: (context) => UserBloc()..add(GetMeEvent()),
              child: ProfilePage(),
            ),
          );
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
          return buildPageWithDefaultTransition(child: TermsOfServicePage());
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
              isCanChooseMyself: extra['isCanChooseMyself'] as bool? ?? false,
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
              initialSelectedEvent: extra['initialSelected'] as EventModel?,
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
              initialSelected: extra['initialSelected'] as List<UserDebt>,
              initialUsers: extra['initialUsers'] as List<UserModel>,
              onChanged: (list) =>
                  (extra['onChanged'] as ValueChanged<List<UserDebt>>)(list),
              amount: extra['amount'] as double,
            ),
          );
        },
      ),
      GoRoute(
        path: '/friend-profile/:id',
        name: AppRouteNames.friendProfile,
        builder: (context, state) {
          final friendId = state.pathParameters['id']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider<FriendBloc>(create: (context) => FriendBloc()),
              BlocProvider<LoadFriendDeptBloc>(
                create: (context) => LoadFriendDeptBloc(),
              ),
              BlocProvider<LoadedUsersBloc>(
                create: (context) => LoadedUsersBloc(),
              ),
            ],
            child: FriendProfilePage(friendId: friendId),
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
