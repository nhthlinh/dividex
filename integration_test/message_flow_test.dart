import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/presentation/bloc/chat_bloc.dart';
import 'package:Dividex/features/message/presentation/pages/chat_all_page.dart';
import 'package:Dividex/features/message/presentation/pages/chat_page.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockLoadedGroupsBloc extends Mock implements LoadedGroupsBloc {}

class MockLoadedMessageBloc extends Mock implements LoadedMessageBloc {}

class MockChatBloc extends Mock implements ChatBloc {}

class MockChatService extends Mock implements ChatService {}

class FakeLoadGroupsEvent extends Fake implements LoadGroupsEvent {}

class FakeLoadMessageEvent extends Fake implements LoadMessageEvent {}

class FakeChatEvent extends Fake implements ChatEvent {}

class ChatServiceTestHelper {
  final StreamController<Map<String, dynamic>> eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool shouldFailSend = false;

  Stream<Map<String, dynamic>> get events => eventController.stream;

  void emitIncomingMessage({
    required String messageId,
    required String content,
    required String userId,
    required String userName,
  }) {
    eventController.add({
      'type': 'message',
      'id': messageId,
      'content': content,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'user': {
        'uid': userId,
        'email': '$userId@dividex.test',
        'full_name': userName,
      },
    });
  }

  void close() {
    if (!eventController.isClosed) {
      eventController.close();
    }
  }
}

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

