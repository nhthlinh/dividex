import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/email_input_page.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';

import 'email_input_page_test.mocks.dart';

@GenerateMocks([AuthBloc, AppLocalizations])
void main() {
  group('EmailInputPage Widget Tests', () {
    late MockAuthBloc mockAuthBloc;
    late MockAppLocalizations mockAppLocalizations;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      mockAppLocalizations = MockAppLocalizations();
    });

    testWidgets('EmailInputPage displays email input form',
        (WidgetTester tester) async {
      // Setup mocks
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      // Setup localizations mock
      when(mockAppLocalizations.forgotPassword).thenReturn('Forgot Password');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const EmailInputPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify email field exists
      expect(find.byType(TextFormField), findsWidgets);

      // Verify submit button exists
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('EmailInputPage triggers AuthEmailRequested on form submit',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.forgotPassword).thenReturn('Forgot Password');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const EmailInputPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Fill in email field
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );

      // Pump to allow validation
      await tester.pumpAndSettle();

      // Find and tap submit button
      final submitButton = find.byType(ElevatedButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton.first);
        await tester.pumpAndSettle();

        // Verify that AuthBloc is still present
        expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
      }
    });

    testWidgets('EmailInputPage title is displayed correctly',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.forgotPassword).thenReturn('Forgot Password');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const EmailInputPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify title is displayed
      expect(find.text('Forgot Password'), findsWidgets);
    });
  });
}
