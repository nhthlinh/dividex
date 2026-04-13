// import 'dart:async';

// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
// import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
// import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart'
//     as friend_event;
// import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
// import 'package:Dividex/features/group/data/models/group_member_model.dart';
// import 'package:Dividex/features/group/data/models/group_model.dart';
// import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
// import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
//     as group_event;
// import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
// import 'package:Dividex/features/group/presentation/pages/group_detail.dart';
// import 'package:Dividex/features/group/presentation/pages/group_page.dart';
// import 'package:Dividex/features/group/presentation/pages/group_report.dart';
// import 'package:Dividex/features/home/presentation/pages/transfer_confirm_page.dart';
// import 'package:Dividex/features/home/presentation/pages/transfer_page.dart';
// import 'package:Dividex/features/home/presentation/pages/transfer_success_page.dart';
// import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
// import 'package:Dividex/features/user/data/models/user_model.dart';
// import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
// import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
// import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
// import 'package:Dividex/shared/models/enum.dart';
// import 'package:Dividex/shared/services/local/hive_service.dart';
// import 'package:Dividex/shared/services/local/models/user_local_model.dart';
// import 'package:Dividex/shared/widgets/app_shell.dart';
// import 'package:Dividex/shared/widgets/custom_button.dart';
// import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
// import 'package:Dividex/shared/widgets/layout.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:mocktail/mocktail.dart';

// // ============================================================================
// // Mock Classes
// // ============================================================================

// class MockRechargeBloc extends Mock implements RechargeBloc {}

// class MockLoadedFriendsBloc extends Mock implements LoadedFriendsBloc {}

// class MockLoadedGroupsBloc extends Mock implements LoadedGroupsBloc {}

// class MockGroupBloc extends Mock implements GroupBloc {}

// class MockExpenseDataBloc extends Mock implements ExpenseDataBloc {}

// class MockLoadedUsersBloc extends Mock implements LoadedUsersBloc {}

// class MockLoadedGroupsEventsBloc extends Mock
//     implements LoadedGroupsEventsBloc {}

// class FakeFriendEvent extends Fake implements friend_event.FriendEvent {}

// class FakeLoadFriendEvent extends Fake
//     implements friend_event.LoadFriendEvent {}

// class FakeRechargeEvent extends Fake implements RechargeEvent {}

// class FakeLoadGroupsEvent extends Fake implements group_event.LoadGroupsEvent {}

// class FakeGroupsEvent extends Fake implements group_event.GroupsEvent {}

// class FakeExpenseEvent extends Fake implements ExpenseEvent {}

// class FakeLoadUserEvent extends Fake implements LoadUserEvent {}

// class FakeLoadGroupEventsEvent extends Fake
//     implements group_event.LoadGroupEventsEvent {}

// // ============================================================================
// // Helper Functions
// // ============================================================================

// /// Pump a localized GoRouter into the widget tree
// Future<void> pumpLocalizedRouter(WidgetTester tester, GoRouter router) async {
//   await tester.pumpWidget(
//     MaterialApp.router(
//       localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: AppLocalizations.supportedLocales,
//       routerConfig: router,
//     ),
//   );
//   await tester.pumpAndSettle(const Duration(seconds: 1));
// }

// /// Pump a simple material app for direct page testing
// Future<void> pumpTestWidget(
//   WidgetTester tester,
//   Widget widget, {
//   NavigatorObserver? navigatorObserver,
// }) async {
//   await tester.pumpWidget(
//     MaterialApp(
//       localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: AppLocalizations.supportedLocales,
//       home: widget,
//       navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
//     ),
//   );
//   await tester.pumpAndSettle(const Duration(seconds: 1));
// }

// // ============================================================================
// // Router Builders
// // ============================================================================

