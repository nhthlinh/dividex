# Auth Presentation Tests - Quick Start Guide

## Overview

This guide provides everything you need to know about running and working with the auth presentation layer tests in the Dividex project.

## Files Created

All test files have been created in the `test/auth/presentation/` directory:

### BLoC Tests
- `bloc/auth_bloc_test.dart` - Unit tests for AuthBloc (8 test groups, 16+ test cases)
- `bloc/auth_event_state_test.dart` - Unit tests for AuthEvent and AuthState classes

### Widget Tests
- `pages/login_page_test.dart` - Widget tests for LoginPage (5 test cases)
- `pages/register_page_test.dart` - Widget tests for RegisterPage (6 test cases)
- `pages/email_input_page_test.dart` - Widget tests for EmailInputPage (3 test cases)
- `pages/otp_page_test.dart` - Widget tests for OTPInputPage (4 test cases)
- `pages/reset_pass_page_test.dart` - Widget tests for ResetPassPage (5 test cases)

### Documentation
- `README.md` - Comprehensive test documentation

## Setup

### 1. Add Required Dependency

The `bloc_test` package has been added to `pubspec.yaml`. Run:

```bash
flutter pub get
```

### 2. Generate Mocks

Generate mock classes for the tests:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will create the following mock files:
- `test/auth/presentation/bloc/auth_bloc_test.mocks.dart`
- `test/auth/presentation/pages/login_page_test.mocks.dart`
- `test/auth/presentation/pages/register_page_test.mocks.dart`
- `test/auth/presentation/pages/email_input_page_test.mocks.dart`
- `test/auth/presentation/pages/otp_page_test.mocks.dart`
- `test/auth/presentation/pages/reset_pass_page_test.mocks.dart`

## Running Tests

### Run All Auth Presentation Tests
```bash
flutter test test/auth/presentation/
```

### Run Specific Test File
```bash
# BLoC tests
flutter test test/auth/presentation/bloc/auth_bloc_test.dart

# Widget tests
flutter test test/auth/presentation/pages/login_page_test.dart
flutter test test/auth/presentation/pages/register_page_test.dart
```

### Run Tests with Verbose Output
```bash
flutter test test/auth/presentation/ -v
```

### Run Tests with Coverage
```bash
flutter test test/auth/presentation/ --coverage
```

To view coverage report (on macOS/Linux):
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Single Test Case
```bash
flutter test test/auth/presentation/bloc/auth_bloc_test.dart --name "AuthRegisterRequested"
```

## Test Structure

### BLoC Test Pattern (bloc_test)

```dart
blocTest<AuthBloc, AuthState>(
  'test description',
  build: () => AuthBloc(),           // Create bloc instance
  act: (bloc) => bloc.add(...),      // Trigger action
  expect: () => [              // Expected state emissions
    isA<AuthLoading>(),
    isA<AuthAuthenticated>(),
  ],
);
```

### Widget Test Pattern

```dart
testWidgets('widget test description', (tester) async {
  // Setup
  when(mockAuthBloc.state).thenReturn(AuthInitial());
  
  // Build widget
  await tester.pumpWidget(MaterialApp(
    home: BlocProvider.value(
      value: mockAuthBloc,
      child: const LoginPage(),
    ),
  ));
  
  // Verify
  expect(find.byType(TextFormField), findsWidgets);
});
```

## Troubleshooting

### Issue: Mock files not generated
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: "Cannot find implementation of" errors
**Solution:** Ensure all `@GenerateMocks` annotations are present in test files

### Issue: Tests timeout
**Solution:** Add longer timeout: `testWidgets(..., (tester) async { ... }, timeout: Duration(minutes: 2))`

### Issue: Widget tests fail with "No widget found"
**Solution:** Use `await tester.pumpWidget()` to render the widget first, then `await tester.pumpAndSettle()` for animations

## Test Coverage Goals

The auth presentation tests aim to cover:
- ✓ All BLoC event handlers
- ✓ All state transitions
- ✓ Form validation logic
- ✓ Navigation triggers
- ✓ Error handling
- ✓ User interactions
- ✓ Localization integration

## Adding New Tests

When adding new features to auth/presentation:

1. **Create test file** in appropriate directory
2. **Add test class** with `@GenerateMocks` if mocking dependencies
3. **Run build_runner** to generate mocks:
   ```bash
   flutter pub run build_runner build
   ```
4. **Write test cases** following existing patterns
5. **Run tests** to verify:
   ```bash
   flutter test test/auth/presentation/
   ```

## Useful Test Matchers

In auth presentation tests, you'll commonly use:

```dart
// State matchers
isA<AuthLoading>()
isA<AuthAuthenticated>()
isA<AuthUnauthenticated>()
isA<AuthEmailSent>()

// Widget finders
find.byType(TextFormField)
find.byType(ElevatedButton)
find.byIcon(Icons.visibility_off)
find.text('Login')

// Expectations
expect(find.byType(Widget), findsOneWidget)
expect(find.byType(Widget), findsWidgets)
expect(find.byType(Widget), findsNothing)
```

## Continuous Integration

Add to your CI/CD pipeline:

```yaml
# Example: GitHub Actions
- name: Run Tests
  run: flutter test test/auth/presentation/

- name: Generate Coverage
  run: flutter test --coverage test/auth/presentation/
```

## References

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [bloc_test Documentation](https://pub.dev/packages/bloc_test)
- [Mockito Guide](https://pub.dev/packages/mockito)
- [Widget Testing Best Practices](https://flutter.dev/docs/testing/testing#testing-widgets)

## Support

For issues or questions about the tests:
1. Check the test documentation in `README.md`
2. Review similar test files for patterns
3. Run tests with `-v` flag for detailed output
4. Check `build_runner` logs for mock generation issues
