import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';

class MessageCode {
  // Register
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String phoneNumberAlreadyExists = 'PHONE_NUMBER_ALREADY_EXISTS';

  // Login
  static const String emailOrPasswordIncorrect = 'EMAIL_OR_PASSWORD_INCORRECT';

  // Change password
  static const String passwordIncorrect = 'PASSWORD_INCORRECT';

  // Create reset password token
  static const String invalidOrExpiredOtp = 'INVALID_OR_EXPIRED_OTP';

  // More
  static const String emailNotFound = 'EMAIL_NOT_FOUND';
  static const String userNotFound = 'USER_NOT_FOUND';

  String getMessage(String code) {
    final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
    switch (code) {
      case emailAlreadyExists:
        return intl.emailAlreadyExists;
      case phoneNumberAlreadyExists:
        return intl.phoneNumberAlreadyExists;
      case emailNotFound:
        return intl.emailNotFound;
      case userNotFound:
        return intl.userNotFound;
      case emailOrPasswordIncorrect:
        return intl.emailOrPasswordIncorrect;
      case passwordIncorrect:
        return intl.passwordIncorrect;
      default:
        return 'Unknown error';
    }
  }
}