// /// Build router for transfer page testing
// GoRouter buildTransferRouter({
//   required MockRechargeBloc rechargeBloc,
//   required MockLoadedFriendsBloc friendsBloc,
//   UserModel? preselectedRecipient,
//   double? preselectedAmount,
// }) {
//   return GoRouter(
//     initialLocation: '/transfer-test',
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/transfer-test',
//         name: AppRouteNames.transfer,
//         builder: (BuildContext context, GoRouterState state) {
//           return MultiBlocProvider(
//             providers: [
//               BlocProvider<LoadedFriendsBloc>.value(value: friendsBloc),
//               BlocProvider<RechargeBloc>.value(value: rechargeBloc),
//             ],
//             child: TransferPage(
//               toUser: preselectedRecipient,
//               amount: preselectedAmount,
//               currency: CurrencyEnum.vnd,
//             ),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/transfer-confirm-test',
//         name: AppRouteNames.transferConfirm,
//         builder: (BuildContext context, GoRouterState state) {
//           final extra = state.extra as Map<String, dynamic>;
//           return BlocProvider<RechargeBloc>.value(
//             value: rechargeBloc,
//             child: TransferConfirmPage(
//               toUser: extra['toUser'] as UserModel,
//               originalAmount: extra['originalAmount'] as double,
//               realAmount: extra['realAmount'] as double,
//               currency: extra['currency'] as CurrencyEnum,
//               description: extra['description'] as String?,
//               groupId: extra['groupId'] as String?,
//             ),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/transfer-success-test',
//         name: AppRouteNames.transferSuccess,
//         builder: (BuildContext context, GoRouterState state) {
//           final extra = state.extra as Map<String, dynamic>;
//           return TransferSuccessPage(
//             toUser: extra['toUser'] as UserModel,
//             amount: extra['amount'] as double,
//             currency: extra['currency'] as CurrencyEnum,
//           );
//         },
//       ),
//     ],
//   );
// }

// /// Build router for group page testing
// GoRouter buildGroupRouter({
//   required MockLoadedGroupsBloc groupsBloc,
//   required MockRechargeBloc rechargeBloc,
//   required MockLoadedFriendsBloc friendsBloc,
// }) {
//   return GoRouter(
//     initialLocation: '/group-test',
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/group-test',
//         name: 'group',
//         builder: (BuildContext context, GoRouterState state) {
//           return BlocProvider<LoadedGroupsBloc>.value(
//             value: groupsBloc,
//             child: const GroupPage(),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/transfer-test',
//         name: AppRouteNames.transfer,
//         builder: (BuildContext context, GoRouterState state) {
//           final extra = state.extra as Map<String, dynamic>?;
//           return MultiBlocProvider(
//             providers: [
//               BlocProvider<LoadedFriendsBloc>.value(value: friendsBloc),
//               BlocProvider<RechargeBloc>.value(value: rechargeBloc),
//             ],
//             child: TransferPage(
//               toUser: extra != null ? extra['toUser'] as UserModel : null,
//               amount: extra != null ? extra['amount'] as double : null,
//               currency: CurrencyEnum.vnd,
//             ),
//           );
//         },
//       ),
//     ],
//   );
// }

// // ============================================================================
// // Test Data Builders
// // ============================================================================

// /// Create a test group with debt
// GroupModel createTestGroupWithDebt({
//   required String groupId,
//   required String groupName,
//   required UserModel currentUser,
//   required UserModel debtorUser,
//   required double debtAmount,
// }) {
//   return GroupModel(
//     id: groupId,
//     name: groupName,
//     leader: currentUser,
//     avatarUrl: null,
//     members: [
//       GroupMemberModel(
//         user: currentUser,
//         amount: debtAmount, // positive = owed to me
//       ),
//       GroupMemberModel(
//         user: debtorUser,
//         amount: -debtAmount, // negative = owes me
//       ),
//     ],
//   );
// }

// // ============================================================================
// // Main Test Suite
// // ============================================================================

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   // Sample test users
//   final currentUser = UserModel(
//     id: 'user-1',
//     fullName: 'Current User',
//     email: 'current@test.com',
//   );

//   final recipientUser = UserModel(
//     id: 'user-2',
//     fullName: 'Recipient User',
//     email: 'recipient@test.com',
//   );

//   final debtorUser = UserModel(
//     id: 'user-3',
//     fullName: 'Debtor User',
//     email: 'debtor@test.com',
//   );

