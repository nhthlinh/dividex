import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/friend/presentation/friend_card.dart';
import 'package:Dividex/features/search/presentation/bloc/search_users_bloc.dart'
    as search_bloc;
import 'package:Dividex/features/search/presentation/pages/search_user_page.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchUsersBloc extends Mock implements search_bloc.SearchUsersBloc {}

class MockFriendBloc extends Mock implements FriendBloc {}

class FakeLoadFriendEvent extends Fake implements LoadFriendEvent {}

class FakeFriendEvent extends Fake implements FriendEvent {}

void _drainImageExceptions(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(FakeLoadFriendEvent());
    registerFallbackValue(FakeFriendEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'me-friend-1',
        email: 'me@dividex.test',
        fullName: 'Current User',
        avatarUrl: null,
      ),
    );
  });

  group('FRIEND - Tim user theo email, ten thanh cong', () {
    late MockSearchUsersBloc mockSearchBloc;

    setUp(() {
      mockSearchBloc = MockSearchUsersBloc();

      when(() => mockSearchBloc.state).thenReturn(
        LoadedFriendsState(
          isLoading: false,
          requests: <FriendModel>[
            FriendModel(
              friendUid: 'friend-alice',
              fullName: 'Alice Nguyen',
              status: FriendStatus.none,
            ),
          ],
          page: 1,
          totalPage: 1,
          totalItems: 1,
        ),
      );
      when(
        () => mockSearchBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedFriendsState>.empty());
      when(() => mockSearchBloc.close()).thenAnswer((_) async {});
      when(() => mockSearchBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given search page, when search by email/name, then show user result',
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
            home: BlocProvider<search_bloc.SearchUsersBloc>.value(
              value: mockSearchBloc,
              child: const SearchUserPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(
          find.byKey(const Key('friend_search_input')),
          'alice@dividex.test',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('friend_search_button')));
        await tester.pumpAndSettle();

        // Then
        expect(
          find.byKey(const Key('friend_card_friend-alice')),
          findsOneWidget,
        );
      },
    );
  });

  group('FRIEND - Khong tim thay user', () {
    late MockSearchUsersBloc mockSearchBloc;

    setUp(() {
      mockSearchBloc = MockSearchUsersBloc();

      when(() => mockSearchBloc.state).thenReturn(
        const LoadedFriendsState(isLoading: false, requests: <FriendModel>[]),
      );
      when(
        () => mockSearchBloc.stream,
      ).thenAnswer((_) => const Stream<LoadedFriendsState>.empty());
      when(() => mockSearchBloc.close()).thenAnswer((_) async {});
      when(() => mockSearchBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given no matched user, when searching, then show User not found state',
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
            home: BlocProvider<search_bloc.SearchUsersBloc>.value(
              value: mockSearchBloc,
              child: const SearchUserPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(
          find.byKey(const Key('friend_search_input')),
          'missing@dividex.test',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('friend_search_button')));
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(const Key('friend_not_found_text')), findsOneWidget);
      },
    );
  });

  group('FRIEND - Gui request ket ban thanh cong', () {
    late MockFriendBloc mockFriendBloc;

    setUp(() {
      mockFriendBloc = MockFriendBloc();
      when(() => mockFriendBloc.state).thenReturn(const FriendState());
      when(
        () => mockFriendBloc.stream,
      ).thenAnswer((_) => const Stream<FriendState>.empty());
      when(() => mockFriendBloc.close()).thenAnswer((_) async {});
      when(() => mockFriendBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given a searchable user, when send friend request, then dispatch SendFriendRequestEvent',
      (WidgetTester tester) async {
        // Given
        const friendUid = 'friend-send-1';

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: BlocProvider<FriendBloc>.value(
                value: mockFriendBloc,
                child: FriendCard(
                  isSearchPage: true,
                  type: FriendCardType.none,
                  friend: FriendModel(
                    friendUid: friendUid,
                    fullName: 'Send Request User',
                    status: FriendStatus.none,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        // When
        await tester.tap(
          find.byKey(const Key('friend_add_button_friend-send-1')),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        await tester.enterText(
          find.byKey(const Key('friend_request_message_input_friend-send-1')),
          'Hi, lets connect',
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        await tester.tap(
          find.byKey(const Key('friend_send_button_friend-send-1')),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        // Then
        verify(
          () => mockFriendBloc.add(
            any(
              that: isA<SendFriendRequestEvent>().having(
                (SendFriendRequestEvent e) => e.friendId,
                'friendId',
                friendUid,
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('FRIEND - Khong gui request khi message rong', () {
    late MockFriendBloc mockFriendBloc;

    setUp(() {
      mockFriendBloc = MockFriendBloc();
      when(() => mockFriendBloc.state).thenReturn(const FriendState());
      when(
        () => mockFriendBloc.stream,
      ).thenAnswer((_) => const Stream<FriendState>.empty());
      when(() => mockFriendBloc.close()).thenAnswer((_) async {});
      when(() => mockFriendBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given friend request dialog, when message is empty, then send button is disabled and no event',
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
            home: Scaffold(
              body: BlocProvider<FriendBloc>.value(
                value: mockFriendBloc,
                child: FriendCard(
                  isSearchPage: true,
                  type: FriendCardType.none,
                  friend: FriendModel(
                    friendUid: 'friend-empty-message-1',
                    fullName: 'Empty Message User',
                    status: FriendStatus.none,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        // When
        await tester.tap(
          find.byKey(const Key('friend_add_button_friend-empty-message-1')),
        );
        await tester.pumpAndSettle();

        final sendBtnFinder = find.byKey(
          const Key('friend_send_button_friend-empty-message-1'),
        );

        // Then
        expect(sendBtnFinder, findsOneWidget);
        final sendBtnWidget = tester.widget<ElevatedButton>(sendBtnFinder);
        expect(sendBtnWidget.onPressed, isNull);
        verifyNever(
          () => mockFriendBloc.add(any(that: isA<SendFriendRequestEvent>())),
        );
      },
    );
  });

  group('FRIEND - Khong gui request neu da la ban', () {
    late MockFriendBloc mockFriendBloc;

    setUp(() {
      mockFriendBloc = MockFriendBloc();
      when(() => mockFriendBloc.state).thenReturn(const FriendState());
      when(
        () => mockFriendBloc.stream,
      ).thenAnswer((_) => const Stream<FriendState>.empty());
      when(() => mockFriendBloc.close()).thenAnswer((_) async {});
      when(() => mockFriendBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given already-friend user card, when viewing card, then cannot send friend request',
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
            home: Scaffold(
              body: BlocProvider<FriendBloc>.value(
                value: mockFriendBloc,
                child: FriendCard(
                  isSearchPage: true,
                  type: FriendCardType.acepted,
                  friend: FriendModel(
                    friendUid: 'friend-accepted-1',
                    fullName: 'Accepted User',
                    status: FriendStatus.accepted,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        // When
        final addBtn = find.byKey(
          const Key('friend_add_button_friend-accepted-1'),
        );

        // Then
        expect(addBtn, findsNothing);
        verifyNever(
          () => mockFriendBloc.add(any(that: isA<SendFriendRequestEvent>())),
        );
      },
    );
  });

  group('FRIEND - Accept request thanh ban', () {
    late MockFriendBloc mockFriendBloc;
    late ValueNotifier<FriendCardType> cardType;

    setUp(() {
      mockFriendBloc = MockFriendBloc();
      cardType = ValueNotifier<FriendCardType>(FriendCardType.response);

      when(() => mockFriendBloc.state).thenReturn(const FriendState());
      when(
        () => mockFriendBloc.stream,
      ).thenAnswer((_) => const Stream<FriendState>.empty());
      when(() => mockFriendBloc.close()).thenAnswer((_) async {});
      when(() => mockFriendBloc.add(any())).thenAnswer((Invocation invocation) {
        final event = invocation.positionalArguments.first as FriendEvent;
        if (event is AcceptFriendRequestEvent) {
          cardType.value = FriendCardType.acepted;
        }
      });
    });

    tearDown(() {
      cardType.dispose();
    });

    testWidgets(
      'Given received request, when accept, then become friend state',
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
            home: Scaffold(
              body: BlocProvider<FriendBloc>.value(
                value: mockFriendBloc,
                child: ValueListenableBuilder<FriendCardType>(
                  valueListenable: cardType,
                  builder: (BuildContext context, FriendCardType value, _) {
                    return FriendCard(
                      type: value,
                      friend: FriendModel(
                        friendUid: 'friend-response-1',
                        friendshipUid: 'friendship-response-1',
                        fullName: 'Response User',
                        status: FriendStatus.response,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.tap(
          find.byKey(const Key('friend_trailing_action_friend-response-1')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('friend_accept_button_friend-response-1')),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockFriendBloc.add(
            any(
              that: isA<AcceptFriendRequestEvent>().having(
                (AcceptFriendRequestEvent e) => e.friendId,
                'friendId',
                'friendship-response-1',
              ),
            ),
          ),
        ).called(1);
        expect(
          find.byKey(const Key('friend_status_accepted_friend-response-1')),
          findsOneWidget,
        );
      },
    );
  });

  group('FRIEND - Reject request khong thanh ban', () {
    late MockFriendBloc mockFriendBloc;
    late ValueNotifier<FriendCardType> cardType;

    setUp(() {
      mockFriendBloc = MockFriendBloc();
      cardType = ValueNotifier<FriendCardType>(FriendCardType.response);

      when(() => mockFriendBloc.state).thenReturn(const FriendState());
      when(
        () => mockFriendBloc.stream,
      ).thenAnswer((_) => const Stream<FriendState>.empty());
      when(() => mockFriendBloc.close()).thenAnswer((_) async {});
      when(() => mockFriendBloc.add(any())).thenAnswer((Invocation invocation) {
        final event = invocation.positionalArguments.first as FriendEvent;
        if (event is DeclineFriendRequestEvent) {
          cardType.value = FriendCardType.none;
        }
      });
    });

    tearDown(() {
      cardType.dispose();
    });

    testWidgets(
      'Given received request, when reject, then remain not-friend state',
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
            home: Scaffold(
              body: BlocProvider<FriendBloc>.value(
                value: mockFriendBloc,
                child: ValueListenableBuilder<FriendCardType>(
                  valueListenable: cardType,
                  builder: (BuildContext context, FriendCardType value, _) {
                    return FriendCard(
                      type: value,
                      friend: FriendModel(
                        friendUid: 'friend-reject-1',
                        friendshipUid: 'friendship-reject-1',
                        fullName: 'Reject User',
                        status: FriendStatus.response,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        // When
        await tester.tap(
          find.byKey(const Key('friend_trailing_action_friend-reject-1')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('friend_reject_button_friend-reject-1')),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockFriendBloc.add(
            any(
              that: isA<DeclineFriendRequestEvent>().having(
                (DeclineFriendRequestEvent e) => e.friendId,
                'friendId',
                'friendship-reject-1',
              ),
            ),
          ),
        ).called(1);
        expect(
          find.byKey(const Key('friend_add_button_friend-reject-1')),
          findsOneWidget,
        );
      },
    );
  });

  group('FRIEND - Khong accept reject khi friendshipUid null', () {
    late MockFriendBloc mockFriendBloc;

    setUp(() {
      mockFriendBloc = MockFriendBloc();
      when(() => mockFriendBloc.state).thenReturn(const FriendState());
      when(
        () => mockFriendBloc.stream,
      ).thenAnswer((_) => const Stream<FriendState>.empty());
      when(() => mockFriendBloc.close()).thenAnswer((_) async {});
      when(() => mockFriendBloc.add(any())).thenAnswer((_) {});
    });

    testWidgets(
      'Given response friend without friendshipUid, when accept and reject, then event uses empty id',
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
            home: Scaffold(
              body: BlocProvider<FriendBloc>.value(
                value: mockFriendBloc,
                child: FriendCard(
                  type: FriendCardType.response,
                  friend: FriendModel(
                    friendUid: 'friend-null-uid-1',
                    friendshipUid: null,
                    fullName: 'Null Uid User',
                    status: FriendStatus.response,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        _drainImageExceptions(tester);

        // When
        await tester.tap(
          find.byKey(const Key('friend_trailing_action_friend-null-uid-1')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('friend_accept_button_friend-null-uid-1')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('friend_trailing_action_friend-null-uid-1')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('friend_reject_button_friend-null-uid-1')),
        );
        await tester.pumpAndSettle();

        // Then
        verify(
          () => mockFriendBloc.add(
            any(
              that: isA<AcceptFriendRequestEvent>().having(
                (AcceptFriendRequestEvent e) => e.friendId,
                'friendId',
                '',
              ),
            ),
          ),
        ).called(1);

        verify(
          () => mockFriendBloc.add(
            any(
              that: isA<DeclineFriendRequestEvent>().having(
                (DeclineFriendRequestEvent e) => e.friendId,
                'friendId',
                '',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });
}
