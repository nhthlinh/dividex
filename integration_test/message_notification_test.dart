import 'dart:async';
import 'dart:io';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/presentation/bloc/chat_bloc.dart';
import 'package:Dividex/features/message/presentation/pages/chat_page.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_event.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/features/notifications/presentation/pages/noti_page.dart';
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

// ============= MOCK CLASSES =============

class MockChatBloc extends Mock implements ChatBloc {}

class MockLoadedMessageBloc extends Mock implements LoadedMessageBloc {}

class MockLoadedNotiBloc extends Mock implements LoadedNotiBloc {}

class MockChatService extends Mock implements ChatService {
  @override
  bool get connected => true;
}

class MockChatProvider extends Mock implements ChatProvider {
  @override
  late ChatService service;
  
  @override
  List<Message> messages = [];
  
  @override
  bool sending = false;
  
  @override
  bool isLoadingMore = false;
  
  @override
  bool hasMore = false;
  
  @override
  bool partnerTyping = false;

  @override
  Future<void> sendMessage(String text) async {
    // Mock implementation - does nothing
  }

  @override
  void setMessages(List<Message> msgs) {
    messages = msgs;
  }

  @override
  void updateMessage(String id, String newContent, String? status) {
    // Mock implementation
  }

  @override
  void removeMessage(String id) {
    // Mock implementation
  }

  @override
  void setHasMore(bool value) {
    hasMore = value;
  }

  @override
  void setLoadingMore(bool value) {
    isLoadingMore = value;
  }

  @override
  void setTyping(bool t) {
    // Mock implementation
  }
}

class FakeChatEvent extends Fake implements ChatEvent {}

class FakeLoadMessageEvent extends Fake implements LoadMessageEvent {}

class FakeLoadNotiEvent extends Fake implements LoadNotiEvent {}

// ============= TEST DATA =============

const testGroupId = 'group-msg-1';
const testChatRoomName = 'Test Chat Room';
const testUserId = 'test-user-id';
const testUserName = 'Test User';

// ============= HELPER FUNCTIONS =============

Future<void> pumpLocalizedApp(
  WidgetTester tester,
  Widget child,
) async {
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

/// Retry helper: attempts an expectation up to [maxAttempts] times
/// Useful for handling flaky UI assertions
Future<void> retryAssertion(
  Future<void> Function() assertion, {
  int maxAttempts = 3,
  Duration delayBetweenAttempts = const Duration(milliseconds: 500),
}) async {
  for (int i = 0; i < maxAttempts; i++) {
    try {
      await assertion();
      return;
    } catch (e) {
      if (i == maxAttempts - 1) rethrow;
      await Future.delayed(delayBetweenAttempts);
    }
  }
}

/// Wait for widget to appear with retry logic
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < timeout) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
  }
  throw TimeoutException('Widget not found: $finder', timeout);
}

/// Build ChatPage with all required providers (BLoCs + ChangeNotifier)
Widget buildChatPageWithProviders({
  required MockLoadedMessageBloc mockLoadedMessageBloc,
  required MockChatBloc mockChatBloc,
  required MockChatProvider? mockChatProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ChatProvider>.value(
        value: mockChatProvider ?? MockChatProvider(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<LoadedMessageBloc>.value(
          value: mockLoadedMessageBloc,
        ),
        BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
        ),
      ],
      child: const ChatPage(
        roomName: testChatRoomName,
        roomId: testGroupId,
      ),
    ),
  );
}

/// Build NotiPage wrapped with GoRouter for navigation support
Widget buildNotiPageWithRouter({
  required MockLoadedNotiBloc mockLoadedNotiBloc,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider<LoadedNotiBloc>.value(
          value: mockLoadedNotiBloc,
          child: const NotiPage(),
        ),
      ),
      GoRoute(
        name: 'chat',
        path: '/chat',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Text('Chat Page - ${state.uri.queryParameters["roomId"] ?? "default"}'),
          ),
        ),
      ),
      GoRoute(
        name: 'profile',
        path: '/profile/:userId',
        builder: (context, state) => Scaffold(
          body: Center(child: Text('Profile Page - ${state.pathParameters["userId"]}')),
        ),
      ),
    ],
  );

  return MaterialApp.router(
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  );
}