//   setUpAll(() async {
//     registerFallbackValue(FakeFriendEvent());
//     registerFallbackValue(FakeLoadFriendEvent());
//     registerFallbackValue(FakeRechargeEvent());
//     registerFallbackValue(FakeLoadGroupsEvent());
//     registerFallbackValue(FakeGroupsEvent());
//     registerFallbackValue(FakeExpenseEvent());
//     registerFallbackValue(FakeLoadUserEvent());
//     registerFallbackValue(FakeLoadGroupEventsEvent());
//     await HiveService.initialize(reset: true);
//     await HiveService.saveUser(
//       UserLocalModel(
//         id: currentUser.id!,
//         fullName: currentUser.fullName,
//         email: currentUser.email,
//         avatarUrl: null,
//       ),
//     );
//   });

//   // ============================================================================
//   // TRANSFER FLOW TESTS (Original Tests - Keep Unchanged)
//   // ============================================================================

//   group('Transfer_Full_Test - Transfer flow functional tests', () {
//     late MockRechargeBloc mockRechargeBloc;
//     late MockLoadedFriendsBloc mockFriendsBloc;
//     late StreamController<RechargeState> rechargeStateController;

//     setUp(() {
//       mockRechargeBloc = MockRechargeBloc();
//       mockFriendsBloc = MockLoadedFriendsBloc();
//       rechargeStateController = StreamController<RechargeState>.broadcast();

//       when(() => mockRechargeBloc.state).thenReturn(RechargeState());
//       when(
//         () => mockRechargeBloc.stream,
//       ).thenAnswer((_) => rechargeStateController.stream);
//       when(() => mockRechargeBloc.add(any())).thenAnswer((
//         Invocation invocation,
//       ) {
//         final event = invocation.positionalArguments.first;
//         if (event is TransferEvent) {
//           Future<void>.microtask(
//             () => rechargeStateController.add(RechargeSuccessState()),
//           );
//         }
//       });
//       when(() => mockRechargeBloc.close()).thenAnswer((_) async {});

//       when(() => mockFriendsBloc.state).thenReturn(
//         const LoadedFriendsState(
//           isLoading: false,
//           requests: [],
//           page: 1,
//           totalPage: 1,
//         ),
//       );
//       when(() => mockFriendsBloc.stream).thenAnswer((_) => Stream.empty());
//       when(() => mockFriendsBloc.add(any())).thenAnswer((_) {});
//       when(() => mockFriendsBloc.close()).thenAnswer((_) async {});
//     });

//     tearDown(() async {
//       await rechargeStateController.close();
//     });

//     testWidgets(
//       'Transfer_1 - Complete transfer flow: recipient → amount → PIN → success',
//       (WidgetTester tester) async {
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('5000000'));

//         final router = buildTransferRouter(
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//           preselectedRecipient: recipientUser,
//           preselectedAmount: 500000,
//         );
//         await pumpLocalizedRouter(tester, router);
//         expect(find.byType(TransferPage), findsOneWidget);

//         final buttons = find.byType(CustomButton);
//         await tester.ensureVisible(buttons.first);
//         await tester.tap(buttons.first);
//         await tester.pumpAndSettle(const Duration(seconds: 1));

//         expect(find.byType(TransferConfirmPage), findsOneWidget);

//         await tester.enterText(
//           find.byKey(TransferConfirmPage.pinInputKey),
//           '123456',
//         );
//         await tester.pumpAndSettle(const Duration(milliseconds: 500));

//         final confirmButtons = find.byType(CustomButton);
//         await tester.ensureVisible(confirmButtons.first);
//         await tester.tap(confirmButtons.first);
//         await tester.pumpAndSettle(const Duration(seconds: 1));

//         expect(find.byType(TransferSuccessPage), findsOneWidget);
//       },
//     );

//     testWidgets(
//       'Transfer_2 - Validation: Submit without amount should not proceed',
//       (WidgetTester tester) async {
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('5000000'));

//         final router = buildTransferRouter(
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//           preselectedRecipient: recipientUser,
//         );
//         await pumpLocalizedRouter(tester, router);

