import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart'
    as event_event;
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/features/event_expense/presentation/pages/add_event_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/choose_event_page.dart';
import 'package:Dividex/features/event_expense/presentation/pages/event_setting.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/pages/choose_members_page.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventBloc extends Mock implements EventBloc {}

class MockEventDataBloc extends Mock implements EventDataBloc {}

class MockLoadedUsersBloc extends Mock implements LoadedUsersBloc {}

class MockLoadedGroupsBloc extends Mock implements LoadedGroupsBloc {}

class FakeEventEvent extends Fake implements event_event.EventEvent {}

class FakeLoadUserEvent extends Fake implements user_event.LoadUserEvent {}

class FakeLoadGroupsEvent extends Fake implements group_event.LoadGroupsEvent {}

void drainImageExceptions(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

void triggerCustomTextButton(WidgetTester tester, Key key) {
  final finder = find.byKey(key);
  expect(finder, findsOneWidget);
  final widget = tester.widget<CustomTextButton>(finder);
  expect(widget.onPressed, isNotNull);
  widget.onPressed!.call();
}

void triggerElevatedButton(WidgetTester tester, Key key) {
  final finder = find.byKey(key);
  expect(finder, findsOneWidget);
  final widget = tester.widget<ElevatedButton>(finder);
  expect(widget.onPressed, isNotNull);
  widget.onPressed!.call();
}

GoRouter buildAddEventRouter({
  required MockEventBloc eventBloc,
  required MockLoadedGroupsBloc groupsBloc,
  required MockLoadedUsersBloc chooseMembersBloc,
}) {
  return GoRouter(
    initialLocation: '/add-event-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/add-event-test',
        name: AppRouteNames.addEvent,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<EventBloc>.value(
            value: eventBloc,
            child: AddEventPage(loadedGroupsBloc: groupsBloc),
          );
        },
      ),
      GoRoute(
        path: '/choose-members-test',
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
    ],
  );
}

