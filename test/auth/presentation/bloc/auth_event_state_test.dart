import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

void main() {
  group('AuthEvent', () {
    test('AuthLoginRequested has correct properties', () {
      const event = AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(event.email, 'test@example.com');
      expect(event.password, 'password123');
      expect(event.props, ['test@example.com', 'password123']);
    });

    test('AuthLoginRequested equality works correctly', () {
      const event1 = AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      );
      const event2 = AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      );
      const event3 = AuthLoginRequested(
        email: 'other@example.com',
        password: 'password123',
      );

      expect(event1, event2);
      expect(event1, isNot(event3));
    });

    test('AuthLogoutRequested has correct properties', () {
      const event = AuthLogoutRequested();

      expect(event.props, []);
    });

    test('AuthCheckRequested has correct properties', () {
      const event = AuthCheckRequested();

      expect(event.props, []);
    });

    test('AuthRegisterRequested has correct properties', () {
      final user = UserModel(
        email: 'test@example.com',
        fullName: 'Test User',
      );
      final event = AuthRegisterRequested(
        userData: user,
        password: 'password123',
      );

      expect(event.userData, user);
      expect(event.password, 'password123');
    });

    test('AuthEmailRequested has correct properties', () {
      const event = AuthEmailRequested(email: 'test@example.com');

      expect(event.email, 'test@example.com');
      expect(event.props, ['test@example.com']);
    });

    test('AuthOtpSubmitted has correct properties', () {
      const event = AuthOtpSubmitted(
        otp: '123456',
        email: 'test@example.com',
      );

      expect(event.otp, '123456');
      expect(event.email, 'test@example.com');
      expect(event.props, ['123456', 'test@example.com']);
    });

    test('AuthResetPasswordRequested has correct properties', () {
      const event = AuthResetPasswordRequested(
        newPassword: 'newpassword123',
        token: 'reset_token',
      );

      expect(event.newPassword, 'newpassword123');
      expect(event.token, 'reset_token');
    });

    test('AuthChangePasswordRequested has correct properties', () {
      const event = AuthChangePasswordRequested(
        newPassword: 'newpassword123',
        oldPassword: 'oldpassword123',
      );

      expect(event.newPassword, 'newpassword123');
      expect(event.oldPassword, 'oldpassword123');
    });
  });

  group('AuthState', () {
    test('AuthInitial is a valid state', () {
      final state = AuthInitial();

      expect(state, isA<AuthState>());
      expect(state.props, []);
    });

    test('AuthLoading is a valid state', () {
      final state = AuthLoading();

      expect(state, isA<AuthState>());
      expect(state.props, []);
    });

    test('AuthAuthenticated has correct properties', () {
      const state = AuthAuthenticated();

      expect(state, isA<AuthState>());
      expect(state.props, []);
    });

    test('AuthAuthenticated equality works correctly', () {
      const state1 = AuthAuthenticated();
      const state2 = AuthAuthenticated();

      expect(state1, state2);
    });

    test('AuthUnauthenticated is a valid state', () {
      final state = AuthUnauthenticated();

      expect(state, isA<AuthState>());
      expect(state.props, []);
    });

    test('AuthEmailSent has correct properties', () {
      const state = AuthEmailSent(email: 'test@example.com');

      expect(state.email, 'test@example.com');
      expect(state.props, ['test@example.com']);
    });

    test('AuthEmailSent equality works correctly', () {
      const state1 = AuthEmailSent(email: 'test@example.com');
      const state2 = AuthEmailSent(email: 'test@example.com');
      const state3 = AuthEmailSent(email: 'other@example.com');

      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('AuthEmailChecked has correct properties', () {
      const state = AuthEmailChecked(
        email: 'test@example.com',
        token: 'reset_token',
        isValid: true,
      );

      expect(state.email, 'test@example.com');
      expect(state.token, 'reset_token');
      expect(state.isValid, true);
      expect(state.props, ['test@example.com', 'reset_token', true]);
    });

    test('AuthEmailChecked equality works correctly', () {
      const state1 = AuthEmailChecked(
        email: 'test@example.com',
        token: 'reset_token',
        isValid: true,
      );
      const state2 = AuthEmailChecked(
        email: 'test@example.com',
        token: 'reset_token',
        isValid: true,
      );
      const state3 = AuthEmailChecked(
        email: 'test@example.com',
        token: 'reset_token',
        isValid: false,
      );

      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('AuthEmailTimeout has correct properties', () {
      const state = AuthEmailTimeout(email: 'test@example.com');

      expect(state.email, 'test@example.com');
      expect(state.props, ['test@example.com']);
    });
  });
}
