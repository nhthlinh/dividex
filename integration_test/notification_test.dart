import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_event.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/features/notifications/presentation/pages/noti_page.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadedNotiBloc extends Mock implements LoadedNotiBloc {}

class FakeLoadNotiEvent extends Fake implements LoadNotiEvent {}

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

GoRouter buildNotificationRouter({required MockLoadedNotiBloc loadedNotiBloc}) {
  return GoRouter(
    initialLocation: '/noti-test',
    routes: <GoRoute>[
      GoRoute(
        path: '/noti-test',
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<LoadedNotiBloc>.value(
            value: loadedNotiBloc,
            child: const NotiPage(),
          );
        },
      ),
      GoRoute(
        path: '/wallet-report',
        name: AppRouteNames.walletReport,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(
            body: Center(
              child: Text(
                'WALLET_REPORT_PAGE',
                key: Key('wallet_report_marker'),
              ),
            ),
          );
        },
      ),
    ],
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeLoadNotiEvent());
  });

  group('Notification_1 - Notification feature integration tests', () {
    late MockLoadedNotiBloc mockLoadedNotiBloc;
    late StreamController<LoadedNotiState> loadedNotiStateController;

    setUp(() {
      mockLoadedNotiBloc = MockLoadedNotiBloc();
      loadedNotiStateController = StreamController<LoadedNotiState>.broadcast();

      when(
        () => mockLoadedNotiBloc.state,
      ).thenReturn(const LoadedNotiState(isLoading: true));
      when(
        () => mockLoadedNotiBloc.stream,
      ).thenAnswer((_) => loadedNotiStateController.stream);
      when(() => mockLoadedNotiBloc.add(any())).thenAnswer((_) {});
      when(() => mockLoadedNotiBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() async {
      await loadedNotiStateController.close();
    });

    testWidgets(
      'Given notifications are loaded, when opening notification page, then show notification card content',
      (WidgetTester tester) async {
        // Given
        final notification = NotificationModel(
          uid: 'noti-1',
          createdAt: DateTime.now(),
          content: 'You have deposited 100 USD into your account.',
          type: NotiType.TRANSFER,
          relatedUid: 'rel-1',
          fromUser: UserModel(
            id: 'user-1',
            fullName: 'Alice Test',
            email: 'alice@dividex.test',
          ),
          toUsers: const [],
        );

        final router = buildNotificationRouter(
          loadedNotiBloc: mockLoadedNotiBloc,
        );

        await pumpLocalizedRouter(tester, router);

        loadedNotiStateController.add(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            notis: [notification],
          ),
        );
        await tester.pumpAndSettle();

        // Then
        expect(
          find.text('You have deposited 100 USD into your account.'),
          findsOneWidget,
        );
        expect(find.textContaining('202'), findsOneWidget);
      },
    );

    testWidgets(
      'Given empty notification list, when notifications arrive, then the list updates',
      (WidgetTester tester) async {
        // Given
        final notification = NotificationModel(
          uid: 'noti-2',
          createdAt: DateTime.now(),
          content: 'A new notification was delivered.',
          type: NotiType.SYSTEM,
          relatedUid: '',
          fromUser: UserModel(
            id: 'user-2',
            fullName: 'System',
            email: 'system@dividex.test',
          ),
          toUsers: const [],
        );

        final router = buildNotificationRouter(
          loadedNotiBloc: mockLoadedNotiBloc,
        );

        await pumpLocalizedRouter(tester, router);

        loadedNotiStateController.add(
          const LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 0,
            notis: [],
          ),
        );
        await tester.pumpAndSettle();

        // When
        loadedNotiStateController.add(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            notis: [notification],
          ),
        );
        await tester.pumpAndSettle();

        // Then
        expect(find.text('A new notification was delivered.'), findsOneWidget);
      },
    );

    testWidgets(
      'Given a transfer notification, when tapping the card, then navigate to wallet report page',
      (WidgetTester tester) async {
        // Given
        final notification = NotificationModel(
          uid: 'noti-3',
          createdAt: DateTime.now(),
          content: 'Transfer completed successfully.',
          type: NotiType.TRANSFER,
          relatedUid: 'rel-2',
          fromUser: UserModel(
            id: 'user-3',
            fullName: 'Bob Test',
            email: 'bob@dividex.test',
          ),
          toUsers: const [],
        );

        final router = buildNotificationRouter(
          loadedNotiBloc: mockLoadedNotiBloc,
        );

        await pumpLocalizedRouter(tester, router);

        loadedNotiStateController.add(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            notis: [notification],
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Transfer completed successfully.').first);
        await tester.pumpAndSettle();

        // Then
        expect(find.byKey(const Key('wallet_report_marker')), findsOneWidget);
      },
    );

    testWidgets(
      'Given a system notification, when tapping the notification, then the notification dialog appears and the item remains visible',
      (WidgetTester tester) async {
        // Given
        const notificationMessage = 'System maintenance will begin soon.';
        final notification = NotificationModel(
          uid: 'noti-4',
          createdAt: DateTime.now(),
          content: notificationMessage,
          type: NotiType.SYSTEM,
          relatedUid: '',
          fromUser: UserModel(
            id: 'system',
            fullName: 'System',
            email: 'system@dividex.test',
          ),
          toUsers: const [],
        );

        final router = buildNotificationRouter(
          loadedNotiBloc: mockLoadedNotiBloc,
        );

        await pumpLocalizedRouter(tester, router);

        loadedNotiStateController.add(
          LoadedNotiState(
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 1,
            notis: [notification],
          ),
        );
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text(notificationMessage).first);
        await tester.pumpAndSettle();

        // Then
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text(notificationMessage), findsWidgets);
      },
    );
  });
}
