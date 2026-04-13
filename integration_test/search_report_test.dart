import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/event_expense/presentation/pages/all_expense_report.dart';
import 'package:Dividex/features/home/presentation/recharge_report.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/search/presentation/pages/search_transaction_page.dart';
import 'package:Dividex/features/search/presentation/bloc/search_transaction_bloc.dart'
    as search_bloc;
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

// ============================================================================
// Mock Classes
// ============================================================================

class MockExpenseDataBloc extends Mock implements ExpenseDataBloc {}

class MockExpenseBloc extends Mock implements ExpenseBloc {}

class MockLoadedHistoryBloc extends Mock implements LoadedHistoryBloc {}

class MockRechargeBloc extends Mock implements RechargeBloc {}

class MockSearchTransactionBloc extends Mock
    implements search_bloc.SearchTransactionBloc {}

class FakeSearchTransactionEvent extends Fake
    implements search_bloc.SearchTransactionEvent {}

class FakeExpenseEvent extends Fake implements InitialEvent {}

class FakeGetHistoryEvent extends Fake implements GetHistoryEvent {}

class FakeRechargeEvent extends Fake implements RechargeEvent {}

// ============================================================================
// Test Data Builders
// ============================================================================

ExpenseModel createTestExpense({
  required String id,
  required String name,
  required double totalAmount,
  required String category,
  required String event,
  DateTime? expenseDate,
}) {
  return ExpenseModel(
    id: id,
    name: name,
    totalAmount: totalAmount,
    category: category,
    event: event,
    expenseDate: expenseDate ?? DateTime.now(),
    currency: CurrencyEnum.vnd,
    paidBy: 'user-1',
  );
}

ExternalTransactionModel createTestExternalTransaction({
  required String id,
  required String code,
  required double amount,
  required ExternalTransactionType type,
}) {
  return ExternalTransactionModel(
    id: id,
    code: code,
    amount: amount,
    type: type,
    date: DateTime.now(),
    currency: CurrencyEnum.vnd,
  );
}

InternalTransactionModel createTestInternalTransaction({
  required String uid,
  required String code,
  required double amount,
  required String fromUser,
  required String toUser,
}) {
  return InternalTransactionModel(
    uid: uid,
    code: code,
    amount: amount,
    fromUser: fromUser,
    toUser: toUser,
    date: DateTime.now(),
    group: 'Test Group',
    description: 'Transfer description',
  );
}

// ============================================================================
// Helper Functions
// ============================================================================