GoRouter buildMessageFlowRouter({
  required LoadedGroupsBloc loadedGroupsBloc,
  required LoadedMessageBloc loadedMessageBloc,
  required ChatBloc chatBloc,
  required ChatService chatService,
}) {
  return GoRouter(
    initialLocation: '/chat-all',
    routes: <GoRoute>[
      GoRoute(
        path: '/chat-all',
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<LoadedGroupsBloc>.value(value: loadedGroupsBloc),
            ],
            child: const ChatAllPage(),
          );
        },
      ),
      GoRoute(
        path: '/chat/:groupId',
        name: AppRouteNames.chatInGroup,
        builder: (BuildContext context, GoRouterState state) {
          final groupId = state.pathParameters['groupId'] ?? '';
          final groupName = (state.extra as Map<String, dynamic>?)?['groupName'] ?? '';

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ChatProvider>(
                create: (_) => ChatProvider(service: chatService),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<LoadedMessageBloc>.value(value: loadedMessageBloc),
                BlocProvider<ChatBloc>.value(value: chatBloc),
              ],
              child: ChatPage(roomName: groupName, roomId: groupId),
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
    registerFallbackValue(FakeLoadGroupsEvent());
    registerFallbackValue(FakeLoadMessageEvent());
    registerFallbackValue(FakeChatEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: 'user-123',
        email: 'test.user@dividex.test',
        fullName: 'Test User',
        avatarUrl: null,
      ),
    );
  });

  group('Message flow - group to chat integration', () {
    late MockLoadedGroupsBloc mockLoadedGroupsBloc;
    late MockLoadedMessageBloc mockLoadedMessageBloc;
    late MockChatBloc mockChatBloc;
    late MockChatService mockChatService;
    late ChatServiceTestHelper chatServiceHelper;
    late StreamController<LoadedGroupsState> loadedGroupsController;
    late StreamController<LoadedMessageState> loadedMessageController;

    setUp(() {
      mockLoadedGroupsBloc = MockLoadedGroupsBloc();
      mockLoadedMessageBloc = MockLoadedMessageBloc();
      mockChatBloc = MockChatBloc();
      mockChatService = MockChatService();
      chatServiceHelper = ChatServiceTestHelper();
      loadedGroupsController = StreamController<LoadedGroupsState>.broadcast();
      loadedMessageController = StreamController<LoadedMessageState>.broadcast();

      when(() => mockLoadedGroupsBloc.state).thenReturn(
        const LoadedGroupsState(
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 1,
          groups: [],
        ),
      );
      when(() => mockLoadedGroupsBloc.stream)
          .thenAnswer((_) => loadedGroupsController.stream);
      when(() => mockLoadedGroupsBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedGroupsBloc.close()).thenAnswer((_) async {});

      when(() => mockLoadedMessageBloc.state)
          .thenReturn(const LoadedMessageState());
      when(() => mockLoadedMessageBloc.stream)
          .thenAnswer((_) => loadedMessageController.stream);
      when(() => mockLoadedMessageBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedMessageBloc.close()).thenAnswer((_) async {});

      when(() => mockChatService.events).thenAnswer((_) => chatServiceHelper.events);
      when(() => mockChatService.connected).thenReturn(true);
      when(() => mockChatService.connect()).thenAnswer((_) async {});
      when(() => mockChatService.disconnect()).thenAnswer((_) async {});
      when(() => mockChatService.sendTyping(any())).thenAnswer((_) {});
      when(() => mockChatService.dispose()).thenAnswer((_) {});
      when(() => mockChatService.sendMessageHttp(any())).thenAnswer(
        (invocation) async {
          final text = invocation.positionalArguments[0] as String;
          if (chatServiceHelper.shouldFailSend) {
            throw Exception('Simulated network failure');
          }
          return Message(
            id: 'sent-${DateTime.now().millisecondsSinceEpoch}',
            content: text,
            createdAt: DateTime.now().toUtc(),
            user: UserModel(
              id: 'user-123',
              fullName: 'Test User',
              email: 'test.user@dividex.test',
            ),
            type: 'message',
            groupId: 'group-1',
          );
        },
      );

      when(() => mockChatBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await loadedGroupsController.close();
      await loadedMessageController.close();
      chatServiceHelper.close();
    });

    testWidgets(
      'Given group list, when selecting a group and sending a message, then editing and deleting it should update the chat',
      (WidgetTester tester) async {
        final router = buildMessageFlowRouter(
          loadedGroupsBloc: mockLoadedGroupsBloc,
          loadedMessageBloc: mockLoadedMessageBloc,
          chatBloc: mockChatBloc,
          chatService: mockChatService,
        );

        await pumpLocalizedRouter(tester, router);

        loadedGroupsController.add(
          LoadedGroupsState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            groups: [GroupModel(id: 'group-1', name: 'Test Group')],
          ),
        );
        await tester.pumpAndSettle();

        // Given group list displayed
        final groupCard = find.byKey(ChatAllPage.groupCardKey('group-1'));
        expect(groupCard, findsOneWidget);

        // When selecting the group
        await tester.tap(groupCard);
        await tester.pumpAndSettle();

        expect(find.text('Test Group 🟢'), findsOneWidget);

        const originalMessage = 'Hello from group flow';
        await tester.enterText(find.byKey(ChatPage.messageInputKey), originalMessage);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(ChatPage.sendButtonKey));
        await tester.pump();

        verify(() => mockChatService.sendMessageHttp(originalMessage)).called(1);

        chatServiceHelper.emitIncomingMessage(
          messageId: 'message-1',
          content: originalMessage,
          userId: 'user-123',
          userName: 'Test User',
        );
        await tester.pumpAndSettle();

        expect(find.byKey(ChatPage.messageBubbleKey('message-1')), findsOneWidget);
        expect(find.text(originalMessage), findsOneWidget);

        // When editing the message
        await tester.tap(find.byKey(ChatPage.messageBubbleKey('message-1')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(ChatPage.messageEditOptionKey('message-1')));
        await tester.pumpAndSettle();

        const updatedMessage = 'Updated group message';
        await tester.enterText(find.byKey(ChatPage.editTextFieldKey), updatedMessage);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(ChatPage.editAcceptButtonKey));
        await tester.pumpAndSettle();

        expect(find.text(updatedMessage), findsOneWidget);
        expect(find.text(originalMessage), findsNothing);

        // When deleting the message
        await tester.tap(find.byKey(ChatPage.messageBubbleKey('message-1')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(ChatPage.messageDeleteOptionKey('message-1')));
        await tester.pumpAndSettle();

        final deletedMessageText =
            AppLocalizations.of(tester.element(find.byType(MaterialApp)))!
                .messageDeleted;
        expect(find.text(deletedMessageText), findsOneWidget);
        expect(find.text(updatedMessage), findsNothing);
      },
    );
  });
}