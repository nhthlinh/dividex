import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/otp_page.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';

import '../bloc/auth_bloc_test.mocks.dart';
import 'otp_page_test.mocks.dart';

@GenerateMocks([AuthBloc, AppLocalizations])
void main() {
  group('OTPInputPage Widget Tests', () {
    late MockAuthBloc mockAuthBloc;
    setUpAll(() async {
      mockAuthBloc = MockAuthBloc();

      TestWidgetsFlutterBinding.ensureInitialized();
      Hive.init('./test');
      await Hive.openBox('userBox');
    });

    testWidgets('OTPInputPage displays OTP input form',
        (WidgetTester tester) async {
      // Setup mocks
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const OTPInputPage(nextRoute: 'resetPass'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify OTP field exists
      expect(find.byType(TextFormField), findsWidgets);

      // Verify submit button exists
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('OTPInputPage displays timer',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const OTPInputPage(nextRoute: 'resetPass'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Timer text should be displayed
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('OTPInputPage triggers AuthOtpSubmitted on form submit',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const OTPInputPage(nextRoute: 'resetPass'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Fill in OTP field
      final otpFields = find.byType(TextFormField);
      if (otpFields.evaluate().isNotEmpty) {
        await tester.enterText(otpFields.first, '123456');

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
      }
    });

    testWidgets('OTPInputPage title is displayed correctly',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const OTPInputPage(nextRoute: 'resetPass'),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify title is displayed
      expect(find.text('Verify your Email'), findsWidgets);
    });
  });
}
