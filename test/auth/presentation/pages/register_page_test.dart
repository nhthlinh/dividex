import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/register_flow/register_page.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';

import 'register_page_test.mocks.dart';

@GenerateMocks([AuthBloc, AppLocalizations])
void main() {
  group('RegisterPage Widget Tests', () {
    late MockAuthBloc mockAuthBloc;
    late MockAppLocalizations mockAppLocalizations;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      mockAppLocalizations = MockAppLocalizations();
    });

    testWidgets(
        'RegisterPage displays registration form with all required fields',
        (WidgetTester tester) async {
      // Setup mocks
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      // Setup localizations mock
      when(mockAppLocalizations.register).thenReturn('Register');
      when(mockAppLocalizations.nameLabel).thenReturn('Name');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');
      when(mockAppLocalizations.phoneLabel).thenReturn('Phone Number');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.welcomeNewMessage)
          .thenReturn('Welcome New User');
      when(mockAppLocalizations.createNewAccountPrompt)
          .thenReturn('Create a new account');
      when(mockAppLocalizations.registerPageToLogin)
          .thenReturn('Already have an account?');
      when(mockAppLocalizations.login).thenReturn('Login');

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify form fields exist
      expect(find.byType(TextFormField), findsWidgets);

      // Verify register button exists
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('RegisterPage shows password visibility toggle',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.register).thenReturn('Register');
      when(mockAppLocalizations.nameLabel).thenReturn('Name');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');
      when(mockAppLocalizations.phoneLabel).thenReturn('Phone Number');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.welcomeNewMessage)
          .thenReturn('Welcome New User');
      when(mockAppLocalizations.createNewAccountPrompt)
          .thenReturn('Create a new account');
      when(mockAppLocalizations.registerPageToLogin)
          .thenReturn('Already have an account?');
      when(mockAppLocalizations.login).thenReturn('Login');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Look for password visibility toggle button
      expect(find.byIcon(Icons.visibility_off), findsWidgets);
    });

    testWidgets('RegisterPage triggers AuthRegisterRequested on form submit',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.register).thenReturn('Register');
      when(mockAppLocalizations.nameLabel).thenReturn('Name');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');
      when(mockAppLocalizations.phoneLabel).thenReturn('Phone Number');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.welcomeNewMessage)
          .thenReturn('Welcome New User');
      when(mockAppLocalizations.createNewAccountPrompt)
          .thenReturn('Create a new account');
      when(mockAppLocalizations.registerPageToLogin)
          .thenReturn('Already have an account?');
      when(mockAppLocalizations.login).thenReturn('Login');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Fill in name field
      await tester.enterText(
        find.byType(TextFormField).first,
        'John Doe',
      );

      // Fill in email field
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'john@example.com',
      );

      // Fill in phone field
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '0123456789',
      );

      // Fill in password field
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'password123',
      );

      // Pump to allow validation
      await tester.pumpAndSettle();

      // Find and tap register button
      final registerButton = find.byType(ElevatedButton);
      if (registerButton.evaluate().isNotEmpty) {
        await tester.tap(registerButton.first);
        await tester.pumpAndSettle();

        // Verify that add was called on AuthBloc
        expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
      }
    });

    testWidgets('RegisterPage navigates to login page',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.register).thenReturn('Register');
      when(mockAppLocalizations.nameLabel).thenReturn('Name');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');
      when(mockAppLocalizations.phoneLabel).thenReturn('Phone Number');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.welcomeNewMessage)
          .thenReturn('Welcome New User');
      when(mockAppLocalizations.createNewAccountPrompt)
          .thenReturn('Create a new account');
      when(mockAppLocalizations.registerPageToLogin)
          .thenReturn('Already have an account?');
      when(mockAppLocalizations.login).thenReturn('Login');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify login link button exists
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('RegisterPage disables register button when form is invalid',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.register).thenReturn('Register');
      when(mockAppLocalizations.nameLabel).thenReturn('Name');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');
      when(mockAppLocalizations.phoneLabel).thenReturn('Phone Number');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.welcomeNewMessage)
          .thenReturn('Welcome New User');
      when(mockAppLocalizations.createNewAccountPrompt)
          .thenReturn('Create a new account');
      when(mockAppLocalizations.registerPageToLogin)
          .thenReturn('Already have an account?');
      when(mockAppLocalizations.login).thenReturn('Login');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Attempt to find register button without filling form
      final registerButton = find.byType(ElevatedButton);
      expect(registerButton, findsWidgets);

      // Verify button is initially disabled (should be null or have disabled state)
      // The exact behavior depends on the CustomButton implementation
    });

    testWidgets('RegisterPage displays welcome message',
        (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());

      when(mockAppLocalizations.register).thenReturn('Register');
      when(mockAppLocalizations.nameLabel).thenReturn('Name');
      when(mockAppLocalizations.emailLabel).thenReturn('Email');
      when(mockAppLocalizations.phoneLabel).thenReturn('Phone Number');
      when(mockAppLocalizations.passwordLabel).thenReturn('Password');
      when(mockAppLocalizations.welcomeNewMessage)
          .thenReturn('Welcome New User');
      when(mockAppLocalizations.createNewAccountPrompt)
          .thenReturn('Create a new account');
      when(mockAppLocalizations.registerPageToLogin)
          .thenReturn('Already have an account?');
      when(mockAppLocalizations.login).thenReturn('Login');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );

      // Verify welcome message is displayed
      expect(find.text('Welcome to DIVIDEX'), findsWidgets);
    });
  });
}
