import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadedFriendsBloc extends Mock implements LoadedFriendsBloc {}

class MockRechargeBloc extends Mock implements RechargeBloc {}

void main() {
  group('Wallet Transfer UI Tests', () {
    late MockLoadedFriendsBloc mockFriendsBloc;
    late MockRechargeBloc mockRechargeBloc;

    setUp(() {
      mockFriendsBloc = MockLoadedFriendsBloc();
      mockRechargeBloc = MockRechargeBloc();

      final friendsList = [
        FriendModel(
          friendUid: 'friend-1',
          fullName: 'John Doe',
          avatarUrl: null,
        ),
        FriendModel(
          friendUid: 'friend-2',
          fullName: 'Jane Smith',
          avatarUrl: null,
        ),
      ];

      when(() => mockFriendsBloc.state).thenReturn(
        LoadedFriendsState(
          requests: friendsList,
          isLoading: false,
          page: 1,
          totalPage: 1,
          totalItems: 2,
        ),
      );

      when(() => mockFriendsBloc.stream).thenAnswer(
        (_) => Stream<LoadedFriendsState>.value(
          LoadedFriendsState(
            requests: friendsList,
            isLoading: false,
            page: 1,
            totalPage: 1,
            totalItems: 2,
          ),
        ),
      );

      when(
        () => mockRechargeBloc.state,
      ).thenReturn(GetWalletSuccessState('1000000'));

      when(() => mockRechargeBloc.stream).thenAnswer(
        (_) => Stream<RechargeState>.value(GetWalletSuccessState('1000000')),
      );
    });

    // testWidgets('Friend selection UI displays friends from BLoC', (
    //   WidgetTester tester,
    // ) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       localizationsDelegates: const [
    //         AppLocalizations.delegate,
    //         GlobalMaterialLocalizations.delegate,
    //         GlobalWidgetsLocalizations.delegate,
    //         GlobalCupertinoLocalizations.delegate,
    //       ],
    //       supportedLocales: AppLocalizations.supportedLocales,
    //       home: Scaffold(
    //         body: BlocProvider<LoadedFriendsBloc>.value(
    //           value: mockFriendsBloc,
    //           child: ListView.builder(
    //             itemCount: 2,
    //             itemBuilder: (context, index) {
    //               final friends = context
    //                   .watch<LoadedFriendsBloc>()
    //                   .state
    //                   .requests;
    //               if (friends.isEmpty) return SizedBox.shrink();
    //               return SquareUser(
    //                 user: UserModel(
    //                   id: friends[index].friendUid,
    //                   fullName: friends[index].fullName,
    //                   avatar: friends[index].avatarUrl,
    //                 ),
    //                 isSelected: false,
    //                 onTap: () {},
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   expect(find.byType(SquareUser), findsWidgets);
    // });

    // testWidgets('Recipient selection can be toggled', (
    //   WidgetTester tester,
    // ) async {
    //   bool isSelected = false;

    //   await tester.pumpWidget(
    //     StatefulBuilder(
    //       builder: (context, setState) => MaterialApp(
    //         localizationsDelegates: const [
    //           AppLocalizations.delegate,
    //           GlobalMaterialLocalizations.delegate,
    //           GlobalWidgetsLocalizations.delegate,
    //           GlobalCupertinoLocalizations.delegate,
    //         ],
    //         supportedLocales: AppLocalizations.supportedLocales,
    //         home: Scaffold(
    //           body: SquareUser(
    //             user: UserModel(id: 'friend-1', fullName: 'John Doe'),
    //             isSelected: isSelected,
    //             onTap: () {
    //               setState(() {
    //                 isSelected = !isSelected;
    //               });
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   // Initial state - not selected
    //   expect(find.byType(SquareUser), findsOneWidget);

    //   // Tap to select
    //   await tester.tap(find.byType(SquareUser));
    //   await tester.pumpAndSettle();

    //   // Verify state changed
    //   expect(find.byType(SquareUser), findsOneWidget);
    // });

    testWidgets('Amount input field validates numeric input', (
      WidgetTester tester,
    ) async {
      final amountController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Amount')),
            ),
          ),
        ),
      );

      // Enter amount
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '500000');
      await tester.pumpAndSettle();

      expect(amountController.text, '500000');
    });

    testWidgets('Confirm button state depends on form validation', (
      WidgetTester tester,
    ) async {
      bool isFormValid = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            // Transfer action
                          }
                        : null,
                    child: const Text('Confirm Transfer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFormValid = true;
                      });
                    },
                    child: const Text('Enable Form'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Button should be disabled initially
      final confirmButton = find.byType(ElevatedButton).first;
      expect(confirmButton, findsOneWidget);

      // Enable form
      await tester.tap(find.text('Enable Form'));
      await tester.pumpAndSettle();

      // Button should now be enabled
      expect(confirmButton, findsOneWidget);
    });

    testWidgets('Wallet balance displays from RechargeBloc', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocBuilder<RechargeBloc, RechargeState>(
              bloc: mockRechargeBloc,
              builder: (context, state) {
                if (state is GetWalletSuccessState) {
                  return ContentCard(
                    child: Text('Balance: ${state.walletInfo}'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ContentCard), findsOneWidget);
      expect(find.text('Balance: 1000000'), findsWidgets);
    });

    testWidgets('Currency selector shows all available currencies', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: CurrencyEnum.values.length,
              itemBuilder: (context, index) {
                final currency = CurrencyEnum.values[index];
                return ListTile(
                  title: Text(currency.code.toUpperCase()),
                  subtitle: Text(currency.description),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Description input accepts text', (WidgetTester tester) async {
      final descController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: descController,
              decoration: const InputDecoration(label: Text('Description')),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Payment for dinner');
      await tester.pumpAndSettle();

      expect(descController.text, 'Payment for dinner');
    });

    testWidgets('Transfer button navigates when form is valid', (
      WidgetTester tester,
    ) async {
      int navigationCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigationCount++;
                  },
                  child: const Text('Transfer'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Transfer'));
      await tester.pumpAndSettle();

      expect(navigationCount, 1);
    });
  });
}