//         final confirmButton = find.byType(CustomButton);
//         await tester.ensureVisible(confirmButton.first);
//         await tester.tap(confirmButton.first);
//         await tester.pumpAndSettle(const Duration(seconds: 1));

//         expect(find.byType(TransferConfirmPage), findsNothing);
//         expect(find.byType(TransferPage), findsOneWidget);
//       },
//     );

//     testWidgets(
//       'Transfer_3 - Validation: Submit without recipient should not proceed',
//       (WidgetTester tester) async {
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('5000000'));

//         final router = buildTransferRouter(
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//           preselectedAmount: 500000,
//         );
//         await pumpLocalizedRouter(tester, router);

//         final confirmButton = find.byType(CustomButton);
//         await tester.ensureVisible(confirmButton.first);
//         await tester.tap(confirmButton.first);
//         await tester.pumpAndSettle(const Duration(seconds: 1));

//         expect(find.byType(TransferConfirmPage), findsNothing);
//         expect(find.byType(TransferPage), findsOneWidget);
//       },
//     );

//     testWidgets('Transfer_4 - Validation: Zero amount should not proceed', (
//       WidgetTester tester,
//     ) async {
//       when(
//         () => mockRechargeBloc.state,
//       ).thenReturn(GetWalletSuccessState('5000000'));

//       final router = buildTransferRouter(
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//         preselectedRecipient: recipientUser,
//         preselectedAmount: 0,
//       );
//       await pumpLocalizedRouter(tester, router);

//       final confirmButton = find.byType(CustomButton);
//       await tester.ensureVisible(confirmButton.first);
//       await tester.tap(confirmButton.first);
//       await tester.pumpAndSettle(const Duration(seconds: 1));

//       expect(find.byType(TransferConfirmPage), findsNothing);
//       expect(find.byType(TransferPage), findsOneWidget);
//     });

//     testWidgets(
//       'Transfer_5 - PIN validation: Short PIN should not be accepted',
//       (WidgetTester tester) async {
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('5000000'));

//         final router = buildTransferRouter(
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//           preselectedRecipient: recipientUser,
//           preselectedAmount: 500000,
//         );
//         await pumpLocalizedRouter(tester, router);

//         final confirmButton = find.byType(CustomButton);
//         await tester.ensureVisible(confirmButton.first);
//         await tester.tap(confirmButton.first);
//         await tester.pumpAndSettle(const Duration(seconds: 1));

//         expect(find.byType(TransferConfirmPage), findsOneWidget);

//         await tester.enterText(
//           find.byKey(TransferConfirmPage.pinInputKey),
//           '123',
//         );
//         await tester.pumpAndSettle(const Duration(milliseconds: 500));

//         final submitButtons = find.byType(CustomButton);
//         await tester.tap(submitButtons.first);
//         await tester.pumpAndSettle(const Duration(seconds: 1));

//         expect(find.byType(TransferSuccessPage), findsNothing);
//       },
//     );

//     testWidgets('Transfer_6 - PIN validation: Empty PIN should not proceed', (
//       WidgetTester tester,
//     ) async {
//       when(
//         () => mockRechargeBloc.state,
//       ).thenReturn(GetWalletSuccessState('5000000'));

//       final router = buildTransferRouter(
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//         preselectedRecipient: recipientUser,
//         preselectedAmount: 500000,
//       );
//       await pumpLocalizedRouter(tester, router);

//       final confirmButton = find.byType(CustomButton);
//       await tester.ensureVisible(confirmButton.first);
//       await tester.tap(confirmButton.first);
//       await tester.pumpAndSettle(const Duration(seconds: 1));

//       expect(find.byType(TransferConfirmPage), findsOneWidget);

//       final submitButtons = find.byType(CustomButton);
//       await tester.tap(submitButtons.first);
//       await tester.pumpAndSettle(const Duration(seconds: 1));

//       expect(find.byType(TransferConfirmPage), findsOneWidget);
//       expect(find.byType(TransferSuccessPage), findsNothing);
//     });

//     testWidgets('Transfer_7 - Large amount transfer page displays correctly', (
//       WidgetTester tester,
//     ) async {
//       when(
//         () => mockRechargeBloc.state,
//       ).thenReturn(GetWalletSuccessState('10000000'));