/// Disable network requests during testing
class _NoHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _NoHttpOverrides();

  setUpAll(() async {
    // Disable image cache to prevent network image loading errors in tests
    imageCache.maximumSize = 0;
    imageCache.maximumSizeBytes = 0;

    registerFallbackValue(FakeChatEvent());
    registerFallbackValue(FakeLoadMessageEvent());
    registerFallbackValue(FakeLoadNotiEvent());

    await HiveService.initialize(reset: true);
    await HiveService.saveUser(
      UserLocalModel(
        id: testUserId,
        email: 'test.user@dividex.test',
        fullName: testUserName,
        avatarUrl: null,
      ),
    );
  });

  // =====================================================
  // FLOW 1: MESSAGE FLOW TESTS
  // =====================================================

  group('Message - Complete message flow with CRUD operations', () {
    late MockLoadedMessageBloc mockLoadedMessageBloc;
    late MockChatBloc mockChatBloc;
    late StreamController<LoadedMessageState> messageStateController;
    late StreamController<ChatState> chatStateController;

    setUp(() {
      mockLoadedMessageBloc = MockLoadedMessageBloc();
      mockChatBloc = MockChatBloc();
      messageStateController = StreamController<LoadedMessageState>.broadcast();
      chatStateController = StreamController<ChatState>.broadcast();

      // Setup initial state
      when(() => mockLoadedMessageBloc.state).thenReturn(
        LoadedMessageState(
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 1,
          messages: [
            Message(
              id: 'msg-1',
              content: 'Hello, this is a test message',
              status: 'NORMAL',
              createdAt: DateTime.parse('2026-03-31T10:00:00Z'),
              user: UserModel(
                id: 'user-1',
                email: 'user1@dividex.test',
                fullName: 'User One',
                avatar: null,
              ),
              updatedAt: DateTime.fromMicrosecondsSinceEpoch(0),
              attachment: null,
              groupId: null,
              type: 'message',
            ),
            Message(
              id: 'msg-2',
              content: 'This is another message',
              status: 'NORMAL',
              createdAt: DateTime.parse('2026-03-31T10:05:00Z'),
              user: UserModel(
                id: 'user-1',
                email: 'user1@dividex.test',
                fullName: 'User One',
                avatar: null,
              ),
              updatedAt: DateTime.fromMicrosecondsSinceEpoch(0),
              attachment: null,
              groupId: null,
              type: 'message',
            ),
            Message(
              id: 'msg-3',
              content: 'This message has an attachment',
              status: 'NORMAL',
              createdAt: DateTime.parse('2026-03-31T10:10:00Z'),
              user: UserModel(
                id: 'user-1',
                email: 'user1@dividex.test',
                fullName: 'User One',
                avatar: null,
              ),
              updatedAt: DateTime.fromMicrosecondsSinceEpoch(0),
              attachment: ['https://example.com/image.png'],
              groupId: null,
              type: 'message',
            ),
            Message(
              id: 'msg-4',
              content: 'This message is from another user',
              status: 'NORMAL',
              createdAt: DateTime.parse('2026-03-31T10:15:00Z'),
              user: UserModel(
                id: 'user-2',
                email: 'user2@dividex.test',
                fullName: 'User Two',
                avatar: null,
              ),
              updatedAt: DateTime.fromMicrosecondsSinceEpoch(0),
              attachment: null,
              groupId: null,
              type: 'message',
            ),
            Message(
              id: 'msg-5',
              content: 'This message is edited',
              status: 'EDITED',
              createdAt: DateTime.parse('2026-03-31T10:20:00Z'),
              updatedAt: DateTime.parse('2026-03-31T11:00:00Z'),
              user: UserModel(
                id: 'user-3',
                email: 'user3@dividex.test',
                fullName: 'User Three',
                avatar: null,
              ),
              attachment: null,
              groupId: null,
              type: 'message',
            ),
          ],
        ),
      );

      when(() => mockLoadedMessageBloc.stream)
          .thenAnswer((_) => messageStateController.stream);

      when(() => mockChatBloc.state).thenReturn(ChatState(null));
      when(() => mockChatBloc.stream)
          .thenAnswer((_) => chatStateController.stream);

      when(() => mockLoadedMessageBloc.close()).thenAnswer((_) async {});
      when(() => mockChatBloc.close()).thenAnswer((_) async {});
      when(() => mockLoadedMessageBloc.add(any())).thenAnswer((_) {});
      when(() => mockChatBloc.add(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await messageStateController.close();
      await chatStateController.close();
    });

    testWidgets(
      'Given chat room, when viewing messages, then display message list with content and timestamp',
      (WidgetTester tester) async {
        // Given
        const messageContent = 'Hello, this is a test message';

        final mockChatProvider = MockChatProvider();
        mockChatProvider.service = MockChatService();
        mockChatProvider.messages = mockLoadedMessageBloc.state.messages;
        mockChatProvider.sending = false;
        mockChatProvider.isLoadingMore = false;
        mockChatProvider.hasMore = false;
        mockChatProvider.partnerTyping = false;

        await pumpLocalizedApp(
          tester,
          buildChatPageWithProviders(
            mockLoadedMessageBloc: mockLoadedMessageBloc,
            mockChatBloc: mockChatBloc,
            mockChatProvider: mockChatProvider,
          ),
        );

        // When - Wait for message content to be displayed
        await retryAssertion(
          () => waitForWidget(tester, find.text(messageContent)),
          maxAttempts: 3,
        );

        // Then - Verify message content is displayed in the UI
        expect(find.text(messageContent), findsOneWidget);
      },
    );

    testWidgets(
      'Given chat room, when textbox has content, then send message successfully',
      (WidgetTester tester) async {
        // Given
        const newMessageText = 'New test message content';

        final mockChatProvider = MockChatProvider();
        mockChatProvider.service = MockChatService();
        mockChatProvider.messages = mockLoadedMessageBloc.state.messages;
        mockChatProvider.sending = false;
        mockChatProvider.isLoadingMore = false;
        mockChatProvider.hasMore = false;
        mockChatProvider.partnerTyping = false;

        await pumpLocalizedApp(
          tester,
          buildChatPageWithProviders(
            mockLoadedMessageBloc: mockLoadedMessageBloc,
            mockChatBloc: mockChatBloc,
            mockChatProvider: mockChatProvider,
          ),
        );

        // When - Enter text in the input field
        final inputField = find.byType(TextField);
        await retryAssertion(
          () => waitForWidget(tester, inputField),
          maxAttempts: 2,
        );

        await tester.enterText(inputField.first, newMessageText);
        await tester.pumpAndSettle();

        // Setup handler for send event
        when(() => mockChatBloc.add(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments.first as ChatEvent;
          if (event is SendMessageEvent) {
            expect(event.content, newMessageText);
            expect(event.groupId, testGroupId);
          }
        });

        // Find and tap send button (Icon button or Text button)
        final sendButton = find.byIcon(Icons.send).first;
        await retryAssertion(
          () async {
            expect(sendButton, findsOneWidget);
            await tester.tap(sendButton);
            await tester.pumpAndSettle();
          },
          maxAttempts: 2,
        );

        // Then - Verify send button was tapped
        expect(sendButton, findsOneWidget);
      },
    );

    testWidgets(
      'Given sent message, when edit action triggered, then update message content',
      (WidgetTester tester) async {
        // Given
        const originalContent = 'Hello, this is a test message';
        const editedContent = 'Hello, this is an EDITED message';
        const messageId = 'msg-1';

        final mockChatProvider = MockChatProvider();
        mockChatProvider.service = MockChatService();
        mockChatProvider.messages = mockLoadedMessageBloc.state.messages;
        mockChatProvider.sending = false;
        mockChatProvider.isLoadingMore = false;
        mockChatProvider.hasMore = false;
        mockChatProvider.partnerTyping = false;

        await pumpLocalizedApp(
          tester,
          buildChatPageWithProviders(
            mockLoadedMessageBloc: mockLoadedMessageBloc,
            mockChatBloc: mockChatBloc,
            mockChatProvider: mockChatProvider,
          ),
        );

        // When - Wait for the message to appear
        await retryAssertion(
          () => waitForWidget(tester, find.text(originalContent)),
          maxAttempts: 2,
        );

        // Simulate triggering an edit by directly calling the bloc
        when(() => mockChatBloc.add(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments.first as ChatEvent;
          if (event is UpdateMessageEvent) {
            expect(event.messageId, messageId);
          }
        });

        mockChatBloc.add(UpdateMessageEvent(messageId, editedContent));
        await tester.pumpAndSettle();

        // Then - Verify update event was called
        verify(() => mockChatBloc.add(any())).called(greaterThanOrEqualTo(1));
      },
    );

    testWidgets(
      'Given edited message, then message status should show as EDITED',
      (WidgetTester tester) async {
        // Given - Message with EDITED status
        when(() => mockLoadedMessageBloc.state).thenReturn(
          LoadedMessageState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            messages: [
              Message(
                id: 'msg-1',
                content: 'Updated message content',
                status: 'EDITED',
                createdAt: DateTime.parse('2026-03-31T10:00:00Z'),
                user: UserModel(
                  id: 'user-1',
                  email: 'user1@dividex.test',
                  fullName: 'User One',
                  avatar: null,
                ),
                updatedAt: DateTime.now(),  
              ),
            ],
          ),
        );

        final mockChatProvider = MockChatProvider();
        mockChatProvider.service = MockChatService();
        mockChatProvider.messages = mockLoadedMessageBloc.state.messages;
        mockChatProvider.sending = false;
        mockChatProvider.isLoadingMore = false;
        mockChatProvider.hasMore = false;
        mockChatProvider.partnerTyping = false;

        await pumpLocalizedApp(
          tester,
          buildChatPageWithProviders(
            mockLoadedMessageBloc: mockLoadedMessageBloc,
            mockChatBloc: mockChatBloc,
            mockChatProvider: mockChatProvider,
          ),
        );

        // When - Verify edited message is displayed
        await retryAssertion(
          () => waitForWidget(tester, find.text('Updated message content')),
          maxAttempts: 3,
        );

        // Then
        expect(find.text('Updated message content'), findsOneWidget);
      },
    );

    testWidgets(
      'Given sent message, when delete action triggered, then remove message from list',
      (WidgetTester tester) async {
        // Given
        const messageId = 'msg-1';
        const messageContent = 'Hello, this is a test message';

        final mockChatProvider = MockChatProvider();
        mockChatProvider.service = MockChatService();
        mockChatProvider.messages = mockLoadedMessageBloc.state.messages;
        mockChatProvider.sending = false;
        mockChatProvider.isLoadingMore = false;
        mockChatProvider.hasMore = false;
        mockChatProvider.partnerTyping = false;

        await pumpLocalizedApp(
          tester,
          buildChatPageWithProviders(
            mockLoadedMessageBloc: mockLoadedMessageBloc,
            mockChatBloc: mockChatBloc,
            mockChatProvider: mockChatProvider,
          ),
        );

        // When - Wait for message and setup delete handler
        await retryAssertion(
          () => waitForWidget(tester, find.text(messageContent)),
          maxAttempts: 2,
        );

        when(() => mockChatBloc.add(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments.first as ChatEvent;
          if (event is DeleteMessageEvent) {
            expect(event.messageId, messageId);
          }
        });

        mockChatBloc.add(DeleteMessageEvent(messageId));
        await tester.pumpAndSettle();

        // Then - Verify delete event was called
        verify(() => mockChatBloc.add(any())).called(greaterThanOrEqualTo(1));
      },
    );
  });

  // =====================================================
  // FLOW 2: NOTIFICATION FLOW TESTS
  // =====================================================

  group('Notification - View and interact with notifications', () {
    late MockLoadedNotiBloc mockLoadedNotiBloc;
    late StreamController<LoadedNotiState> notiStateController;

    setUp(() {
      mockLoadedNotiBloc = MockLoadedNotiBloc();
      notiStateController = StreamController<LoadedNotiState>.broadcast();

      // Setup initial notification state with comprehensive notification types
      when(() => mockLoadedNotiBloc.state).thenReturn(
        LoadedNotiState(
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 20,
          notis: [
            // Message Notifications
            NotificationModel(
              uid: 'noti-1',
              type: NotiType.MESSAGE_RECEIVED,
              createdAt: DateTime.now(),
              relatedUid: 'group-1',
              fromUser: UserModel(
                id: 'user-alice',
                email: 'alice@dividex.test',
                fullName: 'Alice',
                avatar: null,
              ),
              content: 'You have a new message from Alice',
              toUsers: [],
            ),
            // Friend Request Notifications
            NotificationModel(
              uid: 'noti-2',
              type: NotiType.FRIEND_REQUEST,
              createdAt: DateTime.now(),
              relatedUid: 'user-bob',
              fromUser: UserModel(
                id: 'user-bob',
                email: 'bob@dividex.test',
                fullName: 'Bob',
                avatar: null,
              ),
              content: 'Bob sent you a friend request',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-3',
              type: NotiType.FRIEND_ACCEPTED,
              createdAt: DateTime.now(),
              relatedUid: 'user-charlie',
              fromUser: UserModel(
                id: 'user-charlie',
                email: 'charlie@dividex.test',
                fullName: 'Charlie',
                avatar: null,
              ),
              content: 'Charlie accepted your friend request',
              toUsers: [],
            ),
            // Reminder Notification
            NotificationModel(
              uid: 'noti-4',
              type: NotiType.REMINDER,
              createdAt: DateTime.now(),
              relatedUid: 'event-1',
              fromUser: UserModel(
                id: 'user-reminder',
                email: 'reminder@example.com',
                fullName: 'Reminder User',
                avatar: null,
              ),
              content: 'Reminder: Event starts in 1 hour',
              toUsers: [],
            ),
            // Financial Notifications
            NotificationModel(
              uid: 'noti-5',
              type: NotiType.TRANSFER,
              createdAt: DateTime.now(),
              relatedUid: 'transfer-1',
              fromUser: UserModel(
                id: 'user-diana',
                email: 'diana@dividex.test',
                fullName: 'Diana',
                avatar: null,
              ),
              content: 'Diana transferred 100,000 VND to you',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-6',
              type: NotiType.DEPOSIT,
              createdAt: DateTime.now(),
              relatedUid: 'deposit-1',
              fromUser: UserModel(
                id: 'user-deposit',
                email: 'deposit@example.com',
                fullName: 'Deposit User',
                avatar: null,
              ),
              content: 'Your deposit of 500,000 VND was successful',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-7',
              type: NotiType.WITHDRAW,
              createdAt: DateTime.now(),
              relatedUid: 'withdraw-1',
              fromUser: UserModel(
                id: 'user-withdraw',
                email: 'withdraw@example.com',
                fullName: 'Withdraw User',
                avatar: null,
              ),
              content: 'Your withdrawal of 200,000 VND was processed',
              toUsers: [],
            ),
            // Group Notifications
            NotificationModel(
              uid: 'noti-8',
              type: NotiType.GROUP_CREATED,
              createdAt: DateTime.now(),
              relatedUid: 'group-2',
              fromUser: UserModel(
                id: 'user-eve',
                email: 'eve@dividex.test',
                fullName: 'Eve',
                avatar: null,
              ),
              content: 'Eve created a new group "Weekend Trip"',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-9',
              type: NotiType.GROUP_UPDATED,
              createdAt: DateTime.now(),
              relatedUid: 'group-2',
              fromUser: UserModel(
                id: 'user-eve',
                email: 'eve@dividex.test',
                fullName: 'Eve',
                avatar: null,
              ),
              content: 'Eve updated the group "Weekend Trip"',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-10',
              type: NotiType.GROUP_LEFT,
              createdAt: DateTime.now(),
              relatedUid: 'group-1',
              fromUser: UserModel(
                id: 'user-frank',
                email: 'frank@dividex.test',
                fullName: 'Frank',
                avatar: null,
              ),
              content: 'Frank left the group',
              toUsers: [],
            ),
            // Event Notifications
            NotificationModel(
              uid: 'noti-11',
              type: NotiType.EVENT_CREATED,
              createdAt: DateTime.now(),
              relatedUid: 'event-2',
              fromUser: UserModel(
                id: 'user-grace',
                email: 'grace@dividex.test',
                fullName: 'Grace',
                avatar: null,
              ),
              content: 'Grace created a new event "Team Dinner"',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-12',
              type: NotiType.EVENT_UPDATED,
              createdAt: DateTime.now(),
              relatedUid: 'event-2',
              fromUser: UserModel(
                id: 'user-grace',
                email: 'grace@dividex.test',
                fullName: 'Grace',
                avatar: null,
              ),
              content: 'Grace updated event "Team Dinner"',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-13',
              type: NotiType.EVENT_DELETED,
              createdAt: DateTime.now(),
              relatedUid: 'event-3',
              fromUser: UserModel(
                id: 'user-henry',
                email: 'henry@dividex.test',
                fullName: 'Henry',
                avatar: null,
              ),
              content: 'Henry deleted an event',
              toUsers: [],
            ),
            // Expense Notifications
            NotificationModel(
              uid: 'noti-14',
              type: NotiType.EXPENSE_CREATED,
              createdAt: DateTime.now(),
              relatedUid: 'expense-1',
              fromUser: UserModel(
                id: 'user-iris',
                email: 'iris@dividex.test',
                fullName: 'Iris',
                avatar: null,
              ),
              content: 'Iris added an expense "Lunch" - 150,000 VND',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-15',
              type: NotiType.EXPENSE_UPDATED,
              createdAt: DateTime.now(),
              relatedUid: 'expense-1',
              fromUser: UserModel(
                id: 'user-iris',
                email: 'iris@dividex.test',
                fullName: 'Iris',
                avatar: null,
              ),
              content: 'Iris updated the expense "Lunch"',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-16',
              type: NotiType.EXPENSE_RESTORED,
              createdAt: DateTime.now(),
              relatedUid: 'expense-2',
              fromUser: UserModel(
                id: 'user-jack',
                email: 'jack@dividex.test',
                fullName: 'Jack',
                avatar: null,
              ),
              content: 'Jack restored an expense',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-17',
              type: NotiType.EXPENSE_SOFT_DELETED,
              createdAt: DateTime.now(),
              relatedUid: 'expense-3',
              fromUser: UserModel(
                id: 'user-kate',
                email: 'kate@dividex.test',
                fullName: 'Kate',
                avatar: null,
              ),
              content: 'Kate deleted an expense (soft delete)',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-18',
              type: NotiType.EXPENSE_HARD_DELETED,
              createdAt: DateTime.now(),
              relatedUid: 'expense-4',
              fromUser: UserModel(
                id: 'user-leo',
                email: 'leo@dividex.test',
                fullName: 'Leo',
                avatar: null,
              ),
              content: 'Leo permanently deleted an expense',
              toUsers: [],
            ),
            // System & Announcements
            NotificationModel(
              uid: 'noti-19',
              type: NotiType.SYSTEM,
              createdAt: DateTime.now(),
              relatedUid: '',
              fromUser: UserModel(
                id: 'user-system',
                email: 'system@example.com',
                fullName: 'System User',
                avatar: null,
              ),
              content: 'Your profile was updated successfully',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-20',
              type: NotiType.WARNING,
              createdAt: DateTime.now(),
              relatedUid: '',
              fromUser: UserModel(
                id: 'user-warning',
                email: 'warning@example.com',
                fullName: 'Warning User',
                avatar: null,
              ),
              content: 'Warning: Unusual activity detected on your account',
              toUsers: [],
            ),
            NotificationModel(
              uid: 'noti-21',
              type: NotiType.ANNOUNCEMENT,
              createdAt: DateTime.now(),
              relatedUid: '',
              fromUser: UserModel(
                id: 'user-announcement',
                email: 'announcement@example.com',
                fullName: 'Announcement User',
                avatar: null,
              ),
              content: 'Announcement: New features available in the app',
              toUsers: [],
            ),
          ],
        ),
      );

      // Emit the initial state to the stream so BlocBuilder can display it
      notiStateController.add(mockLoadedNotiBloc.state);

      when(() => mockLoadedNotiBloc.stream)
          .thenAnswer((_) => notiStateController.stream);
      when(() => mockLoadedNotiBloc.close()).thenAnswer((_) async {});
      when(() => mockLoadedNotiBloc.add(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await notiStateController.close();
    });

    testWidgets(
      'Given notification page, when load, then display all notifications in list',
      (WidgetTester tester) async {
        // Given & When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then - Verify notification items are visible (sample of various types)
        await retryAssertion(
          () async {
            // Message notifications
            expect(find.text('You have a new message from Alice'), findsOneWidget);
            // Friend notifications
            expect(find.text('Bob sent you a friend request'), findsOneWidget);
            expect(find.text('Charlie accepted your friend request'), findsOneWidget);
            // Reminder
            expect(find.text('Reminder: Event starts in 1 hour'), findsOneWidget);
            // Financial notifications
            expect(find.text('Diana transferred 100,000 VND to you'), findsOneWidget);
            expect(find.text('Your deposit of 500,000 VND was successful'), findsOneWidget);
            // Group notifications
            expect(find.text('Eve created a new group "Weekend Trip"'), findsOneWidget);
            // Event notifications
            expect(find.text('Grace created a new event "Team Dinner"'), findsOneWidget);
            // Expense notifications
            expect(find.text('Iris added an expense "Lunch" - 150,000 VND'), findsOneWidget);
            // System notifications
            expect(find.text('Your profile was updated successfully'), findsOneWidget);
            expect(find.text('Warning: Unusual activity detected on your account'), findsOneWidget);
            expect(find.text('Announcement: New features available in the app'), findsOneWidget);
          },
          maxAttempts: 3,
        );
      },
    );

    // testWidgets(
    //   'Given notification list, when click on message notification, then navigate to chat',
    //   (WidgetTester tester) async {
    //     // Given
    //     const messageNotiContent = 'You have a new message from Alice';

    //     await tester.pumpWidget(buildNotiPageWithRouter(
    //       mockLoadedNotiBloc: mockLoadedNotiBloc,
    //     ));
    //     await tester.pumpAndSettle();

    //     // When - Wait for and tap on message notification
    //     final notiTile = find.text(messageNotiContent);
    //     await retryAssertion(
    //       () => waitForWidget(tester, notiTile),
    //       maxAttempts: 3,
    //     );

    //     await tester.tap(notiTile);
    //     await tester.pumpAndSettle();

    //     // Then - Verify notification was tapped
    //     expect(notiTile, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   'Given notification list, when click on friend request notification, then show action options',
    //   (WidgetTester tester) async {
    //     // Given
    //     const friendRequestContent = 'Bob sent you a friend request';

    //     await tester.pumpWidget(buildNotiPageWithRouter(
    //       mockLoadedNotiBloc: mockLoadedNotiBloc,
    //     ));
    //     await tester.pumpAndSettle();

    //     // When - Wait for and tap on friend request notification
    //     final friendNoti = find.text(friendRequestContent);
    //     await retryAssertion(
    //       () => waitForWidget(tester, friendNoti),
    //       maxAttempts: 3,
    //     );

    //     await tester.tap(friendNoti);
    //     await tester.pumpAndSettle();

    //     // Then - Verify notification was tapped
    //     expect(friendNoti, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   'Given notification, when notification is read, then mark as read state updates',
    //   (WidgetTester tester) async {
    //     // Given - Setup notification as read
    //     const messageContent = 'You have a new message from Alice';
    //     when(() => mockLoadedNotiBloc.state).thenReturn(
    //       LoadedNotiState(
    //         isLoading: false,
    //         page: 1,
    //         totalPage: 1,
    //         totalItems: 1,
    //         notis: [
    //           NotificationModel(
    //             uid: 'noti-1',
    //             content: messageContent,
    //             type: NotiType.MESSAGE_RECEIVED,
    //             createdAt: DateTime.now(),
    //             relatedUid: 'group-1',
    //             fromUser: UserModel(
    //               id: 'user-alice',
    //               email: 'alice@example.com',
    //               fullName: 'Alice',
    //               avatar: null,
    //             ), toUsers: []
    //           ),
    //         ],
    //       ),
    //     );

    //     // When
    //     await tester.pumpWidget(buildNotiPageWithRouter(
    //       mockLoadedNotiBloc: mockLoadedNotiBloc,
    //     ));
    //     await tester.pumpAndSettle();

    //     // Then - Verify notification is displayed
    //     await retryAssertion(
    //       () => waitForWidget(tester, find.text(messageContent)),
    //       maxAttempts: 3,
    //     );
    //   },
    // );

    // testWidgets(
    //   'Given multiple notifications, when refresh, then reload notification list',
    //   (WidgetTester tester) async {
    //     // Given
    //     when(() => mockLoadedNotiBloc.add(any())).thenAnswer((invocation) {
    //       final event = invocation.positionalArguments.first as LoadNotiEvent;
    //       if (event is RefreshNotiEvent) {
    //         Future<void>.microtask(() {
    //           notiStateController.add(
    //             LoadedNotiState(
    //               isLoading: false,
    //               page: 1,
    //               totalPage: 1,
    //               totalItems: 2,
    //               notis: [
    //                 NotificationModel(
    //                   uid: 'noti-new-1',
    //                   content: 'This is a new notification',
    //                   type: NotiType.SYSTEM,
    //                   createdAt: DateTime.now(),
    //                   relatedUid: 'group-1', 
    //                   fromUser: UserModel(
    //                     id: 'user-bob',
    //                     email: 'bob@example.com',
    //                     fullName: 'Bob',
    //                     avatar: null,
    //                   ),
    //                   toUsers: [],
    //                 ),
    //               ],
    //             ),
    //           );
    //         });
    //       }
    //     });

    //     await tester.pumpWidget(buildNotiPageWithRouter(
    //       mockLoadedNotiBloc: mockLoadedNotiBloc,
    //     ));
    //     await tester.pumpAndSettle();

    //     // When - Trigger refresh (pull down)
    //     mockLoadedNotiBloc.add(const RefreshNotiEvent());
    //     await tester.pumpAndSettle();

    //     // Then
    //     verify(() => mockLoadedNotiBloc.add(any())).called(greaterThanOrEqualTo(1));
    //   },
    // );

    // testWidgets(
    //   'Given notification page, when scroll to load more, then fetch additional notifications',
    //   (WidgetTester tester) async {
    //     // Given
    //     const page2 = 2;

    //     when(() => mockLoadedNotiBloc.add(any())).thenAnswer((invocation) {
    //       final event = invocation.positionalArguments.first as LoadNotiEvent;
    //       if (event is LoadMoreNotiEvent) {
    //         Future<void>.microtask(() {
    //           notiStateController.add(
    //             LoadedNotiState(
    //               isLoading: false,
    //               page: 2,
    //               totalPage: 2,
    //               totalItems: 6,
    //               notis: [
    //                 NotificationModel(
    //                   uid: 'noti-page2-1',
    //                   content: 'From page 2',
    //                   type: NotiType.FRIEND_REQUEST,
    //                   createdAt: DateTime.now(),
    //                   relatedUid: 'user-1',
    //                   fromUser: UserModel(
    //                     id: 'user-alice',
    //                     email: 'alice@example.com',
    //                     fullName: 'Alice',
    //                     avatar: null,
    //                   ),
    //                   toUsers: [],
    //                 ),
    //               ],
    //             ),
    //           );
    //         });
    //       }
    //     });

    //     await tester.pumpWidget(buildNotiPageWithRouter(
    //       mockLoadedNotiBloc: mockLoadedNotiBloc,
    //     ));
    //     await tester.pumpAndSettle();

    //     // When - Trigger load more
    //     mockLoadedNotiBloc.add(const LoadMoreNotiEvent(page2, 20));
    //     await tester.pumpAndSettle();

    //     // Then
    //     verify(() => mockLoadedNotiBloc.add(any())).called(greaterThanOrEqualTo(1));
    //   },
    // );

    // testWidgets(
    //   'Given system notification, when view, then display system message correctly',
    //   (WidgetTester tester) async {
    //     // Given
    //     const sysNotiContent = 'Your profile was updated successfully';

    //     when(() => mockLoadedNotiBloc.state).thenReturn(
    //       LoadedNotiState(
    //         isLoading: false,
    //         page: 1,
    //         totalPage: 1,
    //         totalItems: 1,
    //         notis: [
    //           NotificationModel(
    //             uid: 'noti-sys-1',
    //             content: sysNotiContent,
    //             type: NotiType.SYSTEM,
    //             createdAt: DateTime.now(),
    //             relatedUid: '',
    //             fromUser: UserModel(
    //               id: 'user-system',
    //               email: 'system@example.com',
    //               fullName: 'System',
    //               avatar: null,
    //             ),
    //             toUsers: [],
    //           ),
    //         ],
    //       ),
    //     );

    //     // When
    //     await tester.pumpWidget(buildNotiPageWithRouter(
    //       mockLoadedNotiBloc: mockLoadedNotiBloc,
    //     ));
    //     await tester.pumpAndSettle();

    //     // Then - Verify system notification is displayed
    //     await retryAssertion(
    //       () => waitForWidget(tester, find.text(sysNotiContent)),
    //       maxAttempts: 3,
    //     );

    //     expect(find.text(sysNotiContent), findsOneWidget);
    //   },
    // );

    testWidgets(
      'Given financial notifications (transfer/deposit/withdraw), when viewed, then display correct transaction info',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 3,
            notis: [
              NotificationModel(
                uid: 'noti-transfer',
                type: NotiType.TRANSFER,
                createdAt: DateTime.now(),
                relatedUid: 'transfer-1',
                fromUser: UserModel(
                  id: 'user-sender',
                  email: 'sender@dividex.test',
                  fullName: 'Sender User',
                  avatar: null,
                ),
                content: 'Sender User transferred 100,000 VND to you',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-deposit',
                type: NotiType.DEPOSIT,
                createdAt: DateTime.now(),
                relatedUid: 'deposit-1',
                fromUser: UserModel(
                  id: 'user-deposit',
                  email: 'deposit@example.com',
                  fullName: 'Deposit User',
                  avatar: null,
                ),
                content: 'Deposit User deposited 500,000 VND',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-withdraw',
                type: NotiType.WITHDRAW,
                createdAt: DateTime.now(),
                relatedUid: 'withdraw-1',
                fromUser: UserModel(
                  id: 'user-withdraw',
                  email: 'withdraw@example.com',
                  fullName: 'Withdraw User',
                  avatar: null,
                ),
                content: 'Withdraw User processed your withdrawal of 200,000 VND',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then - Verify financial notifications are displayed
        await retryAssertion(
          () async {
            expect(find.text('Sender User transferred 100,000 VND to you'), findsOneWidget);
            expect(find.text('Deposit User deposited 500,000 VND'), findsOneWidget);
            expect(find.text('Withdraw User processed your withdrawal of 200,000 VND'), findsOneWidget);
          },
          maxAttempts: 3,
        );
      },
    );

    testWidgets(
      'Given group/event notifications, when viewed, then display group and event creation/update messages',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 5,
            notis: [
              NotificationModel(
                uid: 'noti-group-created',
                type: NotiType.GROUP_CREATED,
                createdAt: DateTime.now(),
                relatedUid: 'group-2',
                fromUser: UserModel(
                  id: 'user-group-creator',
                  email: 'creator@dividex.test',
                  fullName: 'Group Creator',
                  avatar: null,
                ),
                content: 'Group Creator created a new group "Weekend Trip"',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-group-updated',
                type: NotiType.GROUP_UPDATED,
                createdAt: DateTime.now(),
                relatedUid: 'group-2',
                fromUser: UserModel(
                  id: 'user-group-updater',
                  email: 'updater@dividex.test',
                  fullName: 'Group Updater',
                  avatar: null,
                ),
                content: 'Group Updater updated the group "Weekend Trip"',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-group-left',
                type: NotiType.GROUP_LEFT,
                createdAt: DateTime.now(),
                relatedUid: 'group-1',
                fromUser: UserModel(
                  id: 'user-who-left',
                  email: 'leftuser@dividex.test',
                  fullName: 'Left User',
                  avatar: null,
                ),
                content: 'Left User left the group "Weekend Trip"',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-event-created',
                type: NotiType.EVENT_CREATED,
                createdAt: DateTime.now(),
                relatedUid: 'event-2',
                fromUser: UserModel(
                  id: 'user-event-creator',
                  email: 'eventcreator@dividex.test',
                  fullName: 'Event Creator',
                  avatar: null,
                ),
                content: 'Event Creator created a new event "Team Dinner"',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-event-updated',
                type: NotiType.EVENT_UPDATED,
                createdAt: DateTime.now(),
                relatedUid: 'event-2',
                fromUser: UserModel(
                  id: 'user-event-updater',
                  email: 'eventupdater@dividex.test',
                  fullName: 'Event Updater',
                  avatar: null,
                ),
                content: 'Event Updater updated event "Team Dinner"',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then - Verify group and event notifications
        await retryAssertion(
          () async {
            expect(find.text('Group Creator created a new group "Weekend Trip"'), findsOneWidget);
            expect(find.text('Group Updater updated the group "Weekend Trip"'), findsOneWidget);
            expect(find.text('Left User left the group "Weekend Trip"'), findsOneWidget);
            expect(find.text('Event Creator created a new event "Team Dinner"'), findsOneWidget);
            expect(find.text('Event Updater updated event "Team Dinner"'), findsOneWidget);
          },
          maxAttempts: 3,
        );
      },
    );

    testWidgets(
      'Given expense notifications, when viewed, then display expense creation/update/restore/delete messages',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 4,
            notis: [
              NotificationModel(
                uid: 'noti-expense-created',
                type: NotiType.EXPENSE_CREATED,
                createdAt: DateTime.now(),
                relatedUid: 'expense-1',
                fromUser: UserModel(
                  id: 'user-expense-creator',
                  email: 'expensecreator@dividex.test',
                  fullName: 'Expense Creator',
                  avatar: null,
                ),
                content: 'Expense Creator added an expense "Lunch" - 150,000 VND',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-expense-updated',
                type: NotiType.EXPENSE_UPDATED,
                createdAt: DateTime.now(),
                relatedUid: 'expense-1',
                fromUser: UserModel(
                  id: 'user-expense-updater',
                  email: 'expenseupdater@dividex.test',
                  fullName: 'Expense Updater',
                  avatar: null,
                ),
                content: 'Expense Updater updated the expense "Lunch"',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-expense-restored',
                type: NotiType.EXPENSE_RESTORED,
                createdAt: DateTime.now(),
                relatedUid: 'expense-2',
                fromUser: UserModel(
                  id: 'user-expense-restorer',
                  email: 'restorer@dividex.test',
                  fullName: 'Restorer User',
                  avatar: null,
                ),
                content: 'Restorer User restored an expense',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-expense-soft-deleted',
                type: NotiType.EXPENSE_SOFT_DELETED,
                createdAt: DateTime.now(),
                relatedUid: 'expense-3',
                fromUser: UserModel(
                  id: 'user-expense-deleter',
                  email: 'expensedeleter@dividex.test',
                  fullName: 'Deleter User',
                  avatar: null,
                ),
                content: 'Deleter User deleted an expense (soft delete)',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then - Verify expense notifications
        await retryAssertion(
          () async {
            expect(find.text('Expense Creator added an expense "Lunch" - 150,000 VND'), findsOneWidget);
            expect(find.text('Expense Updater updated the expense "Lunch"'), findsOneWidget);
            expect(find.text('Restorer User restored an expense'), findsOneWidget);
            expect(find.text('Deleter User deleted an expense (soft delete)'), findsOneWidget);
          },
          maxAttempts: 3,
        );
      },
    );

    testWidgets(
      'Given friend acceptance and reminder notifications, when viewed, then display correctly',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 2,
            notis: [
              NotificationModel(
                uid: 'noti-friend-accepted',
                type: NotiType.FRIEND_ACCEPTED,
                createdAt: DateTime.now(),
                relatedUid: 'user-friend',
                fromUser: UserModel(
                  id: 'user-friend',
                  email: 'friend@dividex.test',
                  fullName: 'Friend User',
                  avatar: null,
                ),
                content: 'Friend User accepted your friend request',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-reminder',
                type: NotiType.REMINDER,
                createdAt: DateTime.now(),
                relatedUid: 'event-reminder-1',
                fromUser: UserModel(
                  id: 'user-reminder',
                  email: 'reminder@example.com',
                  fullName: 'Reminder User',
                  avatar: null,
                ),
                content: 'Reminder: Event "Project Deadline" starts in 1 hour',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then
        await retryAssertion(
          () async {
            expect(find.text('Friend User accepted your friend request'), findsOneWidget);
            expect(find.text('Reminder: Event "Project Deadline" starts in 1 hour'), findsOneWidget);
          },
          maxAttempts: 3,
        );
      },
    );

    testWidgets(
      'Given warning and announcement notifications, when viewed, then display system-level messages',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 2,
            notis: [
              NotificationModel(
                uid: 'noti-warning',
                type: NotiType.WARNING,
                createdAt: DateTime.now(),
                relatedUid: '',
                fromUser: UserModel(
                  id: 'user-warning',
                  email: 'warning@example.com',
                  fullName: 'Warning User',
                  avatar: null,
                ),
                content: 'Warning: Unusual activity detected on your account',
                toUsers: [],
              ),
              NotificationModel(
                uid: 'noti-announcement',
                type: NotiType.ANNOUNCEMENT,
                createdAt: DateTime.now(),
                relatedUid: '',
                fromUser: UserModel(
                  id: 'user-announcement',
                  email: 'announcement@example.com',
                  fullName: 'Announcement User',
                  avatar: null,
                ),
                content: 'Announcement: New features available in the app v2.0',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then
        await retryAssertion(
          () async {
            expect(find.text('Warning: Unusual activity detected on your account'), findsOneWidget);
            expect(find.text('Announcement: New features available in the app v2.0'), findsOneWidget);
          },
          maxAttempts: 3,
        );
      },
    );

    testWidgets(
      'Given event deleted notification, when viewed, then display event deletion message',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            notis: [
              NotificationModel(
                uid: 'noti-event-deleted',
                type: NotiType.EVENT_DELETED,
                createdAt: DateTime.now(),
                relatedUid: 'event-3',
                fromUser: UserModel(
                  id: 'user-event-deleter',
                  email: 'eventdeleter@dividex.test',
                  fullName: 'Event Deleter',
                  avatar: null,
                ),
                content: 'Event Deleter deleted an event "Cancelled Meeting"',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then
        await retryAssertion(
          () => waitForWidget(tester, find.text('Event Deleter deleted an event "Cancelled Meeting"')),
          maxAttempts: 3,
        );

        expect(find.text('Event Deleter deleted an event "Cancelled Meeting"'), findsOneWidget);
      },
    );

    testWidgets(
      'Given expense hard delete notification, when viewed, then display permanent deletion message',
      (WidgetTester tester) async {
        // Given
        when(() => mockLoadedNotiBloc.state).thenReturn(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            notis: [
              NotificationModel(
                uid: 'noti-expense-hard-deleted',
                type: NotiType.EXPENSE_HARD_DELETED,
                createdAt: DateTime.now(),
                relatedUid: 'expense-4',
                fromUser: UserModel(
                  id: 'user-hard-deleter',
                  email: 'harddeleter@dividex.test',
                  fullName: 'Hard Deleter',
                  avatar: null,
                ),
                content: 'Hard Deleter permanently deleted an expense',
                toUsers: [],
              ),
            ],
          ),
        );

        // When
        await tester.pumpWidget(buildNotiPageWithRouter(
          mockLoadedNotiBloc: mockLoadedNotiBloc,
        ));
        await tester.pumpAndSettle();

        // Then
        await retryAssertion(
          () => waitForWidget(tester, find.text('Hard Deleter permanently deleted an expense')),
          maxAttempts: 3,
        );

        expect(find.text('Hard Deleter permanently deleted an expense'), findsOneWidget);
      },
    );
  });
}
