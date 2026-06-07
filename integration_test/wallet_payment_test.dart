// import 'dart:async';

// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/features/home/data/models/bank_account_model.dart';
// import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
// import 'package:Dividex/features/home/presentation/bloc/account/verify_account_bloc.dart';
// import 'package:Dividex/features/home/presentation/pages/add_account_page.dart';
// import 'package:Dividex/features/home/presentation/pages/transfer_confirm_page.dart';
// import 'package:Dividex/features/home/presentation/pages/withdraw_page.dart';
// import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
// import 'package:Dividex/features/recharge/presentation/pages/recharge_page.dart';
// import 'package:Dividex/features/user/data/models/user_model.dart';
// import 'package:Dividex/shared/models/enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockRechargeBloc extends Mock implements RechargeBloc {}

// class MockAccountBloc extends Mock implements AccountBloc {}

// class MockVerifyAccountBloc extends Mock implements VerifyAccountBloc {}

// Future<void> tapVisibleByKey(WidgetTester tester, Key key) async {
//   final finder = find.byKey(key);
//   await tester.ensureVisible(finder);
//   await tester.tap(finder);
//   await tester.pumpAndSettle();
// }

// Future<void> pressButtonByKey(WidgetTester tester, Key key) async {
//   final button = tester.widget<ElevatedButton>(find.byKey(key));
//   button.onPressed?.call();
//   await tester.pumpAndSettle();
// }

// Future<void> selectFirstDialogOption(WidgetTester tester) async {
//   final optionFinder = find.descendant(
//     of: find.byType(Dialog),
//     matching: find.byType(InkWell),
//   );
//   await tester.tap(optionFinder.first);
//   await tester.pumpAndSettle();
// }

// Future<void> openDropdownByKey(WidgetTester tester, Key key) async {
//   await tapVisibleByKey(tester, key);
//   if (find.byType(Dialog).evaluate().isNotEmpty) {
//     return;
//   }

//   final placeholder = find.text('-- --').first;
//   await tester.tap(placeholder);
//   await tester.pumpAndSettle();
// }

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
//   await tester.pumpAndSettle();
// }

// GoRouter buildRechargeRouter({required MockRechargeBloc rechargeBloc}) {
//   return GoRouter(
//     initialLocation: '/recharge-test',
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/recharge-test',
//         builder: (BuildContext context, GoRouterState state) {
//           return BlocProvider<RechargeBloc>.value(
//             value: rechargeBloc,
//             child: const RechargePage(),
//           );
//         },
//       ),
//     ],
//   );
// }

// GoRouter buildAddAccountRouter({
//   required MockAccountBloc accountBloc,
//   required MockVerifyAccountBloc verifyAccountBloc,
// }) {
//   return GoRouter(
//     initialLocation: '/add-account-test',
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/add-account-test',
//         builder: (BuildContext context, GoRouterState state) {
//           return MultiBlocProvider(
//             providers: <BlocProvider<dynamic>>[
//               BlocProvider<AccountBloc>.value(value: accountBloc),
//               BlocProvider<VerifyAccountBloc>.value(value: verifyAccountBloc),
//             ],
//             child: const AddAccountPage(),
//           );
//         },
//       ),
//     ],
//   );
// }

// GoRouter buildWithdrawRouter({
//   required MockAccountBloc accountBloc,
//   required MockRechargeBloc rechargeBloc,
// }) {
//   return GoRouter(
//     initialLocation: '/withdraw-test',
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/withdraw-test',
//         builder: (BuildContext context, GoRouterState state) {
//           return MultiBlocProvider(
//             providers: <BlocProvider<dynamic>>[
//               BlocProvider<AccountBloc>.value(value: accountBloc),
//               BlocProvider<RechargeBloc>.value(value: rechargeBloc),
//             ],
//             child: const WithdrawPage(),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/withdraw-success-test',
//         name: AppRouteNames.withdrawSuccess,
//         builder: (BuildContext context, GoRouterState state) {
//           return const Scaffold(body: Center(child: Text('WITHDRAW_SUCCESS')));
//         },
//       ),
//     ],
//   );
// }

// GoRouter buildTransferConfirmRouter({required MockRechargeBloc rechargeBloc}) {
//   final toUser = UserModel(
//     id: 'user-2',
//     fullName: 'Receiver User',
//     email: 'receiver@test.com',
//   );

