import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart'
    as friend_event;
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/home/presentation/pages/transfer_confirm_page.dart';
import 'package:Dividex/features/home/presentation/pages/transfer_page.dart';
import 'package:Dividex/features/home/presentation/pages/transfer_success_page.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

// ============================================================================
// Mock Classes
// ============================================================================

class MockRechargeBloc extends Mock implements RechargeBloc {}

class MockLoadedFriendsBloc extends Mock implements LoadedFriendsBloc {}

class FakeFriendEvent extends Fake implements friend_event.FriendEvent {}

class FakeLoadFriendEvent extends Fake
    implements friend_event.LoadFriendEvent {}

class FakeRechargeEvent extends Fake implements RechargeEvent {}

// ============================================================================
// Helper Functions
// ============================================================================

/// Pump a localized GoRouter into the widget tree
Future<void> pumpLocalizedRouter(WidgetTester tester, GoRouter router) async {
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
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

// ============================================================================
// Router Builders
// ============================================================================

/// Build router for transfer page testing
GoRouter buildTransferRouter({
  required MockRechargeBloc rechargeBloc,
  required MockLoadedFriendsBloc friendsBloc,
  UserModel? preselectedRecipient,
  double? preselectedAmount,
}) {
  return GoRouter(
    initialLocation: '/transfer-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/transfer-test',
        name: AppRouteNames.transfer,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<LoadedFriendsBloc>.value(value: friendsBloc),
              BlocProvider<RechargeBloc>.value(value: rechargeBloc),
            ],
            child: TransferPage(
              toUser: preselectedRecipient,
              amount: preselectedAmount,
              currency: CurrencyEnum.vnd,
            ),
          );
        },
      ),
      GoRoute(
        path: '/transfer-confirm-test',
        name: AppRouteNames.transferConfirm,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider<RechargeBloc>.value(
            value: rechargeBloc,
            child: TransferConfirmPage(
              toUser: extra['toUser'] as UserModel,
              originalAmount: extra['originalAmount'] as double,
              realAmount: extra['realAmount'] as double,
              currency: extra['currency'] as CurrencyEnum,
              description: extra['description'] as String?,
              groupId: extra['groupId'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: '/transfer-success-test',
        name: AppRouteNames.transferSuccess,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          return TransferSuccessPage(
            toUser: extra['toUser'] as UserModel,
            amount: extra['amount'] as double,
            currency: extra['currency'] as CurrencyEnum,
          );
        },
      ),
    ],
  );
}

