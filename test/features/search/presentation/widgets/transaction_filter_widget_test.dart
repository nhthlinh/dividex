import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/search/presentation/pages/filter_page.dart';
import 'package:Dividex/features/search/presentation/wallet_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TransactionFilterWidget renders input fields and apply button', (tester) async {
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
          body: TransactionFilterWidget(
            type: FilterType.externalTransaction,
            onApplyExternal: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsWidgets);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