GoRouter buildEventSettingRouter({
  required MockEventBloc eventBloc,
  required MockLoadedUsersBloc usersBloc,
  MockLoadedUsersBloc? chooseMembersBloc,
}) {
  return GoRouter(
    initialLocation: '/event-setting-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/event-setting-test',
        name: AppRouteNames.eventSetting,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<EventBloc>.value(value: eventBloc),
              BlocProvider<LoadedUsersBloc>.value(value: usersBloc),
            ],
            child: const EventSettingPage(
              eventId: 'event-1',
              groupId: 'group-1',
              eventName: 'Old Event',
            ),
          );
        },
      ),
      GoRoute(
        path: '/choose-members-test',
        name: AppRouteNames.chooseMember,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider<LoadedUsersBloc>.value(
            value: chooseMembersBloc ?? usersBloc,
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
    ],
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(FakeEventEvent());
    registerFallbackValue(FakeLoadUserEvent());
    registerFallbackValue(FakeLoadGroupsEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'owner-1',
        email: 'owner@dividex.test',
        fullName: 'Event Owner',
        avatarUrl: null,
      ),
    );
  });

  group('event - Tao event trong group', () {
    late MockEventBloc mockEventBloc;
    late MockLoadedGroupsBloc mockLoadedGroupsBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    final group = GroupModel(id: 'group-1', name: 'Trip Group');

    setUp(() {
      mockEventBloc = MockEventBloc();
      mockLoadedGroupsBloc = MockLoadedGroupsBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockEventBloc.state).thenReturn(EventState());
      when(
        () => mockEventBloc.stream,
      ).thenAnswer((_) => const Stream<EventState>.empty());
      when(() => mockEventBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedGroupsBloc.state).thenReturn(
        LoadedGroupsState(
          isLoading: false,
          groups: <GroupModel>[group],
          page: 1,
          totalPage: 1,
          totalItems: 1,
        ),
      );
      when(
        () => mockLoadedGroupsBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedGroupsState>.empty());
      when(() => mockLoadedGroupsBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedGroupsBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[UserModel(id: 'member-1', fullName: 'Member One')],
          page: 1,
          totalPage: 1,
          totalItems: 1,
        ),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given add event page, when valid data in group, then dispatch CreateEventEvent',
      (WidgetTester tester) async {
        // Given
        final router = buildAddEventRouter(
          eventBloc: mockEventBloc,
          groupsBloc: mockLoadedGroupsBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
        );

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

        // When
        await tester.enterText(
          find.byKey(const Key('event_create_name_input')),
          'Summer Trip',
        );
        await tester.enterText(
          find.byKey(const Key('event_create_description_input')),
          'Trip to Da Lat',
        );
        await tester.enterText(
          find.byKey(const Key('event_create_start_date_input')),
          '10/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('event_create_end_date_input')),
          '12/05/2026',
        );
        await tester.pumpAndSettle();

        final groupDropdown = tester.widget<CustomDropdownWidget<GroupModel>>(
          find.byKey(const Key('event_create_group_dropdown')),
        );
        groupDropdown.onChanged(group);
        await tester.pumpAndSettle();

        triggerCustomTextButton(
          tester,
          const Key('event_create_add_members_button'),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('choose_member_select_member-1'),
        );
        await tester.pumpAndSettle();

        router.pop();
        await tester.pumpAndSettle();

        final dynamic addEventState = tester.state(find.byType(AddEventPage));
        addEventState.eventNameController.text = 'Summer Trip';
        addEventState.eventDescriptionController.text = 'Trip to Da Lat';
        addEventState.eventStartDateController.text = '10/05/2026';
        addEventState.eventEndDateController.text = '12/05/2026';
        addEventState.selectedGroup.value = group;
        addEventState.selectedMembers = <UserModel>[
          UserModel(id: 'member-1', fullName: 'Member One'),
        ];
        await tester.pumpAndSettle();
        await addEventState.submitEvent();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockEventBloc.add(
            any(
              that: isA<event_event.CreateEventEvent>()
                  .having(
                    (event_event.CreateEventEvent e) => e.name,
                    'name',
                    'Summer Trip',
                  )
                  .having(
                    (event_event.CreateEventEvent e) => e.groupId,
                    'groupId',
                    'group-1',
                  )
                  .having(
                    (event_event.CreateEventEvent e) => e.eventStart,
                    'eventStart',
                    '2026-05-10',
                  )
                  .having(
                    (event_event.CreateEventEvent e) => e.eventEnd,
                    'eventEnd',
                    '2026-05-12',
                  )
                  .having(
                    (event_event.CreateEventEvent e) => e.memberIds,
                    'memberIds',
                    <String>['member-1'],
                  ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('event - Khong cho tao event neu khong thuoc group', () {
    late MockEventBloc mockEventBloc;
    late MockLoadedGroupsBloc mockLoadedGroupsBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockEventBloc = MockEventBloc();
      mockLoadedGroupsBloc = MockLoadedGroupsBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockEventBloc.state).thenReturn(EventState());
      when(
        () => mockEventBloc.stream,
      ).thenAnswer((_) => const Stream<EventState>.empty());
      when(() => mockEventBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedGroupsBloc.state).thenReturn(
        const LoadedGroupsState(
          isLoading: false,
          groups: <GroupModel>[],
          page: 1,
          totalPage: 1,
          totalItems: 0,
        ),
      );
      when(
        () => mockLoadedGroupsBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedGroupsState>.empty());
      when(() => mockLoadedGroupsBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedGroupsBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        const LoadedUsersState(isLoading: false, users: <UserModel>[]),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given no available group, when opening add event page, then cannot add members and submit is disabled',
      (WidgetTester tester) async {
        // Given
        final router = buildAddEventRouter(
          eventBloc: mockEventBloc,
          groupsBloc: mockLoadedGroupsBloc,
          chooseMembersBloc: mockLoadedUsersBloc,
        );

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

        // When
        await tester.enterText(
          find.byKey(const Key('event_create_name_input')),
          'Event Without Group',
        );
        await tester.enterText(
          find.byKey(const Key('event_create_start_date_input')),
          '10/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('event_create_end_date_input')),
          '12/05/2026',
        );
        await tester.pumpAndSettle();

        // Then
        expect(
          find.byKey(const Key('event_create_add_members_button')),
          findsNothing,
        );

        final submitBtn = tester.widget<ElevatedButton>(
          find.byKey(const Key('event_create_submit_button')),
        );
        expect(submitBtn.onPressed, isNull);

        verifyNever(
          () =>
              mockEventBloc.add(any(that: isA<event_event.CreateEventEvent>())),
        );
      },
    );
  });

  group('event - Edit event info', () {
    late MockEventBloc mockEventBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockEventBloc = MockEventBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockEventBloc.state).thenReturn(
        EventLoadedState(
          event: EventModel(
            id: 'event-1',
            name: 'Old Event',
            description: 'Old Description',
            eventStart: DateTime(2026, 5, 10),
            eventEnd: DateTime(2026, 5, 12),
          ),
        ),
      );
      when(
        () => mockEventBloc.stream,
      ).thenAnswer((_) => const Stream<EventState>.empty());
      when(() => mockEventBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(id: 'member-old', fullName: 'Old Member'),
          ],
          page: 1,
          totalPage: 1,
          totalItems: 1,
        ),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given event setting page, when editing info and saving, then dispatch UpdateEventEvent',
      (WidgetTester tester) async {
        // Given
        final router = buildEventSettingRouter(
          eventBloc: mockEventBloc,
          usersBloc: mockLoadedUsersBloc,
        );

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
        drainImageExceptions(tester);

        // When
        await tester.enterText(
          find.byKey(const Key('event_setting_name_input')),
          'Updated Event',
        );
        await tester.enterText(
          find.byKey(const Key('event_setting_description_input')),
          'Updated Description',
        );
        await tester.enterText(
          find.byKey(const Key('event_setting_start_date_input')),
          '15/05/2026',
        );
        await tester.enterText(
          find.byKey(const Key('event_setting_end_date_input')),
          '18/05/2026',
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(tester, const Key('event_setting_save_button'));
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockEventBloc.add(
            any(
              that: isA<event_event.UpdateEventEvent>().having(
                (event_event.UpdateEventEvent e) => e.eventId,
                'eventId',
                'event-1',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('event - Add member vao event', () {
    late MockEventBloc mockEventBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;
    late MockLoadedUsersBloc mockChooseMembersBloc;

    setUp(() {
      mockEventBloc = MockEventBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();
      mockChooseMembersBloc = MockLoadedUsersBloc();

      when(() => mockEventBloc.state).thenReturn(
        EventLoadedState(
          event: EventModel(
            id: 'event-1',
            name: 'Event 1',
            description: 'Event Desc',
            eventStart: DateTime(2026, 5, 10),
            eventEnd: DateTime(2026, 5, 12),
          ),
        ),
      );
      when(
        () => mockEventBloc.stream,
      ).thenAnswer((_) => const Stream<EventState>.empty());
      when(() => mockEventBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(id: 'member-old', fullName: 'Old Member'),
          ],
          page: 1,
          totalPage: 1,
          totalItems: 1,
        ),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});

      when(() => mockChooseMembersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(id: 'member-old', fullName: 'Old Member'),
            UserModel(id: 'member-new', fullName: 'New Member'),
          ],
          page: 1,
          totalPage: 1,
          totalItems: 2,
        ),
      );
      when(
        () => mockChooseMembersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockChooseMembersBloc.add(any())).thenAnswer((_) {});
      when(() => mockChooseMembersBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given event setting page, when selecting new member and save invite, then dispatch AddMembersToEvent',
      (WidgetTester tester) async {
        // Given
        final router = buildEventSettingRouter(
          eventBloc: mockEventBloc,
          usersBloc: mockLoadedUsersBloc,
          chooseMembersBloc: mockChooseMembersBloc,
        );

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
        drainImageExceptions(tester);

        // When
        triggerElevatedButton(
          tester,
          const Key('event_setting_invite_group_members_button'),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('choose_member_select_member-new'),
        );
        await tester.pumpAndSettle();

        router.pop();
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('event_setting_invite_save_button'),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockEventBloc.add(
            any(
              that: isA<event_event.AddMembersToEvent>()
                  .having(
                    (event_event.AddMembersToEvent e) => e.eventId,
                    'eventId',
                    'event-1',
                  )
                  .having(
                    (event_event.AddMembersToEvent e) => e.memberIds,
                    'memberIds',
                    contains('member-new'),
                  ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('event - Xoa event', () {
    late MockEventBloc mockEventBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockEventBloc = MockEventBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockEventBloc.state).thenReturn(
        EventLoadedState(
          event: EventModel(
            id: 'event-1',
            name: 'Event To Delete',
            description: 'Delete me',
            eventStart: DateTime(2026, 5, 10),
            eventEnd: DateTime(2026, 5, 12),
          ),
        ),
      );
      when(
        () => mockEventBloc.stream,
      ).thenAnswer((_) => const Stream<EventState>.empty());
      when(() => mockEventBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        const LoadedUsersState(isLoading: false, users: <UserModel>[]),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedUsersBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given event setting page, when tap delete, then dispatch DeleteEventEvent',
      (WidgetTester tester) async {
        // Given
        final router = buildEventSettingRouter(
          eventBloc: mockEventBloc,
          usersBloc: mockLoadedUsersBloc,
        );

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

        // When
        await tester.ensureVisible(
          find.byKey(const Key('event_setting_delete_button')),
        );
        await tester.pumpAndSettle();
        triggerElevatedButton(tester, const Key('event_setting_delete_button'));
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockEventBloc.add(
            any(
              that: isA<event_event.DeleteEventEvent>().having(
                (event_event.DeleteEventEvent e) => e.eventId,
                'eventId',
                'event-1',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('event - Load danh sach event dung', () {
    late MockEventDataBloc mockEventDataBloc;
    EventModel? selectedEvent;

    setUp(() {
      mockEventDataBloc = MockEventDataBloc();
      selectedEvent = null;

      when(() => mockEventDataBloc.state).thenReturn(
        EventDataState(
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 1,
          groups: <GroupModel>[
            GroupModel(
              id: 'group-1',
              name: 'Trip Group',
              events: <EventModel>[
                EventModel(
                  id: 'event-1',
                  name: 'Trip Event',
                  description: 'Trip details',
                  eventStart: DateTime(2026, 5, 10),
                  eventEnd: DateTime(2026, 5, 12),
                ),
              ],
            ),
          ],
        ),
      );
      when(
        () => mockEventDataBloc.stream,
      ).thenAnswer((_) => const Stream<EventDataState>.empty());
      when(() => mockEventDataBloc.add(any())).thenAnswer((_) {});
      when(() => mockEventDataBloc.close()).thenAnswer((_) async {});
    });

    testWidgets(
      'Given choose event page, when expand group and select event, then callback receives selected event',
      (WidgetTester tester) async {
        // Given
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<EventDataBloc>.value(
              value: mockEventDataBloc,
              child: ChooseEventPage(
                initialSelectedEvent: null,
                onSelectedEventChanged: (EventModel event) {
                  selectedEvent = event;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(
          find.byKey(const Key('choose_event_search_input')),
          'trip',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('choose_event_search_button')));
        await tester.pumpAndSettle();

        final groupCard = tester.widget<InfoCard>(
          find.byKey(const Key('choose_event_group_group-1')),
        );
        expect(groupCard.onTap, isNotNull);
        groupCard.onTap!.call();
        await tester.pumpAndSettle();

        final eventCard = tester.widget<ContentCard>(
          find.byKey(const Key('choose_event_item_event-1')),
        );
        expect(eventCard.onTap, isNotNull);
        eventCard.onTap!.call();
        await tester.pumpAndSettle();

        // Then
        expect(selectedEvent?.id, 'event-1');
        verify(
          () =>
              mockEventDataBloc.add(any(that: isA<event_event.InitialEvent>())),
        ).called(greaterThan(0));
      },
    );
  });
}
