import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/pages/login_and_forgot_pass_flow/login_page.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  
  setUpAll(() {
    registerFallbackValue(FakeAuthState());
  });

  testWidgets('LoginScreen shows login button', (tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream)
        .thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    expect(
    find.widgetWithText(CustomButton, 'Login'),
      findsOneWidget,
    );

  });
}
