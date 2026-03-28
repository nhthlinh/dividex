import 'dart:async';
import 'dart:typed_data';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart'
    as event_event;
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/event_expense/presentation/pages/add_expense_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/all_expense_report.dart';
import 'package:Dividex/features/event_expense/presentation/pages/choose_event_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/edit_expense_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/split_page.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/toggle_tap.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/user_item_table.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/pages/choose_members_page.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:Dividex/shared/widgets/two_option_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExpenseBloc extends Mock implements ExpenseBloc {}

class MockExpenseDataBloc extends Mock implements ExpenseDataBloc {}

class MockLoadedUsersBloc extends Mock implements LoadedUsersBloc {}

class MockEventDataBloc extends Mock implements EventDataBloc {}

class FakeExpenseEvent extends Fake implements ExpenseEvent {}

class FakeLoadUserEvent extends Fake implements user_event.LoadUserEvent {}

class FakeEventEvent extends Fake implements event_event.EventEvent {}

typedef CustomSplitResolver =
    List<UserDebt> Function(Map<String, dynamic> extra);

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
  await tester.pumpAndSettle();
}

void triggerElevatedButton(WidgetTester tester, Key key) {
  final finder = find.byKey(key);
  expect(finder, findsOneWidget);
  final widget = tester.widget<ElevatedButton>(finder);
  expect(widget.onPressed, isNotNull);
  widget.onPressed!.call();
}

void drainExceptions(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

Future<void> selectEventAndPayer(
  WidgetTester tester,
  GoRouter router,
  EventModel selectedEvent,
  UserModel selectedPayer,
) async {
  await tester.tap(find.byKey(const Key('expense_create_event_input')));
  await tester.pumpAndSettle();

  final chooseEventWidget = tester.widget<ChooseEventPage>(
    find.byType(ChooseEventPage),
  );
  chooseEventWidget.onSelectedEventChanged(selectedEvent);
  await tester.pumpAndSettle();

  router.pop();
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('expense_create_payer_input')));
  await tester.pumpAndSettle();

  final chooseMembersWidget = tester.widget<ChooseMembersPage>(
    find.byType(ChooseMembersPage),
  );
  chooseMembersWidget.onSelectedMembersChanged(<UserModel>[selectedPayer]);
  await tester.pumpAndSettle();

  router.pop();
  await tester.pumpAndSettle();
}

GoRouter buildAddExpenseRouter({
  required MockExpenseBloc expenseBloc,
  required MockLoadedUsersBloc chooseMembersBloc,
  required MockLoadedUsersBloc splitUsersBloc,
  required MockEventDataBloc eventDataBloc,
  EventModel? initialSelectedEvent,
  UserModel? initialSelectedPayer,
  bool showCreateOptionDialogOnInit = false,
  Object? scanResult,
}) {
  return GoRouter(
    initialLocation: '/add-expense-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/add-expense-test',
        name: AppRouteNames.addExpense,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<ExpenseBloc>.value(
            value: expenseBloc,
            child: AddExpensePage(
              loadedUsersBloc: splitUsersBloc,
              showCreateOptionDialogOnInit: showCreateOptionDialogOnInit,
              initialSelectedEvent: initialSelectedEvent,
              initialSelectedPayer: initialSelectedPayer,
              bypassValidationForTesting: true,
            ),
          );
        },
      ),
      GoRoute(
        path: '/choose-member-test',
        name: AppRouteNames.chooseMember,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider<LoadedUsersBloc>.value(
            value: chooseMembersBloc,
            child: ChooseMembersPage(
              id: extra['id'] as String?,
              type: extra['type'] as user_event.LoadType,
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
        path: '/choose-event-test',
        name: AppRouteNames.chooseEvent,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider<EventDataBloc>.value(
            value: eventDataBloc,
            child: ChooseEventPage(
              initialSelectedEvent: extra['initialSelected'] as EventModel?,
              onSelectedEventChanged:
                  extra['onChanged'] as ValueChanged<EventModel>,
            ),
          );
        },
      ),
      GoRoute(
        path: '/custom-split-test',
        name: AppRouteNames.customSplit,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;

          return BlocProvider<LoadedUsersBloc>.value(
            value: splitUsersBloc,
            child: SplitPage(
              eventId:
                  (extra['eventId'] as String?) ??
                  (extra['id'] as String?) ??
                  '',
              type: extra['type'] as user_event.LoadType,
              initialType: extra['initialType'] as SplitTypeEnum,
              initialSelected: extra['initialSelected'] as List<UserDebt>,
              initialUsers: extra['initialUsers'] as List<UserModel>,
              onChanged: extra['onChanged'] as ValueChanged<List<UserDebt>>,
              amount: extra['amount'] as double,
              items: extra['items'] as List<ImageExpenseItemModel>?,
            ),
          );
        },
      ),
      GoRoute(
        path: '/scan-expense-test',
        name: AppRouteNames.scanExpense,
        builder: (BuildContext context, GoRouterState state) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const Key('mock_scan_submit_button'),
                onPressed: () {
                  context.pop(scanResult);
                },
                child: const Text('Return scan result'),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/friend-profile-test/:id',
        name: AppRouteNames.friendProfile,
        builder: (BuildContext context, GoRouterState state) {
          return const SizedBox.shrink();
        },
      ),
    ],
  );
}

