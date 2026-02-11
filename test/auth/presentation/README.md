# Auth Feature Presentation Layer Tests

This directory contains comprehensive unit and widget tests for the `features/auth/presentation` layer of the Dividex application.

## Test Structure

### BLoC Tests

#### `bloc/auth_bloc_test.dart`
Tests for the `AuthBloc` event handlers and state emissions.

**Test Groups:**
- **AuthRegisterRequested**: Tests user registration flow
  - ✓ Emits [AuthLoading, AuthAuthenticated] on successful registration
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on registration failure

- **AuthLoginRequested**: Tests user login flow
  - ✓ Emits [AuthLoading, AuthAuthenticated] on successful login
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on login failure

- **AuthLogoutRequested**: Tests user logout flow
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on successful logout
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on logout failure

- **AuthCheckRequested**: Tests auth state checking on app startup
  - ✓ Emits [AuthLoading, AuthAuthenticated/AuthUnauthenticated] based on token

- **AuthEmailRequested**: Tests email submission for password reset
  - ✓ Emits [AuthLoading, AuthEmailSent] on successful email request
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on email not found

- **AuthOtpSubmitted**: Tests OTP validation
  - ✓ Emits [AuthLoading, AuthEmailChecked] on valid OTP
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on invalid OTP

- **AuthResetPasswordRequested**: Tests password reset
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on successful reset
  - ✓ Emits [AuthLoading, AuthUnauthenticated] on invalid token

- **AuthChangePasswordRequested**: Tests password change for authenticated users
  - ✓ Emits [AuthLoading, AuthAuthenticated] on successful change
  - ✓ Emits [AuthLoading, AuthAuthenticated] on incorrect old password

#### `bloc/auth_event_state_test.dart`
Tests for the `AuthEvent` and `AuthState` classes to verify their properties and equality.

**Test Groups:**
- **AuthEvent Tests**: Verify event properties and equality
- **AuthState Tests**: Verify state properties and equality

### Widget Tests

#### `pages/login_page_test.dart`
Widget tests for the `LoginPage` component.

**Test Cases:**
- ✓ Displays login form with email and password fields
- ✓ Shows password visibility toggle
- ✓ Triggers AuthLoginRequested on form submit
- ✓ Navigates to register page
- ✓ Displays forgot password link

#### `pages/register_page_test.dart`
Widget tests for the `RegisterPage` component.

**Test Cases:**
- ✓ Displays registration form with all required fields (name, email, phone, password)
- ✓ Shows password visibility toggle
- ✓ Triggers AuthRegisterRequested on form submit
- ✓ Navigates to login page
- ✓ Disables register button when form is invalid
- ✓ Displays welcome message

#### `pages/email_input_page_test.dart`
Widget tests for the `EmailInputPage` (password reset flow).

**Test Cases:**
- ✓ Displays email input form
- ✓ Triggers AuthEmailRequested on form submit
- ✓ Displays correct title

#### `pages/otp_page_test.dart`
Widget tests for the `OTPInputPage` (OTP verification).

**Test Cases:**
- ✓ Displays OTP input form
- ✓ Displays timer
- ✓ Triggers AuthOtpSubmitted on form submit
- ✓ Displays correct title

#### `pages/reset_pass_page_test.dart`
Widget tests for the `ResetPassPage` (password reset).

**Test Cases:**
- ✓ Displays password reset form
- ✓ Shows password visibility toggle
- ✓ Triggers AuthResetPasswordRequested on submit
- ✓ Displays correct title
- ✓ Validates password confirmation

## Running Tests

### Run all auth presentation tests:
```bash
flutter test test/auth/presentation/
```

### Run specific test file:
```bash
flutter test test/auth/presentation/bloc/auth_bloc_test.dart
flutter test test/auth/presentation/pages/login_page_test.dart
```

### Run tests with coverage:
```bash
flutter test --coverage test/auth/presentation/
```

## Test Dependencies

The tests use the following packages:
- `flutter_test`: Flutter testing framework
- `bloc_test`: BLoC testing utilities
- `mockito`: Mocking framework
- `mockito:^5.5.0`: Mock generation using `@GenerateMocks`

## Generating Mocks

If you add new dependencies to the BLoCs or pages, you may need to regenerate the mock files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Coverage

These tests provide comprehensive coverage of:
- ✓ All BLoC event handlers
- ✓ All state transitions
- ✓ Event and State equality
- ✓ Widget rendering and user interactions
- ✓ Navigation triggers
- ✓ Form validation
- ✓ Localization integration
- ✓ Error handling

## Key Testing Patterns

### 1. BLoC Testing with bloc_test
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login is successful',
  build: () => AuthBloc(),
  act: (bloc) => bloc.add(AuthLoginRequested(...)),
  expect: () => [AuthLoading(), AuthAuthenticated()],
);
```

### 2. Widget Testing with Widget Tester
```dart
testWidgets('LoginPage displays login form', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: BlocProvider.value(
      value: mockAuthBloc,
      child: const LoginPage(),
    ),
  ));
  
  expect(find.byType(TextFormField), findsWidgets);
});
```

### 3. Mocking with Mockito
```dart
@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;
  
  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.state).thenReturn(AuthInitial());
  });
}
```

## Notes

- All widget tests use mocked `AuthBloc` and `AppLocalizations` to isolate UI testing
- BLoC tests use mockito to mock the use cases and dependencies
- Tests follow the AAA (Arrange-Act-Assert) pattern for clarity
- Mocks are generated using `@GenerateMocks` annotation and `build_runner`

## Future Improvements

- Add integration tests combining BLoC and pages
- Add more edge case tests
- Add performance tests for large form submissions
- Add accessibility tests using Semantics
