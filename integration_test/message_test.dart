import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/presentation/bloc/chat_bloc.dart';
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

class MockChatBloc extends Mock implements ChatBloc {}

class MockLoadedMessageBloc extends Mock implements LoadedMessageBloc {}

class FakeChatEvent extends Fake implements ChatEvent {}

class FakeLoadMessageEvent extends Fake implements LoadMessageEvent {}

class MockChatService extends Mock implements ChatService {}

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

GoRouter buildChatRouter({
  required MockLoadedMessageBloc loadedMessageBloc,
  required MockChatBloc chatBloc,
  required MockChatService chatService,
}) {
  return GoRouter(
    initialLocation: '/chat-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/chat-test',
        builder: (BuildContext context, GoRouterState state) {
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
              child: const ChatPage(roomName: 'Test room', roomId: 'room-1'),
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
    registerFallbackValue(FakeChatEvent());
    registerFallbackValue(FakeLoadMessageEvent());
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

  group('Message_1 - Message feature integration tests', () {
    late MockChatBloc mockChatBloc;
    late MockLoadedMessageBloc mockLoadedMessageBloc;
    late MockChatService mockChatService;
    late ChatServiceTestHelper chatServiceHelper;
    late StreamController<LoadedMessageState> loadedMessageStateController;

    setUp(() {
      mockChatBloc = MockChatBloc();
      mockLoadedMessageBloc = MockLoadedMessageBloc();
      mockChatService = MockChatService();
      chatServiceHelper = ChatServiceTestHelper();
      loadedMessageStateController =
          StreamController<LoadedMessageState>.broadcast();

      when(
        () => mockLoadedMessageBloc.state,
      ).thenReturn(const LoadedMessageState());
      when(
        () => mockLoadedMessageBloc.stream,
      ).thenAnswer((_) => loadedMessageStateController.stream);
      when(() => mockLoadedMessageBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedMessageBloc.close()).thenAnswer((_) async {});

      when(
        () => mockChatService.events,
      ).thenAnswer((_) => chatServiceHelper.events);
      when(() => mockChatService.connected).thenReturn(true);
      when(() => mockChatService.connect()).thenAnswer((_) async {});
      when(() => mockChatService.disconnect()).thenAnswer((_) async {});
      when(() => mockChatService.sendTyping(any())).thenAnswer((_) {});
      when(() => mockChatService.dispose()).thenAnswer((_) {});
      when(() => mockChatService.sendMessageHttp(any())).thenAnswer((
        invocation,
      ) async {
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
          groupId: 'room-1',
        );
      });

      when(() => mockChatBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await loadedMessageStateController.close();
      chatServiceHelper.close();
    });

    testWidgets(
      'Given chat page with valid room, when sending a message, then service is called and message is displayed after receive',
      (WidgetTester tester) async {
        // Given
        const newMessage = 'Hello from integration test';
        final router = buildChatRouter(
          loadedMessageBloc: mockLoadedMessageBloc,
          chatBloc: mockChatBloc,
          chatService: mockChatService,
        );

        await pumpLocalizedRouter(tester, router);

        // Simulate initial empty message list
        loadedMessageStateController.add(
          const LoadedMessageState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 0,
            messages: [],
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(find.byType(TextField), newMessage);
        await tester.pumpAndSettle();

        final sendButton = find.byIcon(Icons.send).hitTestable();
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pump();

        // The send flow begins and should call the service.
        verify(() => mockChatService.sendMessageHttp(newMessage)).called(1);

        // Simulate server push for the newly sent message.
        chatServiceHelper.emitIncomingMessage(
          messageId: 'message-1',
          content: newMessage,
          userId: 'user-123',
          userName: 'Test User',
        );
        await tester.pumpAndSettle();

        // Then
        expect(find.text(newMessage), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      },
    );

    testWidgets(
      'Given incoming message events, when a message arrives, then it appears in the chat list',
      (WidgetTester tester) async {
        // Given
        const incomingMessage = 'Incoming from another user';
        final router = buildChatRouter(
          loadedMessageBloc: mockLoadedMessageBloc,
          chatBloc: mockChatBloc,
          chatService: mockChatService,
        );

        await pumpLocalizedRouter(tester, router);

        loadedMessageStateController.add(
          const LoadedMessageState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 0,
            messages: [],
          ),
        );
        await tester.pumpAndSettle();

        // When
        chatServiceHelper.emitIncomingMessage(
          messageId: 'message-2',
          content: incomingMessage,
          userId: 'other-user',
          userName: 'Other User',
        );
        await tester.pumpAndSettle();

        // Then
        expect(find.text(incomingMessage), findsOneWidget);
      },
    );

    testWidgets(
      'Given empty chat input, when tapping send, then do not call sendMessageHttp',
      (WidgetTester tester) async {
        // Given
        final router = buildChatRouter(
          loadedMessageBloc: mockLoadedMessageBloc,
          chatBloc: mockChatBloc,
          chatService: mockChatService,
        );

        await pumpLocalizedRouter(tester, router);
        loadedMessageStateController.add(
          const LoadedMessageState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 0,
            messages: [],
          ),
        );
        await tester.pumpAndSettle();

        // When
        final sendButton = find.byIcon(Icons.send).hitTestable();
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pumpAndSettle();

        // Then
        verifyNever(() => mockChatService.sendMessageHttp(any()));
      },
    );

    testWidgets(
      'Given network failure during send, when tapping send, then send button recovers and no new message is shown',
      (WidgetTester tester) async {
        // Given
        const messageText = 'Network error test';
        chatServiceHelper.shouldFailSend = true;
        final router = buildChatRouter(
          loadedMessageBloc: mockLoadedMessageBloc,
          chatBloc: mockChatBloc,
          chatService: mockChatService,
        );

        await pumpLocalizedRouter(tester, router);
        loadedMessageStateController.add(
          const LoadedMessageState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 0,
            messages: [],
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.enterText(find.byType(TextField), messageText);
        await tester.pumpAndSettle();

        final sendButton = find.byIcon(Icons.send).hitTestable();
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pump();

        verify(() => mockChatService.sendMessageHttp(messageText)).called(1);

        await tester.pumpAndSettle();

        // Then
        expect(find.text(messageText), findsNothing);
        expect(find.byIcon(Icons.send), findsOneWidget);
      },
    );
  });
}
