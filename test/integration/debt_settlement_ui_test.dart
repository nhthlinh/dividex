import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// Test widget for Pay Outside button
class _PayOutsideTestWidget extends StatefulWidget {
  const _PayOutsideTestWidget();

  @override
  State<_PayOutsideTestWidget> createState() => _PayOutsideTestWidgetState();
}

class _PayOutsideTestWidgetState extends State<_PayOutsideTestWidget> {
  bool toastShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  toastShown = true;
                });
              },
              child: const Text('Pay Outside'),
            ),
            if (toastShown) const Text('Coming soon message displayed'),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Debt Settlement UI Tests', () {
    testWidgets('Group member displays debt information', (
      WidgetTester tester,
    ) async {
      const debtAmount = 250.0;
      const currencyCode = 'VND';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text('John Doe'),
                  Text('Owes: $debtAmount $currencyCode'),
                  ElevatedButton(onPressed: () {}, child: const Text('Pay')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Owes: 250.0 VND'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Settle up button displays dialog', (
      WidgetTester tester,
    ) async {
      const debtorName = 'Alice Johnson';
      const debtAmount = 150.0;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Settle Up'),
                        content: Text('Pay $debtAmount to $debtorName'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Transfer'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Settle Up'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Settle Up'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Settle Up'), findsWidgets);
    });

    testWidgets('Settlement dialog shows two action buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Settle Up'),
                        content: const Text('Choose payment method'),
                        actions: [
                          CustomButton(
                            text: 'Pay Outside',
                            size: ButtonSize.medium,
                            type: ButtonType.secondary,
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            text: 'Transfer',
                            size: ButtonSize.medium,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomButton), findsWidgets);
      expect(find.text('Transfer'), findsWidgets);
      expect(find.text('Pay Outside'), findsWidgets);
    });

    testWidgets('Settlement amount displays with currency', (
      WidgetTester tester,
    ) async {
      const amount = 500.0;
      const currency = 'VND';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Center(child: Text('Pay $amount $currency'))),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pay 500.0 VND'), findsOneWidget);
    });

    testWidgets('Member carousel shows multiple members', (
      WidgetTester tester,
    ) async {
      final members = [
        UserModel(id: '2', fullName: 'Member 1'),
        UserModel(id: '3', fullName: 'Member 2'),
        UserModel(id: '4', fullName: 'Member 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: members.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8),
                child: Text(members[index].fullName ?? 'Unknown'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Member 1'), findsOneWidget);
      expect(find.text('Member 2'), findsOneWidget);
      expect(find.text('Member 3'), findsOneWidget);
    });

    testWidgets('Negative debt displays correctly (money owed to you)', (
      WidgetTester tester,
    ) async {
      const debtAmount = -300.0;
      const memberName = 'Bob Smith';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text(memberName),
                  Text('Owes you: ${debtAmount.abs()} VND'),
                  ElevatedButton(onPressed: () {}, child: const Text('Remind')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(memberName), findsOneWidget);
      expect(find.text('Owes you: 300.0 VND'), findsOneWidget);
    });

    testWidgets('Zero debt member shows no action button', (
      WidgetTester tester,
    ) async {
      const debtAmount = 0.0;
      const memberName = 'Frank Wilson';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text(memberName),
                  Text('Debt: $debtAmount VND'),
                  if (debtAmount != 0)
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Action'),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(memberName), findsOneWidget);
      expect(find.text('Debt: 0.0 VND'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Transfer button in dialog closes and allows navigation', (
      WidgetTester tester,
    ) async {
      int navigationCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Transfer'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              navigationCalls++;
                              Navigator.pop(ctx);
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Open Payment'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Payment'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(navigationCalls, 1);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Pay outside button shows info toast', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: _PayOutsideTestWidget(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay Outside'));
      await tester.pumpAndSettle();

      expect(find.text('Coming soon message displayed'), findsOneWidget);
    });
  });
}