GoRouter buildEditExpenseRouter({
  required MockExpenseBloc expenseBloc,
  required MockLoadedUsersBloc splitUsersBloc,
}) {
  return GoRouter(
    initialLocation: '/edit-expense-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/edit-expense-test',
        name: AppRouteNames.expenseEdit,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<ExpenseBloc>.value(
            value: expenseBloc,
            child: EditExpensePage(
              expenseId: 'expense-1',
              loadedUsersBloc: splitUsersBloc,
            ),
          );
        },
      ),
    ],
  );
}

GoRouter buildExpenseReportRouter({
  required MockExpenseBloc expenseBloc,
  required MockExpenseDataBloc expenseDataBloc,
}) {
  return GoRouter(
    initialLocation: '/all-expense-report-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/all-expense-report-test',
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<ExpenseBloc>.value(value: expenseBloc),
              BlocProvider<ExpenseDataBloc>.value(value: expenseDataBloc),
            ],
            child: const AllExpenseReportPage(),
          );
        },
      ),
    ],
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final users = <UserModel>[
    UserModel(id: 'user-1', fullName: 'User One', email: 'u1@test.com'),
    UserModel(id: 'user-2', fullName: 'User Two', email: 'u2@test.com'),
    UserModel(id: 'user-3', fullName: 'User Three', email: 'u3@test.com'),
  ];

  final sampleExpense = ExpenseModel(
    id: 'expense-1',
    name: 'Old Lunch',
    event: 'event-1',
    currency: CurrencyEnum.vnd,
    totalAmount: 120,
    category: 'food',
    paidByUser: users.first,
    splitType: SplitTypeEnum.equal,
    note: 'old note',
    expenseDate: DateTime(2026, 5, 10, 10, 30),
    remindAt: DateTime(2026, 5, 12),
    userDebtInfos: <UserDeptInfo>[
      UserDeptInfo(user: users[0], amount: 40),
      UserDeptInfo(user: users[1], amount: 40),
      UserDeptInfo(user: users[2], amount: 40),
    ],
  );

  final eventGroups = <GroupModel>[
    GroupModel(
      id: 'group-1',
      name: 'Trip Group',
      events: <EventModel>[
        EventModel(
          id: 'event-1',
          name: 'Da Lat Trip',
          eventStart: DateTime(2026, 5, 10),
          eventEnd: DateTime(2026, 5, 12),
          group: 'group-1',
        ),
      ],
    ),
  ];

  setUpAll(() async {
    registerFallbackValue(FakeExpenseEvent());
    registerFallbackValue(FakeLoadUserEvent());
    registerFallbackValue(FakeEventEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'owner-1',
        email: 'owner@dividex.test',
        fullName: 'Expense Owner',
        avatarUrl: null,
      ),
    );
  });

  group('expense integration tests', () {
    late MockExpenseBloc mockExpenseBloc;
    late MockExpenseDataBloc mockExpenseDataBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;
    late MockLoadedUsersBloc mockSplitUsersBloc;
    late MockEventDataBloc mockEventDataBloc;

    setUp(() {
      mockExpenseBloc = MockExpenseBloc();
      mockExpenseDataBloc = MockExpenseDataBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();
      mockSplitUsersBloc = MockLoadedUsersBloc();
      mockEventDataBloc = MockEventDataBloc();

      when(() => mockExpenseBloc.state).thenReturn(ExpenseState());
      when(
        () => mockExpenseBloc.stream,
      ).thenAnswer((_) => const Stream<ExpenseState>.empty());
      when(() => mockExpenseBloc.add(any())).thenAnswer((_) {});
      when(() => mockExpenseBloc.close()).thenAnswer((_) async {});

      when(() => mockExpenseDataBloc.state).thenReturn(
        const ExpenseDataState(
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 0,
          expenses: <ExpenseModel>[],
        ),
      );
      when(
        () => mockExpenseDataBloc.stream,
      ).thenAnswer((_) => const Stream<ExpenseDataState>.empty());
      when(() => mockExpenseDataBloc.add(any())).thenAnswer((_) {});
      when(() => mockExpenseDataBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[users[0], users[1]],
          page: 1,
          totalPage: 1,
          totalItems: 2,
        ),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});

      when(() => mockSplitUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: users,
          page: 1,
          totalPage: 1,
          totalItems: users.length,
        ),
      );
      when(
        () => mockSplitUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockSplitUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockSplitUsersBloc.close()).thenAnswer((_) async {});

      when(() => mockEventDataBloc.state).thenReturn(
        EventDataState(
          isLoading: false,
          groups: eventGroups,
          page: 1,
          totalPage: 1,
          totalItems: eventGroups.length,
        ),
      );
      when(
        () => mockEventDataBloc.stream,
      ).thenAnswer((_) => const Stream<EventDataState>.empty());
      when(() => mockEventDataBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventDataBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given valid expense data, when submit create, then dispatch CreateExpenseEvent',
      (WidgetTester tester) async {
        // Given
        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          initialSelectedEvent: eventGroups.first.events!.first,
          initialSelectedPayer: users[0],
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.enterText(
          find.byKey(const Key('expense_create_name_input')),
          'Lunch Team',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_amount_input')),
          '300',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_date_input')),
          '8:30 AM - 10/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_reminder_input')),
          '12/05/2026',
        );
        await tester.pumpAndSettle();

        final dynamic createState1 = tester.state(find.byType(AddExpensePage));
        createState1.setState(() {});
        await tester.pumpAndSettle();

        final dynamic createStateSubmit1 = tester.state(
          find.byType(AddExpensePage),
        );
        createStateSubmit1.setState(() {
          createStateSubmit1.splitType = SplitTypeEnum.equal;
          createStateSubmit1.usersInEvent = users;
          createStateSubmit1.dateController.text = '8:30 AM - 10/05/2026';
          createStateSubmit1.reminderController.text = '12/05/2026';
          createStateSubmit1.userDebts = <UserDebt>[
            UserDebt(userId: 'user-1', amount: 100),
            UserDebt(userId: 'user-2', amount: 100),
            UserDebt(userId: 'user-3', amount: 100),
          ];
        });
        await tester.pumpAndSettle();

        createStateSubmit1.submitExpense();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockExpenseBloc.add(
            any(
              that: isA<CreateExpenseEvent>()
                  .having(
                    (CreateExpenseEvent e) => e.name,
                    'name',
                    'Lunch Team',
                  )
                  .having(
                    (CreateExpenseEvent e) => e.totalAmount,
                    'totalAmount',
                    300,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.eventId,
                    'eventId',
                    'event-1',
                  )
                  .having(
                    (CreateExpenseEvent e) => e.paidById,
                    'paidById',
                    'user-1',
                  ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Given split equally selected, when submit, then userDebts are evenly distributed',
      (WidgetTester tester) async {
        // Given
        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          initialSelectedEvent: eventGroups.first.events!.first,
          initialSelectedPayer: users[0],
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.enterText(
          find.byKey(const Key('expense_create_name_input')),
          'Dinner Equal',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_amount_input')),
          '300',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_date_input')),
          '8:30 AM - 10/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_reminder_input')),
          '12/05/2026',
        );
        await tester.pumpAndSettle();

        final dynamic createState2 = tester.state(find.byType(AddExpensePage));
        createState2.setState(() {});
        await tester.pumpAndSettle();

        final dynamic createStateSubmit2 = tester.state(
          find.byType(AddExpensePage),
        );
        createStateSubmit2.setState(() {
          createStateSubmit2.splitType = SplitTypeEnum.equal;
          createStateSubmit2.usersInEvent = users;
          createStateSubmit2.dateController.text = '8:30 AM - 10/05/2026';
          createStateSubmit2.reminderController.text = '12/05/2026';
          createStateSubmit2.userDebts = <UserDebt>[
            UserDebt(userId: 'user-1', amount: 100),
            UserDebt(userId: 'user-2', amount: 100),
            UserDebt(userId: 'user-3', amount: 100),
          ];
        });
        await tester.pumpAndSettle();

        createStateSubmit2.submitExpense();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockExpenseBloc.add(
            any(
              that: isA<CreateExpenseEvent>()
                  .having(
                    (CreateExpenseEvent e) => e.splitType,
                    'splitType',
                    SplitTypeEnum.equal,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts.length,
                    'debtLength',
                    3,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts.fold<double>(
                      0,
                      (sum, debt) => sum + debt.amount,
                    ),
                    'sumDebt',
                    300,
                  ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Given split custom selected, when accept custom split and submit, then dispatch CreateExpenseEvent with custom debts',
      (WidgetTester tester) async {
        // Given
        final customDebts = <UserDebt>[
          UserDebt(userId: 'user-1', amount: 70),
          UserDebt(userId: 'user-2', amount: 20),
          UserDebt(userId: 'user-3', amount: 10),
        ];

        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          initialSelectedEvent: eventGroups.first.events!.first,
          initialSelectedPayer: users[0],
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.enterText(
          find.byKey(const Key('expense_create_name_input')),
          'Taxi Custom',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_amount_input')),
          '100',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_date_input')),
          '8:30 AM - 10/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_reminder_input')),
          '12/05/2026',
        );
        await tester.pumpAndSettle();

        final dynamic createState3 = tester.state(find.byType(AddExpensePage));
        createState3.setState(() {});
        await tester.pumpAndSettle();

        final dynamic createStateSubmit3 = tester.state(
          find.byType(AddExpensePage),
        );
        createStateSubmit3.setState(() {
          createStateSubmit3.splitType = SplitTypeEnum.custom;
          createStateSubmit3.usersInEvent = users;
          createStateSubmit3.dateController.text = '8:30 AM - 10/05/2026';
          createStateSubmit3.reminderController.text = '12/05/2026';
          createStateSubmit3.userDebts = customDebts;
        });
        await tester.pumpAndSettle();

        createStateSubmit3.submitExpense();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockExpenseBloc.add(
            any(
              that: isA<CreateExpenseEvent>()
                  .having(
                    (CreateExpenseEvent e) => e.splitType,
                    'splitType',
                    SplitTypeEnum.custom,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts[0].amount,
                    'u1',
                    70,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts[1].amount,
                    'u2',
                    20,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts[2].amount,
                    'u3',
                    10,
                  ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Given custom split by amount, when returning from custom split and submitting, then dispatch CreateExpenseEvent with correct amount debts',
      (WidgetTester tester) async {
        // Given
        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          initialSelectedEvent: eventGroups.first.events!.first,
          initialSelectedPayer: users[0],
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.enterText(
          find.byKey(const Key('expense_create_name_input')),
          'Custom Amount Split',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_amount_input')),
          '100',
        );
        await tester.pumpAndSettle();
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final dynamic addExpenseState = tester.state(
          find.byType(AddExpensePage),
        );
        addExpenseState.setState(() {
          addExpenseState.dateController.text = '8:30 AM - 10/05/2026';
          addExpenseState.reminderController.text = '12/05/2026';
        });
        await tester.pumpAndSettle();

        final amountSplitSelector = tester.widget<TwoOptionSelector>(
          find.byType(TwoOptionSelector),
        );
        amountSplitSelector.onSelectionChanged(2);
        await tester.pumpAndSettle();

        expect(find.byType(SplitPage), findsOneWidget);

        final splitAmountFields = find.byType(TextFormField);
        expect(splitAmountFields, findsAtLeastNWidgets(3));

        await tester.enterText(splitAmountFields.at(0), '0');
        await tester.pumpAndSettle();
        await tester.enterText(splitAmountFields.at(1), '0');
        await tester.pumpAndSettle();
        await tester.enterText(splitAmountFields.at(2), '0');
        await tester.pumpAndSettle();

        await tester.enterText(splitAmountFields.at(0), '50');
        await tester.pumpAndSettle();
        await tester.enterText(splitAmountFields.at(1), '30');
        await tester.pumpAndSettle();
        await tester.enterText(splitAmountFields.at(2), '20');
        await tester.pumpAndSettle();

        final splitAcceptButton = find.descendant(
          of: find.byType(SplitPage),
          matching: find.byType(ElevatedButton),
        );
        expect(splitAcceptButton, findsOneWidget);
        final splitAcceptWidget = tester.widget<ElevatedButton>(
          splitAcceptButton,
        );
        expect(splitAcceptWidget.onPressed, isNotNull);
        splitAcceptWidget.onPressed!.call();
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        addExpenseState.submitExpense();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockExpenseBloc.add(
            any(
              that: isA<CreateExpenseEvent>()
                  .having(
                    (CreateExpenseEvent e) => e.splitType,
                    'splitType',
                    SplitTypeEnum.custom,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts[0].amount,
                    'u1',
                    50,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts[1].amount,
                    'u2',
                    30,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts[2].amount,
                    'u3',
                    20,
                  )
                  .having(
                    (CreateExpenseEvent e) => e.userDebts.fold<double>(
                      0,
                      (sum, debt) => sum + debt.amount,
                    ),
                    'sumDebt',
                    100,
                  ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Given OCR bill items, when split by items and submitting, then dispatch CreateExpenseEvent with item-based debts',
      (WidgetTester tester) async {
        // Given
        final scanResult = <String, dynamic>{
          'imageInfo': ImageExpenseModel(
            items: <ImageExpenseItemModel>[
              ImageExpenseItemModel(
                name: 'Item A',
                quantity: 1,
                unitPrice: 70000,
                totalPrice: 70000,
              ),
              ImageExpenseItemModel(
                name: 'Item B',
                quantity: 1,
                unitPrice: 30000,
                totalPrice: 30000,
              ),
            ],
            name: 'OCR Item Split',
            category: 'food',
            totalAmount: 100000,
            currency: 'VND',
            note: 'Bill OCR',
            expenseDate: DateTime(2026, 5, 10, 12, 30),
            endDate: DateTime(2026, 5, 13),
          ),
          'bytes': Uint8List.fromList(<int>[1, 2, 3, 4]),
        };

        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          initialSelectedEvent: eventGroups.first.events!.first,
          initialSelectedPayer: users[0],
          showCreateOptionDialogOnInit: true,
          scanResult: scanResult,
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.tap(
          find.byKey(const Key('expense_create_scanning_option_button')),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('mock_scan_submit_button')));
        await tester.pumpAndSettle();

        final itemSplitSelector = tester.widget<TwoOptionSelector>(
          find.byType(TwoOptionSelector),
        );
        itemSplitSelector.onSelectionChanged(2);
        await tester.pumpAndSettle();

        expect(find.byType(SplitPage), findsOneWidget);

        final splitToggle = tester.widget<ToggleTab>(find.byType(ToggleTab));
        splitToggle.onChanged(false);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.navigate_next), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsAtLeastNWidgets(1));
        final firstDownIconButton = find.ancestor(
          of: find.byIcon(Icons.keyboard_arrow_down).at(0),
          matching: find.byType(IconButton),
        );
        final expandFirstItem = tester.widget<IconButton>(firstDownIconButton);
        expect(expandFirstItem.onPressed, isNotNull);
        expandFirstItem.onPressed!.call();
        await tester.pumpAndSettle();

        final firstItemUsers = find.byType(ListTile);
        expect(firstItemUsers, findsAtLeastNWidgets(2));
        final selectUserOne = tester.widget<ListTile>(firstItemUsers.at(0));
        expect(selectUserOne.onTap, isNotNull);
        selectUserOne.onTap!.call();
        await tester.pumpAndSettle();

        final firstUpIconButton = find.ancestor(
          of: find.byIcon(Icons.keyboard_arrow_up).at(0),
          matching: find.byType(IconButton),
        );
        final collapseFirstItem = tester.widget<IconButton>(firstUpIconButton);
        expect(collapseFirstItem.onPressed, isNotNull);
        collapseFirstItem.onPressed!.call();
        await tester.pumpAndSettle();

        final secondDownIconButton = find.ancestor(
          of: find.byIcon(Icons.keyboard_arrow_down).at(1),
          matching: find.byType(IconButton),
        );
        final expandSecondItem = tester.widget<IconButton>(
          secondDownIconButton,
        );
        expect(expandSecondItem.onPressed, isNotNull);
        expandSecondItem.onPressed!.call();
        await tester.pumpAndSettle();

        final secondItemUsers = find.byType(ListTile);
        expect(secondItemUsers, findsAtLeastNWidgets(2));
        final selectUserTwo = tester.widget<ListTile>(secondItemUsers.at(1));
        expect(selectUserTwo.onTap, isNotNull);
        selectUserTwo.onTap!.call();
        await tester.pumpAndSettle();

        final navigateNextIconButton = find.ancestor(
          of: find.byIcon(Icons.navigate_next),
          matching: find.byType(IconButton),
        );
        final nextButton = tester.widget<IconButton>(navigateNextIconButton);
        expect(nextButton.onPressed, isNotNull);
        nextButton.onPressed!.call();
        await tester.pumpAndSettle();

        final dynamic previewItemTableState = tester.state(
          find.byType(UserItemTableWidget),
        );
        Map<String, int> previewDebtsByUser() {
          final users = previewItemTableState.users as List<dynamic>;
          return <String, int>{
            for (final user in users)
              (user.user.id as String): (user.amount as double).round(),
          };
        }

        bool hasReasonableSplit() {
          final previewMap = previewDebtsByUser();
          return previewMap['user-1'] == 70000 && previewMap['user-2'] == 30000;
        }

        // Sau khi bấm '>' (đã chia), kiểm tra phân bổ; nếu chưa hợp lý thì bấm '<' quay lại.
        if (!hasReasonableSplit()) {
          final navigateBackIconButton = find.ancestor(
            of: find.byIcon(Icons.navigate_before),
            matching: find.byType(IconButton),
          );
          final backButton = tester.widget<IconButton>(navigateBackIconButton);
          expect(backButton.onPressed, isNotNull);
          backButton.onPressed!.call();
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.navigate_next), findsOneWidget);
          final goNextAgain = tester.widget<IconButton>(
            find.ancestor(
              of: find.byIcon(Icons.navigate_next),
              matching: find.byType(IconButton),
            ),
          );
          expect(goNextAgain.onPressed, isNotNull);
          goNextAgain.onPressed!.call();
          await tester.pumpAndSettle();
        }

        expect(hasReasonableSplit(), isTrue);

        final splitAcceptButton = find.descendant(
          of: find.byType(SplitPage),
          matching: find.byType(ElevatedButton),
        );
        expect(splitAcceptButton, findsOneWidget);
        final splitAcceptWidget = tester.widget<ElevatedButton>(
          splitAcceptButton,
        );
        expect(splitAcceptWidget.onPressed, isNotNull);
        splitAcceptWidget.onPressed!.call();
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final dynamic addExpenseState = tester.state(
          find.byType(AddExpensePage),
        );
        addExpenseState.submitExpense();
        await tester.pumpAndSettle();
        drainExceptions(tester);

        // Then
        final capturedEvents = verify(
          () => mockExpenseBloc.add(captureAny()),
        ).captured;
        final createEvents = capturedEvents
            .whereType<CreateExpenseEvent>()
            .toList();

        expect(createEvents, hasLength(1));

        final createEvent = createEvents.single;
        final debtByUser = <String, int>{
          for (final debt in createEvent.userDebts)
            debt.userId: debt.amount.round(),
        };

        expect(createEvent.name, 'OCR Item Split');
        expect(createEvent.splitType, SplitTypeEnum.custom);
        expect(
          createEvent.userDebts.fold<double>(
            0,
            (sum, debt) => sum + debt.amount,
          ),
          100000,
        );
        expect(debtByUser['user-1'], 70000);
        expect(debtByUser['user-2'], 30000);
        expect(createEvent.images?.length, 1);
      },
    );

    testWidgets(
      'Given amount is zero, when try submit, then no CreateExpenseEvent is dispatched',
      (WidgetTester tester) async {
        // Given
        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          initialSelectedEvent: eventGroups.first.events!.first,
          initialSelectedPayer: users[0],
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.enterText(
          find.byKey(const Key('expense_create_name_input')),
          'Invalid Zero',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_amount_input')),
          '0',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_date_input')),
          '8:30 AM - 10/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('expense_create_reminder_input')),
          '12/05/2026',
        );
        await tester.pumpAndSettle();

        final submitButton = tester.widget<ElevatedButton>(
          find.byKey(const Key('expense_create_submit_button')),
        );

        // Then
        expect(submitButton.onPressed, isNull);
        verifyNever(
          () => mockExpenseBloc.add(any(that: isA<CreateExpenseEvent>())),
        );
      },
    );

    testWidgets(
      'Given scan flow, when attach bill image via OCR, then form is filled and image is attached',
      (WidgetTester tester) async {
        // Given
        final scanResult = <String, dynamic>{
          'imageInfo': ImageExpenseModel(
            items: <ImageExpenseItemModel>[
              ImageExpenseItemModel(
                name: 'Pho',
                quantity: 1,
                unitPrice: 120000,
                totalPrice: 120000,
              ),
            ],
            name: 'OCR Lunch',
            category: 'food',
            totalAmount: 120000,
            currency: 'VND',
            note: 'Scanned note',
            expenseDate: DateTime(2026, 5, 10, 12, 30),
            endDate: DateTime(2026, 5, 13),
          ),
          'bytes': Uint8List.fromList(<int>[1, 2, 3, 4]),
        };

        final router = buildAddExpenseRouter(
          expenseBloc: mockExpenseBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
          splitUsersBloc: mockSplitUsersBloc,
          eventDataBloc: mockEventDataBloc,
          showCreateOptionDialogOnInit: true,
          scanResult: scanResult,
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.tap(
          find.byKey(const Key('expense_create_scanning_option_button')),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('mock_scan_submit_button')));
        await tester.pumpAndSettle();

        // Then
        final dynamic state = tester.state(find.byType(AddExpensePage));
        expect(state.expenseNameController.text, 'OCR Lunch');
        expect(state.expenseAmountController.text, '120000.0');
        expect(state.images.length, 1);
      },
    );

    testWidgets(
      'Given edit expense page, when update valid fields and save, then dispatch UpdateExpenseEvent',
      (WidgetTester tester) async {
        // Given
        when(
          () => mockExpenseBloc.state,
        ).thenReturn(ExpenseLoadedState(expense: sampleExpense));

        final router = buildEditExpenseRouter(
          expenseBloc: mockExpenseBloc,
          splitUsersBloc: mockSplitUsersBloc,
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.enterText(
          find.byKey(const Key('expense_edit_name_input')),
          'Updated Lunch',
        );
        await tester.enterText(
          find.byKey(const Key('expense_edit_amount_input')),
          '150',
        );
        await tester.pumpAndSettle();

        final dynamic editState = tester.state(find.byType(EditExpensePage));
        editState.submitExpense();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockExpenseBloc.add(
            any(
              that: isA<UpdateExpenseEvent>()
                  .having(
                    (UpdateExpenseEvent e) => e.expenseId,
                    'expenseId',
                    'expense-1',
                  )
                  .having(
                    (UpdateExpenseEvent e) => e.name,
                    'name',
                    'Updated Lunch',
                  )
                  .having(
                    (UpdateExpenseEvent e) => e.totalAmount,
                    'totalAmount',
                    150,
                  ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Given edit expense page, when tap delete, then dispatch SoftDeleteExpenseEvent',
      (WidgetTester tester) async {
        // Given
        when(
          () => mockExpenseBloc.state,
        ).thenReturn(ExpenseLoadedState(expense: sampleExpense));

        final router = buildEditExpenseRouter(
          expenseBloc: mockExpenseBloc,
          splitUsersBloc: mockSplitUsersBloc,
        );

        await pumpLocalizedRouter(tester, router);

        // When
        triggerElevatedButton(tester, const Key('expense_edit_delete_button'));
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockExpenseBloc.add(
            any(
              that: isA<SoftDeleteExpenseEvent>().having(
                (SoftDeleteExpenseEvent e) => e.expenseId,
                'expenseId',
                'expense-1',
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Given expense report page, when loaded, then display correct expense list',
      (WidgetTester tester) async {
        // Given
        final expense1 = ExpenseModel(
          id: 'expense-a',
          name: 'Breakfast',
          event: 'Trip Event',
          currency: CurrencyEnum.vnd,
          totalAmount: 20000,
          category: 'food',
          expenseDate: DateTime(2026, 5, 10),
        );
        final expense2 = ExpenseModel(
          id: 'expense-b',
          name: 'Taxi',
          event: 'Trip Event',
          currency: CurrencyEnum.vnd,
          totalAmount: 70000,
          category: 'travel',
          expenseDate: DateTime(2026, 5, 9),
        );

        when(
          () => mockExpenseBloc.state,
        ).thenReturn(ExpenseBarChartData(data: <CustomBarChartData>[]));
        when(() => mockExpenseDataBloc.state).thenReturn(
          ExpenseDataState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 2,
            expenses: <ExpenseModel>[expense1, expense2],
          ),
        );

        final router = buildExpenseReportRouter(
          expenseBloc: mockExpenseBloc,
          expenseDataBloc: mockExpenseDataBloc,
        );

        await pumpLocalizedRouter(tester, router);

        // When
        await tester.pumpAndSettle();
        drainExceptions(tester);

        // Then
        expect(
          find.byKey(const Key('expense_report_list_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('expense_report_item_expense-a')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('expense_report_item_expense-b')),
          findsOneWidget,
        );
      },
    );
  });
}