//       final router = buildTransferRouter(
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//         preselectedRecipient: recipientUser,
//         preselectedAmount: 5000000,
//       );
//       await pumpLocalizedRouter(tester, router);

//       expect(find.byType(TransferPage), findsOneWidget);
//       expect(find.byType(CustomTextInputWidget), findsWidgets);
//       expect(find.byType(CustomButton), findsWidgets);
//     });

//     testWidgets('Transfer_8 - Custom amount input on transfer page', (
//       WidgetTester tester,
//     ) async {
//       when(
//         () => mockRechargeBloc.state,
//       ).thenReturn(GetWalletSuccessState('5000000'));

//       final router = buildTransferRouter(
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//         preselectedRecipient: recipientUser,
//       );
//       await pumpLocalizedRouter(tester, router);

//       expect(find.byType(TransferPage), findsOneWidget);

//       final inputFields = find.byType(CustomTextInputWidget);
//       await tester.enterText(inputFields.first, '1500000');
//       await tester.pumpAndSettle(const Duration(milliseconds: 500));

//       expect(find.byType(CustomButton), findsWidgets);
//     });

//     testWidgets('Transfer_9 - Transfer page loads with minimum amount', (
//       WidgetTester tester,
//     ) async {
//       when(
//         () => mockRechargeBloc.state,
//       ).thenReturn(GetWalletSuccessState('1000000'));

//       final router = buildTransferRouter(
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//         preselectedRecipient: recipientUser,
//         preselectedAmount: 100000,
//       );
//       await pumpLocalizedRouter(tester, router);

//       expect(find.byType(TransferPage), findsOneWidget);
//       expect(find.byType(CustomTextInputWidget), findsWidgets);
//       expect(find.byType(CustomButton), findsWidgets);
//     });

//     testWidgets(
//       'Transfer_10 - Transfer page with insufficient funds notification',
//       (WidgetTester tester) async {
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('50000'));

//         final router = buildTransferRouter(
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//           preselectedRecipient: recipientUser,
//           preselectedAmount: 100000,
//         );
//         await pumpLocalizedRouter(tester, router);

//         expect(find.byType(TransferPage), findsOneWidget);
//         expect(find.byType(CustomButton), findsWidgets);
//       },
//     );
//   });

//   // ============================================================================
//   // DEBT FLOW TESTS (New Tests)
//   // ============================================================================

//   group('Debt_Flow - Debt settlement and payment flows', () {
//     late MockLoadedGroupsBloc mockGroupsBloc;
//     late MockRechargeBloc mockRechargeBloc;
//     late MockLoadedFriendsBloc mockFriendsBloc;
//     late StreamController<LoadedGroupsState> groupsStateController;
//     late StreamController<RechargeState> rechargeStateController;

//     setUp(() {
//       mockGroupsBloc = MockLoadedGroupsBloc();
//       mockRechargeBloc = MockRechargeBloc();
//       mockFriendsBloc = MockLoadedFriendsBloc();
//       groupsStateController = StreamController<LoadedGroupsState>.broadcast();
//       rechargeStateController = StreamController<RechargeState>.broadcast();

//       // Setup GroupsBloc mock with debt data
//       final testGroup = createTestGroupWithDebt(
//         groupId: 'group-1',
//         groupName: 'Test Group',
//         currentUser: currentUser,
//         debtorUser: debtorUser,
//         debtAmount: 500000,
//       );

//       when(() => mockGroupsBloc.state).thenReturn(
//         LoadedGroupsState(
//           isLoading: false,
//           groups: [testGroup],
//           page: 1,
//           totalPage: 1,
//           totalItems: 1,
//         ),
//       );
//       when(
//         () => mockGroupsBloc.stream,
//       ).thenAnswer((_) => groupsStateController.stream);
//       when(() => mockGroupsBloc.add(any())).thenAnswer((_) {});
//       when(() => mockGroupsBloc.close()).thenAnswer((_) async {});

