import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/group/presentation/pages/add_group_page.dart';
import 'package:Dividex/features/group/presentation/pages/group_setting.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/pages/choose_members_page.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupBloc extends Mock implements GroupBloc {}

class MockLoadedUsersBloc extends Mock implements LoadedUsersBloc {}

class FakeGroupsEvent extends Fake implements GroupsEvent {}

class FakeLoadUserEvent extends Fake implements LoadUserEvent {}

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

Future<void> pumpLocalized(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

GoRouter buildAddGroupRouter({
  required MockGroupBloc groupBloc,
  required MockLoadedUsersBloc usersBloc,
}) {
  return GoRouter(
    initialLocation: '/add-group-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/add-group-test',
        name: AppRouteNames.addGroup,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<GroupBloc>.value(
            value: groupBloc,
            child: const AddGroupPage(),
          );
        },
      ),
      GoRoute(
        path: '/choose-members-test',
        name: AppRouteNames.chooseMember,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider<LoadedUsersBloc>.value(
            value: usersBloc,
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
    ],
  );
}

GoRouter buildGroupSettingRouter({
  required MockGroupBloc groupBloc,
  required MockLoadedUsersBloc usersBloc,
  MockLoadedUsersBloc? chooseMembersBloc,
  required String groupLeaderId,
  required String groupName,
}) {
  return GoRouter(
    initialLocation: '/group-setting-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/group-setting-test',
        name: AppRouteNames.groupSetting,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<GroupBloc>.value(value: groupBloc),
              BlocProvider<LoadedUsersBloc>.value(value: usersBloc),
            ],
            child: GroupSettingPage(
              groupId: 'group-1',
              groupLeaderId: groupLeaderId,
              groupName: groupName,
              groupAvatarUrl: null,
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
    ],
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(FakeGroupsEvent());
    registerFallbackValue(FakeLoadUserEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'owner-1',
        email: 'owner@dividex.test',
        fullName: 'Group Owner',
        avatarUrl: null,
      ),
    );
  });

  group('group - Tao group thanh cong', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(
              id: 'member-1',
              fullName: 'Member One',
              email: 'm1@test.com',
            ),
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
    });

    testWidgets(
      'Given add group page, when valid name and member selected, then dispatch CreateGroupEvent',
      (WidgetTester tester) async {
        // Given
        final router = buildAddGroupRouter(
          groupBloc: mockGroupBloc,
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
        await tester.enterText(
          find.byKey(const Key('group_create_name_input')),
          'Trip Group',
        );
        await tester.pumpAndSettle();

        triggerCustomTextButton(
          tester,
          const Key('group_create_add_members_button'),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('choose_member_search_input')), findsOne);

        triggerElevatedButton(
          tester,
          const Key('choose_member_select_member-1'),
        );
        await tester.pumpAndSettle();

        router.pop();
        await tester.pumpAndSettle();

        final submitBtn = find.byKey(const Key('group_create_submit_button'));
        final submitBtnWidget = tester.widget<ElevatedButton>(submitBtn);
        expect(submitBtnWidget.onPressed, isNotNull);
        submitBtnWidget.onPressed!.call();
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockGroupBloc.add(
            any(
              that: isA<CreateGroupEvent>()
                  .having((CreateGroupEvent e) => e.name, 'name', 'Trip Group')
                  .having(
                    (CreateGroupEvent e) => e.memberIds,
                    'memberIds',
                    <String>['member-1'],
                  ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('group - Tao group fail khi khong nhap ten', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(
              id: 'member-1',
              fullName: 'Member One',
              email: 'm1@test.com',
            ),
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
    });

    testWidgets(
      'Given member selected but empty name, when checking submit button, then disabled and no create event',
      (WidgetTester tester) async {
        // Given
        final router = buildAddGroupRouter(
          groupBloc: mockGroupBloc,
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
        triggerCustomTextButton(
          tester,
          const Key('group_create_add_members_button'),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('choose_member_search_input')), findsOne);

        triggerElevatedButton(
          tester,
          const Key('choose_member_select_member-1'),
        );
        await tester.pumpAndSettle();
        router.pop();
        await tester.pumpAndSettle();

        // Then
        final submitBtn = find.byKey(const Key('group_create_submit_button'));
        final submitBtnWidget = tester.widget<ElevatedButton>(submitBtn);
        expect(submitBtnWidget.onPressed, isNull);
        verifyNever(
          () => mockGroupBloc.add(any(that: isA<CreateGroupEvent>())),
        );
      },
    );
  });

  group('group - Invite member thanh cong', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;
    late MockLoadedUsersBloc mockChooseMembersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();
      mockChooseMembersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(
              id: 'member-old',
              fullName: 'Old Member',
              email: 'old@test.com',
            ),
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

      when(() => mockChooseMembersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(
              id: 'member-old',
              fullName: 'Old Member',
              email: 'old@test.com',
            ),
            UserModel(
              id: 'member-new',
              fullName: 'New Member',
              email: 'new@test.com',
            ),
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
    });

    testWidgets(
      'Given owner group setting, when invite member and save, then dispatch UpdateGroupEvent with memberIdsAdd',
      (WidgetTester tester) async {
        // Given
        final router = buildGroupSettingRouter(
          groupBloc: mockGroupBloc,
          usersBloc: mockLoadedUsersBloc,
          chooseMembersBloc: mockChooseMembersBloc,
          groupLeaderId: 'owner-1',
          groupName: 'Team Group',
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
          const Key('group_setting_invite_friends_button'),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('choose_member_search_input')), findsOne);

        triggerElevatedButton(
          tester,
          const Key('choose_member_select_member-new'),
        );
        await tester.pumpAndSettle();

        router.pop();
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('group_setting_invite_save_button'),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockGroupBloc.add(
            any(
              that: isA<UpdateGroupEvent>().having(
                (UpdateGroupEvent e) => e.memberIdsAdd,
                'memberIdsAdd',
                contains('member-new'),
              ),
            ),
          ),
        ).called(greaterThan(0));
      },
    );
  });

  group('group - Remove member khoi group', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        LoadedUsersState(
          isLoading: false,
          users: <UserModel>[
            UserModel(
              id: 'member-remove',
              fullName: 'Remove Me',
              email: 'rm@test.com',
            ),
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
    });

    testWidgets(
      'Given owner setting page, when select member and confirm remove, then dispatch UpdateGroupEvent with memberIdsRemove',
      (WidgetTester tester) async {
        // Given
        final router = buildGroupSettingRouter(
          groupBloc: mockGroupBloc,
          usersBloc: mockLoadedUsersBloc,
          groupLeaderId: 'owner-1',
          groupName: 'Team Group',
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
        final memberToRemove = find.byKey(
          const ValueKey<String?>('member-remove'),
        );
        expect(memberToRemove, findsOneWidget);
        final memberWidget = tester.widget<SquareIconUser>(memberToRemove);
        expect(memberWidget.onTap, isNotNull);
        memberWidget.onTap!.call();
        await tester.pumpAndSettle();

        await tester.ensureVisible(
          find.byKey(const Key('group_setting_owner_save_button')),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('group_setting_owner_save_button'),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('group_setting_confirm_remove_member_button'),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockGroupBloc.add(
            any(
              that: isA<UpdateGroupEvent>().having(
                (UpdateGroupEvent e) => e.memberIdsRemove,
                'memberIdsRemove',
                contains('member-remove'),
              ),
            ),
          ),
        ).called(greaterThan(0));
      },
    );
  });

  group('group - Update group info', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        const LoadedUsersState(
          isLoading: false,
          users: <UserModel>[],
          page: 1,
          totalPage: 1,
          totalItems: 0,
        ),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given owner setting page, when edit group name and save, then dispatch UpdateGroupEvent with new name',
      (WidgetTester tester) async {
        // Given
        await pumpLocalized(
          tester,
          MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<GroupBloc>.value(value: mockGroupBloc),
              BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
            ],
            child: const GroupSettingPage(
              groupId: 'group-1',
              groupLeaderId: 'owner-1',
              groupName: 'Old Name',
              groupAvatarUrl: null,
            ),
          ),
        );

        // When
        await tester.enterText(
          find.byKey(const Key('group_setting_name_input')),
          'Updated Name',
        );
        await tester.pumpAndSettle();

        await tester.ensureVisible(
          find.byKey(const Key('group_setting_owner_save_button')),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('group_setting_owner_save_button'),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockGroupBloc.add(
            any(
              that: isA<UpdateGroupEvent>()
                  .having(
                    (UpdateGroupEvent e) => e.name,
                    'name',
                    'Updated Name',
                  )
                  .having(
                    (UpdateGroupEvent e) => e.memberIdsAdd,
                    'memberIdsAdd',
                    isEmpty,
                  )
                  .having(
                    (UpdateGroupEvent e) => e.memberIdsRemove,
                    'memberIdsRemove',
                    isEmpty,
                  ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('group - Non-owner khong duoc edit group', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        const LoadedUsersState(isLoading: false, users: <UserModel>[]),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given non-owner setting page, then owner edit controls are hidden',
      (WidgetTester tester) async {
        // Given
        await pumpLocalized(
          tester,
          MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<GroupBloc>.value(value: mockGroupBloc),
              BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
            ],
            child: const GroupSettingPage(
              groupId: 'group-1',
              groupLeaderId: 'another-user',
              groupName: 'Team Group',
              groupAvatarUrl: null,
            ),
          ),
        );

        // When
        final ownerSave = find.byKey(
          const Key('group_setting_owner_save_button'),
        );
        final dissolve = find.byKey(const Key('group_setting_dissolve_button'));
        final editName = find.byKey(const Key('group_setting_name_input'));

        // Then
        expect(ownerSave, findsNothing);
        expect(dissolve, findsNothing);
        expect(editName, findsNothing);
      },
    );
  });

  group('group - Owner co the dissolve group', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        const LoadedUsersState(isLoading: false, users: <UserModel>[]),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given owner setting page, when tap dissolve, then dispatch DeleteGroupEvent',
      (WidgetTester tester) async {
        // Given
        await pumpLocalized(
          tester,
          MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<GroupBloc>.value(value: mockGroupBloc),
              BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
            ],
            child: const GroupSettingPage(
              groupId: 'group-1',
              groupLeaderId: 'owner-1',
              groupName: 'Team Group',
              groupAvatarUrl: null,
            ),
          ),
        );

        // When
        await tester.ensureVisible(
          find.byKey(const Key('group_setting_dissolve_button')),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(
          tester,
          const Key('group_setting_dissolve_button'),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockGroupBloc.add(
            any(
              that: isA<DeleteGroupEvent>().having(
                (DeleteGroupEvent e) => e.groupId,
                'groupId',
                'group-1',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('group - User roi group thanh cong', () {
    late MockGroupBloc mockGroupBloc;
    late MockLoadedUsersBloc mockLoadedUsersBloc;

    setUp(() {
      mockGroupBloc = MockGroupBloc();
      mockLoadedUsersBloc = MockLoadedUsersBloc();

      when(() => mockGroupBloc.state).thenReturn(const GroupState());
      when(
        () => mockGroupBloc.stream,
      ).thenAnswer((_) => const Stream<GroupState>.empty());
      when(() => mockGroupBloc.add(any())).thenAnswer((_) {});

      when(() => mockLoadedUsersBloc.state).thenReturn(
        const LoadedUsersState(isLoading: false, users: <UserModel>[]),
      );
      when(
        () => mockLoadedUsersBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedUsersState>.empty());
      when(() => mockLoadedUsersBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given group setting page, when tap leave, then dispatch LeaveGroupEvent',
      (WidgetTester tester) async {
        // Given
        await pumpLocalized(
          tester,
          MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<GroupBloc>.value(value: mockGroupBloc),
              BlocProvider<LoadedUsersBloc>.value(value: mockLoadedUsersBloc),
            ],
            child: const GroupSettingPage(
              groupId: 'group-1',
              groupLeaderId: 'owner-1',
              groupName: 'Team Group',
              groupAvatarUrl: null,
            ),
          ),
        );

        // When
        await tester.ensureVisible(
          find.byKey(const Key('group_setting_leave_button')),
        );
        await tester.pumpAndSettle();

        triggerElevatedButton(tester, const Key('group_setting_leave_button'));
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockGroupBloc.add(
            any(
              that: isA<LeaveGroupEvent>().having(
                (LeaveGroupEvent e) => e.groupId,
                'groupId',
                'group-1',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });
}
