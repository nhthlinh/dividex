import 'package:flutter_test/flutter_test.dart';
import 'package:Dividex/features/auth/data/models/token_respond_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

void main() {
  group('AuthResponseModel', () {
    test('should create instance with all required fields', () {
      final user = UserModel(
        id: '123',
        email: 'test@example.com',
        fullName: 'Test User',
      );
      final response = AuthResponseModel(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        user: user,
      );

      expect(response.accessToken, 'access_token');
      expect(response.refreshToken, 'refresh_token');
      expect(response.user.id, '123');
      expect(response.user.email, 'test@example.com');
    });

    test('should create instance from JSON', () {
      final json = {
        'access_token': 'access_token_123',
        'refresh_token': 'refresh_token_456',
        'user': {
          'uid': 'user_123',
          'email': 'user@example.com',
          'full_name': 'John Doe',
          'phone_number': '+1234567890',
          'avatar_url': 'https://example.com/avatar.jpg',
          'has_debt': false,
          'amount': 100.0,
        }
      };

      final response = AuthResponseModel.fromJson(json);

      expect(response.accessToken, 'access_token_123');
      expect(response.refreshToken, 'refresh_token_456');
      expect(response.user.id, 'user_123');
      expect(response.user.email, 'user@example.com');
      expect(response.user.fullName, 'John Doe');
      expect(response.user.phoneNumber, '+1234567890');
      expect(response.user.avatar, 'https://example.com/avatar.jpg');
      expect(response.user.hasDebt, false);
      expect(response.user.amount, 100.0);
    });

    test('should handle JSON with missing user fields', () {
      final json = {
        'access_token': 'access_token_123',
        'refresh_token': 'refresh_token_456',
        'user': {
          'uid': 'user_123',
        }
      };

      final response = AuthResponseModel.fromJson(json);

      expect(response.accessToken, 'access_token_123');
      expect(response.user.id, 'user_123');
      expect(response.user.email, null);
      expect(response.user.fullName, null);
    });

    test('should handle alternative user ID field name', () {
      final json = {
        'access_token': 'access_token_123',
        'refresh_token': 'refresh_token_456',
        'user': {
          'friend_uid': 'friend_123',
          'email': 'friend@example.com',
        }
      };

      final response = AuthResponseModel.fromJson(json);

      expect(response.user.id, 'friend_123');
      expect(response.user.email, 'friend@example.com');
    });

    test('should handle numeric amount as double', () {
      final json = {
        'access_token': 'access_token_123',
        'refresh_token': 'refresh_token_456',
        'user': {
          'uid': 'user_123',
          'amount': 50, // int instead of double
        }
      };

      final response = AuthResponseModel.fromJson(json);

      expect(response.user.amount, 50.0);
      expect(response.user.amount is double, true);
    });
  });
}