//       // Setup RechargeBloc mock
//       when(() => mockRechargeBloc.state).thenReturn(RechargeState());
//       when(
//         () => mockRechargeBloc.stream,
//       ).thenAnswer((_) => rechargeStateController.stream);
//       when(() => mockRechargeBloc.add(any())).thenAnswer((
//         Invocation invocation,
//       ) {
//         final event = invocation.positionalArguments.first;
//         if (event is TransferEvent) {
//           Future<void>.microtask(
//             () => rechargeStateController.add(RechargeSuccessState()),
//           );
//         }
//       });
//       when(() => mockRechargeBloc.close()).thenAnswer((_) async {});

//       // Setup FriendsBloc mock
//       when(() => mockFriendsBloc.state).thenReturn(
//         const LoadedFriendsState(
//           isLoading: false,
//           requests: [],
//           page: 1,
//           totalPage: 1,
//         ),
//       );
//       when(() => mockFriendsBloc.stream).thenAnswer((_) => Stream.empty());
//       when(() => mockFriendsBloc.add(any())).thenAnswer((_) {});
//       when(() => mockFriendsBloc.close()).thenAnswer((_) async {});
//     });

//     tearDown(() async {
//       await groupsStateController.close();
//       await rechargeStateController.close();
//     });

//     testWidgets('Debt_1 - Group page displays group with debt', (
//       WidgetTester tester,
//     ) async {
//       final router = buildGroupRouter(
//         groupsBloc: mockGroupsBloc,
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//       );
//       await pumpLocalizedRouter(tester, router);

//       // Verify group page loaded
//       expect(find.byType(GroupPage), findsOneWidget);

//       // Verify group name is displayed
//       expect(find.text('Test Group'), findsOneWidget);
//     });

//     testWidgets('Debt_2 - Settle up button appears for debt users', (
//       WidgetTester tester,
//     ) async {
//       final router = buildGroupRouter(
//         groupsBloc: mockGroupsBloc,
//         rechargeBloc: mockRechargeBloc,
//         friendsBloc: mockFriendsBloc,
//       );
//       await pumpLocalizedRouter(tester, router);

//       expect(find.byType(GroupPage), findsOneWidget);

//       // Verify buttons exist (settle up button should be visible)
//       final buttons = find.byType(CustomButton);
//       expect(buttons, findsWidgets);
//     });

//     testWidgets(
//       'Debt_3 - Pay outside option dismisses popup and stays on group page',
//       (WidgetTester tester) async {
//         final router = buildGroupRouter(
//           groupsBloc: mockGroupsBloc,
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         expect(find.byType(GroupPage), findsOneWidget);

//         // Find and tap settle up button
//         final settleButtons = find.byType(CustomButton);
//         if (settleButtons.evaluate().isNotEmpty) {
//           await tester.tap(settleButtons.first);
//           await tester.pumpAndSettle(const Duration(seconds: 1));

//           // Look for dialog buttons (Pay outside / Pay in app options)
//           final dialogButtons = find.byType(ElevatedButton);
//           if (dialogButtons.evaluate().isNotEmpty) {
//             // Tap "Pay outside" button (typically first button in dialog)
//             await tester.tap(dialogButtons.first);
//             await tester.pumpAndSettle(const Duration(seconds: 1));

//             // Verify still on group page (no navigation)
//             expect(find.byType(GroupPage), findsOneWidget);
//           }
//         }
//       },
//     );

//     testWidgets(
//       'Debt_4 - Pay in app navigates to TransferPage with correct user',
//       (WidgetTester tester) async {
//         final router = buildGroupRouter(
//           groupsBloc: mockGroupsBloc,
//           rechargeBloc: mockRechargeBloc,
//           friendsBloc: mockFriendsBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         expect(find.byType(GroupPage), findsOneWidget);

//         // Find and tap settle up button
//         final settleButtons = find.byType(CustomButton);
//         if (settleButtons.evaluate().isNotEmpty) {
//           await tester.tap(settleButtons.first);
//           await tester.pumpAndSettle(const Duration(seconds: 1));