Future<void> pumpReportWidget(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: widget,
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

// ============================================================================
// Main Test Suite
// ============================================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(FakeExpenseEvent());
    registerFallbackValue(FakeGetHistoryEvent());
    registerFallbackValue(FakeRechargeEvent());
    registerFallbackValue(FakeSearchTransactionEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'current-user-1',
        fullName: 'Test User',
        email: 'test@example.com',
        avatarUrl: null,
      ),
    );
  });

  group('search_report - AllExpenseReportPage Tests', () {
    late MockExpenseDataBloc mockExpenseDataBloc;
    late MockExpenseBloc mockExpenseBloc;

    setUp(() {
      mockExpenseDataBloc = MockExpenseDataBloc();
      mockExpenseBloc = MockExpenseBloc();

      // Simple mock setup
      when(() => mockExpenseDataBloc.state).thenReturn(
        const ExpenseDataState(
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 0,
          expenses: [],
        ),
      );
      when(() => mockExpenseDataBloc.stream).thenAnswer((_) => Stream.empty());
      when(() => mockExpenseDataBloc.add(any())).thenAnswer((_) {});
      when(() => mockExpenseDataBloc.close()).thenAnswer((_) async {});

      when(
        () => mockExpenseBloc.state,
      ).thenReturn(ExpenseBarChartData(data: []));
      when(() => mockExpenseBloc.stream).thenAnswer((_) => Stream.empty());
      when(() => mockExpenseBloc.add(any())).thenAnswer((_) {});
      when(() => mockExpenseBloc.close()).thenAnswer((_) async {});
    });

    testWidgets('Test 1: AllExpenseReportPage loads', (
      WidgetTester tester,
    ) async {
      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
            BlocProvider<ExpenseBloc>.value(value: mockExpenseBloc),
          ],
          child: const AllExpenseReportPage(),
        ),
      );

      expect(find.byType(AllExpenseReportPage), findsOneWidget);
    });

    testWidgets('Test 2: Page structure renders', (WidgetTester tester) async {
      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
            BlocProvider<ExpenseBloc>.value(value: mockExpenseBloc),
          ],
          child: const AllExpenseReportPage(),
        ),
      );

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(Layout), findsOneWidget);
    });

    testWidgets('Test 3: Empty state', (WidgetTester tester) async {
      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
            BlocProvider<ExpenseBloc>.value(value: mockExpenseBloc),
          ],
          child: const AllExpenseReportPage(),
        ),
      );

      expect(find.byType(AllExpenseReportPage), findsOneWidget);
    });

    testWidgets('Test 4: Page stability', (WidgetTester tester) async {
      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
            BlocProvider<ExpenseBloc>.value(value: mockExpenseBloc),
          ],
          child: const AllExpenseReportPage(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(AllExpenseReportPage), findsOneWidget);
    });

    testWidgets('Test 5: Render without errors', (WidgetTester tester) async {
      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<ExpenseDataBloc>.value(value: mockExpenseDataBloc),
            BlocProvider<ExpenseBloc>.value(value: mockExpenseBloc),
          ],
          child: const AllExpenseReportPage(),
        ),
      );

      expect(find.byType(AllExpenseReportPage), findsOneWidget);
    });
  });

  group('search_report - RechargeReport Tests', () {
    Map<String, dynamic> setupRechargeReportMocks() {
      final historyStateController =
          StreamController<LoadedHistoryState>.broadcast();
      final mockHistoryBloc = MockLoadedHistoryBloc();
      final mockRechargeBloc = MockRechargeBloc();

      final externalTransactions = [
        createTestExternalTransaction(
          id: 'trans-1',
          code: 'DEP20240101ABC123',
          amount: 1000000,
          type: ExternalTransactionType.deposit,
        ),
      ];

      final internalTransactions = [
        createTestInternalTransaction(
          uid: 'int-1',
          code: 'TRF20240103GHI789',
          amount: 200000,
          fromUser: 'Friend A',
          toUser: 'Test User',
        ),
      ];

      final initialHistoryState = LoadedHistoryState(
        isLoading: false,
        page: 1,
        totalPage: 1,
        externalTransaction: externalTransactions,
        internalTransaction: internalTransactions,
      );

      historyStateController.add(initialHistoryState);

      when(() => mockHistoryBloc.state).thenReturn(initialHistoryState);
      when(
        () => mockHistoryBloc.stream,
      ).thenAnswer((_) => historyStateController.stream);
      when(() => mockHistoryBloc.add(any())).thenAnswer((_) {});
      when(() => mockHistoryBloc.close()).thenAnswer((_) async {});

      when(() => mockRechargeBloc.state).thenReturn(RechargeState());
      when(() => mockRechargeBloc.stream).thenAnswer((_) => Stream.empty());
      when(() => mockRechargeBloc.add(any())).thenAnswer((_) {});
      when(() => mockRechargeBloc.close()).thenAnswer((_) async {});

      return {
        'controller': historyStateController,
        'historyBloc': mockHistoryBloc,
        'rechargeBloc': mockRechargeBloc,
      };
    }

    testWidgets('Test 6: RechargeReport loads', (WidgetTester tester) async {
      final mocks = setupRechargeReportMocks();

      try {
        await pumpReportWidget(
          tester,
          MultiBlocProvider(
            providers: [
              BlocProvider<LoadedHistoryBloc>.value(
                value: mocks['historyBloc'],
              ),
              BlocProvider<RechargeBloc>.value(value: mocks['rechargeBloc']),
            ],
            child: const RechargeReport(),
          ),
        );

        expect(find.byType(RechargeReport), findsOneWidget);
      } finally {
        await (mocks['controller'] as StreamController).close();
      }
    });

    testWidgets('Test 7: RechargeReport structure', (
      WidgetTester tester,
    ) async {
      final mocks = setupRechargeReportMocks();

      try {
        await pumpReportWidget(
          tester,
          MultiBlocProvider(
            providers: [
              BlocProvider<LoadedHistoryBloc>.value(
                value: mocks['historyBloc'],
              ),
              BlocProvider<RechargeBloc>.value(value: mocks['rechargeBloc']),
            ],
            child: const RechargeReport(),
          ),
        );

        expect(find.byType(AppShell), findsOneWidget);
        expect(find.byType(Layout), findsOneWidget);
      } finally {
        await (mocks['controller'] as StreamController).close();
      }
    });

    testWidgets('Test 8: External transactions', (WidgetTester tester) async {
      final mocks = setupRechargeReportMocks();

      try {
        await pumpReportWidget(
          tester,
          MultiBlocProvider(
            providers: [
              BlocProvider<LoadedHistoryBloc>.value(
                value: mocks['historyBloc'],
              ),
              BlocProvider<RechargeBloc>.value(value: mocks['rechargeBloc']),
            ],
            child: const RechargeReport(),
          ),
        );

        expect(find.byType(RechargeReport), findsOneWidget);
      } finally {
        await (mocks['controller'] as StreamController).close();
      }
    });

    testWidgets('Test 9: Internal transactions', (WidgetTester tester) async {
      final mocks = setupRechargeReportMocks();

      try {
        await pumpReportWidget(
          tester,
          MultiBlocProvider(
            providers: [
              BlocProvider<LoadedHistoryBloc>.value(
                value: mocks['historyBloc'],
              ),
              BlocProvider<RechargeBloc>.value(value: mocks['rechargeBloc']),
            ],
            child: const RechargeReport(),
          ),
        );

        expect(find.byType(RechargeReport), findsOneWidget);
      } finally {
        await (mocks['controller'] as StreamController).close();
      }
    });
  });

  // ============================================================================
  // SearchTransactionPage Tests
  // ============================================================================

  group('search_report - SearchTransactionPage Tests', () {
    late MockSearchTransactionBloc mockSearchTransactionBloc;
    late MockRechargeBloc mockRechargeBloc;

    setUp(() {
      mockSearchTransactionBloc = MockSearchTransactionBloc();
      mockRechargeBloc = MockRechargeBloc();

      // Setup SearchTransactionBloc behavior
      when(() => mockSearchTransactionBloc.stream).thenAnswer(
        (_) => Stream.value(
          const search_bloc.SearchTransactionsState(
            isLoading: false,
            expense: [],
            externalTransactions: [],
            internalTransactions: [],
          ),
        ),
      );

      when(() => mockSearchTransactionBloc.state).thenReturn(
        const search_bloc.SearchTransactionsState(
          isLoading: false,
          expense: [],
          externalTransactions: [],
          internalTransactions: [],
        ),
      );

      when(() => mockSearchTransactionBloc.close()).thenAnswer((_) async {});

      // Setup RechargeBloc behavior
      when(
        () => mockRechargeBloc.stream,
      ).thenAnswer((_) => Stream.value(RechargeState()));

      when(() => mockRechargeBloc.state).thenReturn(RechargeState());

      when(() => mockRechargeBloc.close()).thenAnswer((_) async {});
    });

    testWidgets('Test 10: SearchTransactionPage loads successfully', (
      WidgetTester tester,
    ) async {
      // tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<search_bloc.SearchTransactionBloc>.value(
              value: mockSearchTransactionBloc,
            ),
            BlocProvider<RechargeBloc>.value(value: mockRechargeBloc),
          ],
          child: const SearchTransactionPage(),
        ),
      );

      // Verify search transaction page renders
      expect(find.byType(SearchTransactionPage), findsOneWidget);
    });

    testWidgets('Test 11: Search and filter buttons are present', (
      WidgetTester tester,
    ) async {
      // tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<search_bloc.SearchTransactionBloc>.value(
              value: mockSearchTransactionBloc,
            ),
            BlocProvider<RechargeBloc>.value(value: mockRechargeBloc),
          ],
          child: const SearchTransactionPage(),
        ),
      );

      // Find and verify search icon button exists and is tappable
      expect(find.byIcon(Icons.search), findsWidgets);

      // Find and verify filter button exists and is tappable
      expect(find.byIcon(Icons.filter_list), findsWidgets);
    });

    testWidgets('Test 12: Page renders without errors', (
      WidgetTester tester,
    ) async {
      // tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await pumpReportWidget(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<search_bloc.SearchTransactionBloc>.value(
              value: mockSearchTransactionBloc,
            ),
            BlocProvider<RechargeBloc>.value(value: mockRechargeBloc),
          ],
          child: const SearchTransactionPage(),
        ),
      );

      // Verify page renders without throwing exception
      expect(find.byType(SearchTransactionPage), findsOneWidget);
    });
  });
}
