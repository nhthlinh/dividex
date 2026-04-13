import 'package:Dividex/features/recharge/presentation/widgets/balance_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BalanceRow toggles hidden and visible balance', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BalanceRow(
            balanceLabel: 'Balance',
            balance: '100000',
          ),
        ),
      ),
    );

    expect(find.text('••••••'), findsOneWidget);
    expect(find.text('100000'), findsNothing);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(find.text('100000'), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });
}
