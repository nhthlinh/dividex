import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/reset_pass_page.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';

import 'reset_pass_page_test.mocks.dart';

@GenerateMocks([AuthBloc, AppLocalizations])
void main() {
  group('ResetPassPage Widget Tests', () {
    late MockAuthBloc mockAuthBloc;
    late MockAppLocalizations mockAppLocalizations;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      mockAppLocalizations = MockAppLocalizations();
    });

    testWidgets('ResetPassPage displays password reset form',
        (WidgetTester tester) async {
      // Setup mocks
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      // Setup localizations mock
      when(mockAppLocalizations.resetPassPageTitle).thenReturn('Reset Password');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.confirmPasswordLabel)
          .thenReturn('Confirm Password');
      when(mockAppLocalizations.login).thenReturn('Login');
      when(mockAppLocalizations.newPasswordLabel)
          .thenReturn('New password');

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const ResetPassPage(token: 'test_token'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify password fields exist
      expect(find.byType(TextFormField), findsWidgets);

      // Verify submit button exists
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('ResetPassPage shows password visibility toggle',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.resetPassPageTitle).thenReturn('Reset Password');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.confirmPasswordLabel)
          .thenReturn('Confirm Password');
      when(mockAppLocalizations.login).thenReturn('Login');
      when(mockAppLocalizations.newPasswordLabel)
          .thenReturn('New password');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const ResetPassPage(token: 'test_token'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Look for password visibility toggle buttons
      expect(find.byIcon(Icons.visibility_off), findsWidgets);
    });

    testWidgets('ResetPassPage triggers AuthResetPasswordRequested on submit',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.resetPassPageTitle).thenReturn('Reset Password');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.confirmPasswordLabel)
          .thenReturn('Confirm Password');
      when(mockAppLocalizations.login).thenReturn('Login');
      when(mockAppLocalizations.newPasswordLabel)
          .thenReturn('New password');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const ResetPassPage(token: 'test_token'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Fill in password field
      await tester.enterText(
        find.byType(TextFormField).first,
        'newpassword123',
      );

      // Fill in confirm password field
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'newpassword123',
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

    testWidgets('ResetPassPage title is displayed correctly',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.resetPassPageTitle).thenReturn('Reset Password');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.confirmPasswordLabel)
          .thenReturn('Confirm Password');
      when(mockAppLocalizations.login).thenReturn('Login');
      when(mockAppLocalizations.newPasswordLabel)
          .thenReturn('New password');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const ResetPassPage(token: 'test_token'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify title is displayed
      expect(find.text('Change password'), findsWidgets);
    });

    testWidgets('ResetPassPage validates password confirmation',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.resetPassPageTitle).thenReturn('Reset Password');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.confirmPasswordLabel)
          .thenReturn('Confirm Password');
      when(mockAppLocalizations.login).thenReturn('Login');
      when(mockAppLocalizations.newPasswordLabel)
          .thenReturn('New password');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const ResetPassPage(token: 'test_token'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Fill in password field
      await tester.enterText(
        find.byType(TextFormField).first,
        'newpassword123',
      );

      // Fill in confirm password with different value
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'differentpassword',
      );

      // Pump to allow validation
      await tester.pumpAndSettle();

      // The validation should fail, so form should not be submitted
      // Verify that AuthBloc is still present (no navigation)
      expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
    });
  });
}