// ============================================================================
// Main Test Suite
// ============================================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Sample test users
  final currentUser = UserModel(
    id: 'user-1',
    fullName: 'Current User',
    email: 'current@test.com',
  );

  final recipientUser = UserModel(
    id: 'user-2',
    fullName: 'Recipient User',
    email: 'recipient@test.com',
  );

  setUpAll(() async {
    registerFallbackValue(FakeFriendEvent());
    registerFallbackValue(FakeLoadFriendEvent());
    registerFallbackValue(FakeRechargeEvent());
    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: currentUser.id!,
        fullName: currentUser.fullName,
        email: currentUser.email,
        avatarUrl: null,
      ),
    );
  });

  group('Transfer_Full_Test - Transfer flow functional tests', () {
    late MockRechargeBloc mockRechargeBloc;
    late MockLoadedFriendsBloc mockFriendsBloc;
    late StreamController<RechargeState> rechargeStateController;

    setUp(() {
      mockRechargeBloc = MockRechargeBloc();
      mockFriendsBloc = MockLoadedFriendsBloc();
      rechargeStateController = StreamController<RechargeState>.broadcast();

      // Setup RechargeBloc mock
      when(() => mockRechargeBloc.state).thenReturn(RechargeState());
      when(
        () => mockRechargeBloc.stream,
      ).thenAnswer((_) => rechargeStateController.stream);
      when(() => mockRechargeBloc.add(any())).thenAnswer((
        Invocation invocation,
      ) {
        final event = invocation.positionalArguments.first;
        if (event is TransferEvent) {
          Future<void>.microtask(
            () => rechargeStateController.add(RechargeSuccessState()),
          );
        }
      });
      when(() => mockRechargeBloc.close()).thenAnswer((_) async {});

      // Setup LoadedFriendsBloc mock with NOT loading state
      when(() => mockFriendsBloc.state).thenReturn(
        const LoadedFriendsState(
          isLoading: false,
          requests: [],
          page: 1,
          totalPage: 1,
        ),
      );
      when(() => mockFriendsBloc.stream).thenAnswer((_) => Stream.empty());
      when(() => mockFriendsBloc.add(any())).thenAnswer((_) {});
      when(() => mockFriendsBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await rechargeStateController.close();
    });

    testWidgets(
      'Transfer_1 - Complete transfer flow: recipient → amount → PIN → success',
      (WidgetTester tester) async {
        when(
          () => mockRechargeBloc.state,
        ).thenReturn(GetWalletSuccessState('5000000'));

        final router = buildTransferRouter(
          rechargeBloc: mockRechargeBloc,
          friendsBloc: mockFriendsBloc,
          preselectedRecipient: recipientUser,
          preselectedAmount: 500000,
        );
        await pumpLocalizedRouter(tester, router);
        expect(find.byType(TransferPage), findsOneWidget);

        final buttons = find.byType(CustomButton);
        await tester.ensureVisible(buttons.first);
        await tester.tap(buttons.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(TransferConfirmPage), findsOneWidget);

        await tester.enterText(
          find.byKey(TransferConfirmPage.pinInputKey),
          '123456',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        final confirmButtons = find.byType(CustomButton);
        await tester.ensureVisible(confirmButtons.first);
        await tester.tap(confirmButtons.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(TransferSuccessPage), findsOneWidget);
      },
    );

    testWidgets(
      'Transfer_2 - Validation: Submit without amount should not proceed',
      (WidgetTester tester) async {
        when(
          () => mockRechargeBloc.state,
        ).thenReturn(GetWalletSuccessState('5000000'));

        final router = buildTransferRouter(
          rechargeBloc: mockRechargeBloc,
          friendsBloc: mockFriendsBloc,
          preselectedRecipient: recipientUser,
        );
        await pumpLocalizedRouter(tester, router);

        final confirmButton = find.byType(CustomButton);
        await tester.ensureVisible(confirmButton.first);
        await tester.tap(confirmButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(TransferConfirmPage), findsNothing);
        expect(find.byType(TransferPage), findsOneWidget);
      },
    );

    testWidgets(
      'Transfer_3 - Validation: Submit without recipient should not proceed',
      (WidgetTester tester) async {
        when(
          () => mockRechargeBloc.state,
        ).thenReturn(GetWalletSuccessState('5000000'));

        final router = buildTransferRouter(
          rechargeBloc: mockRechargeBloc,
          friendsBloc: mockFriendsBloc,
          preselectedAmount: 500000,
        );
        await pumpLocalizedRouter(tester, router);

        final confirmButton = find.byType(CustomButton);
        await tester.ensureVisible(confirmButton.first);
        await tester.tap(confirmButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(TransferConfirmPage), findsNothing);
        expect(find.byType(TransferPage), findsOneWidget);
      },
    );

    testWidgets('Transfer_4 - Validation: Zero amount should not proceed', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRechargeBloc.state,
      ).thenReturn(GetWalletSuccessState('5000000'));

      final router = buildTransferRouter(
        rechargeBloc: mockRechargeBloc,
        friendsBloc: mockFriendsBloc,
        preselectedRecipient: recipientUser,
        preselectedAmount: 0,
      );
      await pumpLocalizedRouter(tester, router);

      final confirmButton = find.byType(CustomButton);
      await tester.ensureVisible(confirmButton.first);
      await tester.tap(confirmButton.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(TransferConfirmPage), findsNothing);
      expect(find.byType(TransferPage), findsOneWidget);
    });

    testWidgets(
      'Transfer_5 - PIN validation: Short PIN should not be accepted',
      (WidgetTester tester) async {
        when(
          () => mockRechargeBloc.state,
        ).thenReturn(GetWalletSuccessState('5000000'));

        final router = buildTransferRouter(
          rechargeBloc: mockRechargeBloc,
          friendsBloc: mockFriendsBloc,
          preselectedRecipient: recipientUser,
          preselectedAmount: 500000,
        );
        await pumpLocalizedRouter(tester, router);

        final confirmButton = find.byType(CustomButton);
        await tester.ensureVisible(confirmButton.first);
        await tester.tap(confirmButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(TransferConfirmPage), findsOneWidget);

        await tester.enterText(
          find.byKey(TransferConfirmPage.pinInputKey),
          '123',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        final submitButtons = find.byType(CustomButton);
        await tester.tap(submitButtons.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(TransferSuccessPage), findsNothing);
      },
    );

    testWidgets('Transfer_6 - PIN validation: Empty PIN should not proceed', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRechargeBloc.state,
      ).thenReturn(GetWalletSuccessState('5000000'));

      final router = buildTransferRouter(
        rechargeBloc: mockRechargeBloc,
        friendsBloc: mockFriendsBloc,
        preselectedRecipient: recipientUser,
        preselectedAmount: 500000,
      );
      await pumpLocalizedRouter(tester, router);

      final confirmButton = find.byType(CustomButton);
      await tester.ensureVisible(confirmButton.first);
      await tester.tap(confirmButton.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(TransferConfirmPage), findsOneWidget);

      final submitButtons = find.byType(CustomButton);
      await tester.tap(submitButtons.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(TransferConfirmPage), findsOneWidget);
      expect(find.byType(TransferSuccessPage), findsNothing);
    });

    testWidgets('Transfer_7 - Large amount transfer page displays correctly', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRechargeBloc.state,
      ).thenReturn(GetWalletSuccessState('10000000'));

      final router = buildTransferRouter(
        rechargeBloc: mockRechargeBloc,
        friendsBloc: mockFriendsBloc,
        preselectedRecipient: recipientUser,
        preselectedAmount: 5000000,
      );
      await pumpLocalizedRouter(tester, router);

      expect(find.byType(TransferPage), findsOneWidget);
      expect(find.byType(CustomTextInputWidget), findsWidgets);
      expect(find.byType(CustomButton), findsWidgets);
    });

    testWidgets('Transfer_8 - Custom amount input on transfer page', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRechargeBloc.state,
      ).thenReturn(GetWalletSuccessState('5000000'));

      final router = buildTransferRouter(
        rechargeBloc: mockRechargeBloc,
        friendsBloc: mockFriendsBloc,
        preselectedRecipient: recipientUser,
      );
      await pumpLocalizedRouter(tester, router);

      expect(find.byType(TransferPage), findsOneWidget);

      final inputFields = find.byType(CustomTextInputWidget);
      await tester.enterText(inputFields.first, '1500000');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(CustomButton), findsWidgets);
    });

    testWidgets('Transfer_9 - Transfer page loads with minimum amount', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRechargeBloc.state,
      ).thenReturn(GetWalletSuccessState('1000000'));

      final router = buildTransferRouter(
        rechargeBloc: mockRechargeBloc,
        friendsBloc: mockFriendsBloc,
        preselectedRecipient: recipientUser,
        preselectedAmount: 100000,
      );
      await pumpLocalizedRouter(tester, router);

      expect(find.byType(TransferPage), findsOneWidget);
      expect(find.byType(CustomTextInputWidget), findsWidgets);
      expect(find.byType(CustomButton), findsWidgets);
    });

    testWidgets(
      'Transfer_10 - Transfer page with insufficient funds notification',
      (WidgetTester tester) async {
        when(
          () => mockRechargeBloc.state,
        ).thenReturn(GetWalletSuccessState('50000'));

        final router = buildTransferRouter(
          rechargeBloc: mockRechargeBloc,
          friendsBloc: mockFriendsBloc,
          preselectedRecipient: recipientUser,
          preselectedAmount: 100000,
        );
        await pumpLocalizedRouter(tester, router);

        expect(find.byType(TransferPage), findsOneWidget);
        expect(find.byType(CustomButton), findsWidgets);
      },
    );
  });
}