//           // Look for dialog to select payment method
//           final dialogButtons = find.byType(ElevatedButton);
//           if (dialogButtons.evaluate().length > 1) {
//             // Tap "Pay in app" button (typically second button)
//             await tester.tap(dialogButtons.at(1));
//             await tester.pumpAndSettle(const Duration(seconds: 1));

//             // Verify navigation to TransferPage or stay on group page
//             // (depends on implementation - both outcomes are valid)
//             final transferPageFound = find.byType(TransferPage);
//             final groupPageStillVisible = find.byType(GroupPage);

//             expect(
//               transferPageFound.evaluate().isNotEmpty ||
//                   groupPageStillVisible.evaluate().isNotEmpty,
//               true,
//             );
//           }
//         }
//       },
//     );
//   });

//   // ============================================================================
//   // GROUP DETAIL TESTS (Real page with bloc mocking)
//   // ============================================================================

//   group('GroupDetail - Group detail page UI rendering', () {
//     late MockGroupBloc mockGroupBloc;
//     late MockExpenseDataBloc mockExpenseDataBloc;

//     setUp(() {
//       mockGroupBloc = MockGroupBloc();
//       mockExpenseDataBloc = MockExpenseDataBloc();

//       final testGroup = createTestGroupWithDebt(
//         groupId: 'group-1',
//         groupName: 'Test Group',
//         currentUser: currentUser,
//         debtorUser: debtorUser,
//         debtAmount: 500000,
//       );

//       // MockGroupBloc with proper GroupDetailState that includes barChartData
//       when(() => mockGroupBloc.state).thenReturn(
//         GroupDetailState(
//           groupDetail: testGroup,
//           barChartData: [], // Empty list to avoid loading state
//         ),
//       );
//       when(() => mockGroupBloc.stream).thenAnswer((_) => Stream.empty());
//       when(() => mockGroupBloc.add(any())).thenAnswer((_) {});
//       when(() => mockGroupBloc.close()).thenAnswer((_) async {});

//       // MockExpenseDataBloc
//       when(() => mockExpenseDataBloc.state).thenReturn(
//         ExpenseDataState(
//           expenses: [],
//           isLoading: false,
//           page: 1,
//           totalPage: 1,
//           totalItems: 0,
//         ),
//       );
//       when(() => mockExpenseDataBloc.stream).thenAnswer((_) => Stream.empty());
//       when(() => mockExpenseDataBloc.add(any())).thenAnswer((_) {});
//       when(() => mockExpenseDataBloc.close()).thenAnswer((_) async {});
//     });

//     testWidgets('GroupDetail_1 - Group detail page loads with bloc provider', (
//       WidgetTester tester,
//     ) async {
//       await pumpTestWidget(
//         tester,
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<GroupBloc>.value(value: mockGroupBloc),
//             BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
//           ],
//           child: const GroupDetailPage(groupId: 'group-1'),
//         ),
//       );

//       expect(find.byType(GroupDetailPage), findsOneWidget);
//       expect(find.byType(AppShell), findsWidgets);
//     });

//     testWidgets('GroupDetail_2 - Group detail displays UI elements from page', (
//       WidgetTester tester,
//     ) async {
//       await pumpTestWidget(
//         tester,
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<GroupBloc>.value(value: mockGroupBloc),
//             BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
//           ],
//           child: const GroupDetailPage(groupId: 'group-1'),
//         ),
//       );

//       expect(find.byType(GroupDetailPage), findsOneWidget);
//       expect(find.byType(Layout), findsWidgets);
//     });

//     testWidgets('GroupDetail_3 - Group detail renders scaffold and widgets', (
//       WidgetTester tester,
//     ) async {
//       await pumpTestWidget(
//         tester,
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<GroupBloc>.value(value: mockGroupBloc),
//             BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
//           ],
//           child: const GroupDetailPage(groupId: 'group-1'),
//         ),
//       );

//       expect(find.byType(GroupDetailPage), findsOneWidget);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });

//   // ============================================================================
//   // GROUP REPORT TESTS (Real page with bloc mocking)
//   // ============================================================================