//   return GoRouter(
//     initialLocation: '/transfer-confirm-test',
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/transfer-confirm-test',
//         builder: (BuildContext context, GoRouterState state) {
//           return BlocProvider<RechargeBloc>.value(
//             value: rechargeBloc,
//             child: TransferConfirmPage(
//               toUser: toUser,
//               originalAmount: 500000,
//               realAmount: 500000,
//               currency: CurrencyEnum.vnd,
//               description: 'Wallet transfer',
//               groupId: null,
//             ),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/transfer-success-test',
//         name: AppRouteNames.transferSuccess,
//         builder: (BuildContext context, GoRouterState state) {
//           return const Scaffold(body: Center(child: Text('TRANSFER_SUCCESS')));
//         },
//       ),
//     ],
//   );
// }

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('wallet_payment integration tests', () {
//     late MockRechargeBloc mockRechargeBloc;
//     late MockAccountBloc mockAccountBloc;
//     late MockVerifyAccountBloc mockVerifyAccountBloc;

//     setUpAll(() {
//       registerFallbackValue(RechargeEvent());
//       registerFallbackValue(RechargeState());
//       registerFallbackValue(AccountEvent());
//       registerFallbackValue(AccountState(const <BankAccount>[]));
//       registerFallbackValue(VerifyAccountEvent('', ''));
//       registerFallbackValue(VerifyAccountInitialState());
//     });

//     setUp(() {
//       mockRechargeBloc = MockRechargeBloc();
//       mockAccountBloc = MockAccountBloc();
//       mockVerifyAccountBloc = MockVerifyAccountBloc();

//       when(() => mockRechargeBloc.state).thenReturn(RechargeState());
//       when(
//         () => mockRechargeBloc.stream,
//       ).thenAnswer((_) => const Stream<RechargeState>.empty());
//       when(() => mockRechargeBloc.add(any())).thenAnswer((_) {});
//       when(() => mockRechargeBloc.close()).thenAnswer((_) async {});

//       when(
//         () => mockAccountBloc.state,
//       ).thenReturn(AccountState(const <BankAccount>[]));
//       when(
//         () => mockAccountBloc.stream,
//       ).thenAnswer((_) => const Stream<AccountState>.empty());
//       when(() => mockAccountBloc.add(any())).thenAnswer((_) {});
//       when(() => mockAccountBloc.close()).thenAnswer((_) async {});

//       when(
//         () => mockVerifyAccountBloc.state,
//       ).thenReturn(VerifyAccountInitialState());
//       when(
//         () => mockVerifyAccountBloc.stream,
//       ).thenAnswer((_) => const Stream<VerifyAccountState>.empty());
//       when(() => mockVerifyAccountBloc.add(any())).thenAnswer((_) {});
//       when(() => mockVerifyAccountBloc.close()).thenAnswer((_) async {});
//     });

//     testWidgets(
//       'Given recharge page and valid amount, when confirm deposit, then dispatch DepositEvent',
//       (WidgetTester tester) async {
//         // Given
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('1000000'));

//         final router = buildRechargeRouter(rechargeBloc: mockRechargeBloc);
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.enterText(
//           find.byKey(RechargePage.amountInputKey),
//           '500000',
//         );
//         await pressButtonByKey(tester, RechargePage.confirmButtonKey);

//         // Then
//         verify(
//           () => mockRechargeBloc.add(any(that: isA<DepositEvent>())),
//         ).called(1);
//       },
//     );

//     testWidgets(
//       'Given recharge page and empty amount, when confirm deposit, then do not dispatch DepositEvent',
//       (WidgetTester tester) async {
//         // Given
//         when(
//           () => mockRechargeBloc.state,
//         ).thenReturn(GetWalletSuccessState('1000000'));

//         final router = buildRechargeRouter(rechargeBloc: mockRechargeBloc);
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await pressButtonByKey(tester, RechargePage.confirmButtonKey);

//         // Then
//         verifyNever(() => mockRechargeBloc.add(any(that: isA<DepositEvent>())));
//       },
//     );

//     testWidgets(
//       'Given add account page with valid inputs, when submit, then dispatch VerifyAccountEvent and CreateAccountEvent',
//       (WidgetTester tester) async {
//         // Given
//         final verifyController =
//             StreamController<VerifyAccountState>.broadcast();
//         addTearDown(() async => verifyController.close());

//         when(
//           () => mockVerifyAccountBloc.state,
//         ).thenReturn(VerifyAccountInitialState());
//         when(
//           () => mockVerifyAccountBloc.stream,
//         ).thenAnswer((_) => verifyController.stream);
//         when(() => mockVerifyAccountBloc.add(any())).thenAnswer((
//           Invocation inv,
//         ) {
//           final event = inv.positionalArguments.first;
//           if (event is VerifyAccountEvent) {
//             verifyController.add(VerifyAccountSuccessState('NGUYEN VAN A'));
//           }
//         });

//         final router = buildAddAccountRouter(
//           accountBloc: mockAccountBloc,
//           verifyAccountBloc: mockVerifyAccountBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.enterText(
//           find.byKey(AddAccountPage.accountNumberInputKey),
//           '1234567890',
//         );
//         await tester.pumpAndSettle();

//         await openDropdownByKey(tester, AddAccountPage.bankDropdownKey);
//         await tester.tap(find.text('ICB').first);
//         await tester.pumpAndSettle();

//         await pressButtonByKey(tester, AddAccountPage.submitButtonKey);

//         // Then
//         final verifyCaptured = verify(
//           () => mockVerifyAccountBloc.add(captureAny()),
//         ).captured;
//         expect(
//           verifyCaptured.whereType<VerifyAccountEvent>().length,
//           greaterThan(0),
//         );

//         final accountCaptured = verify(
//           () => mockAccountBloc.add(captureAny()),
//         ).captured;
//         expect(accountCaptured.whereType<CreateAccountEvent>().length, 1);
//       },
//     );

//     testWidgets(
//       'Given add account page and missing required fields, when checking submit button, then submit is disabled',
//       (WidgetTester tester) async {
//         // Given
//         final router = buildAddAccountRouter(
//           accountBloc: mockAccountBloc,
//           verifyAccountBloc: mockVerifyAccountBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.pumpAndSettle();

//         // Then
//         final submitButton = tester.widget<ElevatedButton>(
//           find.byKey(AddAccountPage.submitButtonKey),
//         );
//         expect(submitButton.onPressed, isNull);
//       },
//     );

//     testWidgets(
//       'Given withdraw page with account and amount, when submit and backend success, then dispatch CreateWithdrawEvent and navigate success',
//       (WidgetTester tester) async {
//         // Given
//         final account = BankAccount(
//           id: 'acc-1',
//           accountNumber: '1234567890',
//           bankName: 'VCB',
//           currency: CurrencyEnum.vnd,
//         );
//         final rechargeController = StreamController<RechargeState>.broadcast();
//         addTearDown(() async => rechargeController.close());

//         when(
//           () => mockAccountBloc.state,
//         ).thenReturn(AccountState(<BankAccount>[account]));
//         when(() => mockAccountBloc.stream).thenAnswer(
//           (_) =>
//               Stream<AccountState>.value(AccountState(<BankAccount>[account])),
//         );

//         when(() => mockRechargeBloc.state).thenReturn(RechargeState());
//         when(
//           () => mockRechargeBloc.stream,
//         ).thenAnswer((_) => rechargeController.stream);
//         when(() => mockRechargeBloc.add(any())).thenAnswer((Invocation inv) {
//           final event = inv.positionalArguments.first;
//           if (event is CreateWithdrawEvent) {
//             rechargeController.add(RechargeSuccessState());
//           }
//         });

//         final router = buildWithdrawRouter(
//           accountBloc: mockAccountBloc,
//           rechargeBloc: mockRechargeBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await openDropdownByKey(tester, WithdrawPage.accountDropdownKey);
//         await tester.tap(find.text('1234567890').first);
//         await tester.pumpAndSettle();

//         await tester.enterText(
//           find.byKey(WithdrawPage.amountInputKey),
//           '500000',
//         );
//         await tester.pumpAndSettle();

//         await pressButtonByKey(tester, WithdrawPage.submitButtonKey);

//         // Then
//         final captured = verify(
//           () => mockRechargeBloc.add(captureAny()),
//         ).captured;
//         expect(captured.whereType<CreateWithdrawEvent>().length, 1);
//         expect(find.text('WITHDRAW_SUCCESS'), findsOneWidget);
//       },
//     );

//     testWidgets(
//       'Given withdraw page without account, when checking submit button, then submit is disabled',
//       (WidgetTester tester) async {
//         // Given
//         when(
//           () => mockAccountBloc.state,
//         ).thenReturn(AccountState(const <BankAccount>[]));
//         when(() => mockAccountBloc.stream).thenAnswer(
//           (_) =>
//               Stream<AccountState>.value(AccountState(const <BankAccount>[])),
//         );

//         final router = buildWithdrawRouter(
//           accountBloc: mockAccountBloc,
//           rechargeBloc: mockRechargeBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.enterText(
//           find.byKey(WithdrawPage.amountInputKey),
//           '500000',
//         );
//         await tester.pumpAndSettle();

//         // Then
//         final submitButton = tester.widget<ElevatedButton>(
//           find.byKey(WithdrawPage.submitButtonKey),
//         );
//         expect(submitButton.onPressed, isNull);
//       },
//     );

//     testWidgets(
//       'Given transfer confirm with valid pin, when submit and backend success, then dispatch TransferEvent and navigate success',
//       (WidgetTester tester) async {
//         // Given
//         final rechargeController = StreamController<RechargeState>.broadcast();
//         addTearDown(() async => rechargeController.close());

//         when(() => mockRechargeBloc.state).thenReturn(RechargeState());
//         when(
//           () => mockRechargeBloc.stream,
//         ).thenAnswer((_) => rechargeController.stream);
//         when(() => mockRechargeBloc.add(any())).thenAnswer((Invocation inv) {
//           final event = inv.positionalArguments.first;
//           if (event is TransferEvent) {
//             rechargeController.add(RechargeSuccessState());
//           }
//         });

//         final router = buildTransferConfirmRouter(
//           rechargeBloc: mockRechargeBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.enterText(
//           find.byKey(TransferConfirmPage.pinInputKey),
//           '123456',
//         );
//         await tester.pumpAndSettle();

//         await pressButtonByKey(tester, TransferConfirmPage.submitButtonKey);

//         // Then
//         verify(
//           () => mockRechargeBloc.add(any(that: isA<TransferEvent>())),
//         ).called(1);
//         expect(find.text('TRANSFER_SUCCESS'), findsOneWidget);
//       },
//     );

//     testWidgets(
//       'Given transfer confirm with invalid pin, when submit, then do not dispatch TransferEvent',
//       (WidgetTester tester) async {
//         // Given
//         final router = buildTransferConfirmRouter(
//           rechargeBloc: mockRechargeBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.enterText(
//           find.byKey(TransferConfirmPage.pinInputKey),
//           '1234',
//         );
//         await tester.pumpAndSettle();

//         await pressButtonByKey(tester, TransferConfirmPage.submitButtonKey);

//         // Then
//         verifyNever(
//           () => mockRechargeBloc.add(any(that: isA<TransferEvent>())),
//         );
//       },
//     );

//     testWidgets(
//       'Given transfer confirm and backend failure, when submit with valid pin, then stay on confirm page',
//       (WidgetTester tester) async {
//         // Given
//         when(() => mockRechargeBloc.state).thenReturn(RechargeState());
//         when(
//           () => mockRechargeBloc.stream,
//         ).thenAnswer((_) => const Stream<RechargeState>.empty());

//         final router = buildTransferConfirmRouter(
//           rechargeBloc: mockRechargeBloc,
//         );
//         await pumpLocalizedRouter(tester, router);

//         // When
//         await tester.enterText(
//           find.byKey(TransferConfirmPage.pinInputKey),
//           '123456',
//         );
//         await tester.pumpAndSettle();

//         await pressButtonByKey(tester, TransferConfirmPage.submitButtonKey);

//         // Then
//         verify(
//           () => mockRechargeBloc.add(any(that: isA<TransferEvent>())),
//         ).called(1);
//         expect(find.byKey(TransferConfirmPage.submitButtonKey), findsOneWidget);
//         expect(find.text('TRANSFER_SUCCESS'), findsNothing);
//       },
//     );

//     testWidgets(
//       'Given external payment popup is shown, when checking actions, then open bank app confirm action is available',
//       (WidgetTester tester) async {
//         // Given
//         when(() => mockRechargeBloc.state).thenReturn(RechargeState());

//         final binding = tester.binding;
//         await binding.setSurfaceSize(const Size(1200, 2400));
//         addTearDown(() async {
//           await binding.setSurfaceSize(null);
//         });

//         await tester.pumpWidget(
//           MaterialApp(
//             localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
//               AppLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             supportedLocales: AppLocalizations.supportedLocales,
//             home: BlocProvider<RechargeBloc>.value(
//               value: mockRechargeBloc,
//               child: Scaffold(
//                 body: SingleChildScrollView(
//                   child: Builder(
//                     builder: (BuildContext context) {
//                       return TransferPopup(
//                         orderCode: 999,
//                         qrData: 'qr-data',
//                         bottomSheetContext: context,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//         await tester.pumpAndSettle();

//         // When
//         await tester.pumpAndSettle();

//         // Then
//         expect(
//           find.byKey(TransferPopup.openInBankAppButtonKey),
//           findsOneWidget,
//         );
//       },
//     );
//   });
// }
