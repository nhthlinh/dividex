import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';

class MessageCode {
  // Register
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String phoneNumberAlreadyExists = 'PHONE_NUMBER_ALREADY_EXISTS';

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
      default:
        return 'Unknown error';
    }
  }
}