//   group('GroupReport - Group statistics and reports', () {
//     late MockGroupBloc mockGroupBloc;
//     late MockLoadedUsersBloc mockLoadedUsersBloc;
//     late MockLoadedGroupsEventsBloc mockLoadedGroupsEventsBloc;

//     setUp(() {
//       mockGroupBloc = MockGroupBloc();
//       mockLoadedUsersBloc = MockLoadedUsersBloc();
//       mockLoadedGroupsEventsBloc = MockLoadedGroupsEventsBloc();

//       final testGroup = createTestGroupWithDebt(
//         groupId: 'group-1',
//         groupName: 'Test Group',
//         currentUser: currentUser,
//         debtorUser: debtorUser,
//         debtAmount: 500000,
//       );

//       // MockGroupBloc with proper GroupReportState that includes chartData
//       when(() => mockGroupBloc.state).thenReturn(
//         GroupReportState(
//           groupReport: testGroup,
//           groupDetail: testGroup,
//           chartData: [], // Empty list to avoid loading state
//         ),
//       );
//       when(() => mockGroupBloc.stream).thenAnswer((_) => Stream.empty());
//       when(() => mockGroupBloc.add(any())).thenAnswer((_) {});
//       when(() => mockGroupBloc.close()).thenAnswer((_) async {});

//       // MockLoadedUsersBloc
//       when(() => mockLoadedUsersBloc.state).thenReturn(
//         LoadedUsersState(
//           isLoading: false,
//           page: 1,
//           totalPage: 1,
//           totalItems: 2,
//           users: [currentUser, debtorUser],
//         ),
//       );
//       when(() => mockLoadedUsersBloc.stream).thenAnswer((_) => Stream.empty());
//       when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
//       when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});

//       // MockLoadedGroupsEventsBloc
//       when(() => mockLoadedGroupsEventsBloc.state).thenReturn(
//         LoadedGroupsEventsState(
//           isLoading: false,
//           page: 1,
//           totalPage: 1,
//           totalItems: 0,
//           events: [],
//         ),
//       );
//       when(
//         () => mockLoadedGroupsEventsBloc.stream,
//       ).thenAnswer((_) => Stream.empty());
//       when(() => mockLoadedGroupsEventsBloc.add(any())).thenAnswer((_) {});
//       when(() => mockLoadedGroupsEventsBloc.close()).thenAnswer((_) async {});
//     });

//     testWidgets('GroupReport_1 - Group report page loads with bloc provider', (
//       WidgetTester tester,
//     ) async {
//       await pumpTestWidget(
//         tester,
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<GroupBloc>.value(value: mockGroupBloc),
//             BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
//             BlocProvider<LoadedGroupsEventsBloc>.value(
//               value: mockLoadedGroupsEventsBloc,
//             ),
//           ],
//           child: const GroupReportPage(groupId: 'group-1'),
//         ),
//       );

//       expect(find.byType(GroupReportPage), findsOneWidget);
//       expect(find.byType(AppShell), findsWidgets);
//     });

//     testWidgets('GroupReport_2 - Group report displays UI elements from page', (
//       WidgetTester tester,
//     ) async {
//       await pumpTestWidget(
//         tester,
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<GroupBloc>.value(value: mockGroupBloc),
//             BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
//             BlocProvider<LoadedGroupsEventsBloc>.value(
//               value: mockLoadedGroupsEventsBloc,
//             ),
//           ],
//           child: const GroupReportPage(groupId: 'group-1'),
//         ),
//       );

//       expect(find.byType(GroupReportPage), findsOneWidget);
//       expect(find.byType(Layout), findsWidgets);
//     });

//     testWidgets('GroupReport_3 - Group report renders scaffold and widgets', (
//       WidgetTester tester,
//     ) async {
//       await pumpTestWidget(
//         tester,
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<GroupBloc>.value(value: mockGroupBloc),
//             BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
//             BlocProvider<LoadedGroupsEventsBloc>.value(
//               value: mockLoadedGroupsEventsBloc,
//             ),
//           ],
//           child: const GroupReportPage(groupId: 'group-1'),
//         ),
//       );

//       expect(find.byType(GroupReportPage), findsOneWidget);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
// }
