import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';

// ⚠️ import class localization cụ thể (thường là AppLocalizationsEn)
import 'package:Dividex/config/l10n/app_localizations_en.dart';

void main() {
  late CustomValidator validator;
  late AppLocalizations intl;

  setUp(() {
    validator = CustomValidator();
    intl = AppLocalizationsEn();
  });

  group('Email validation', () {
    test('Empty email returns error1', () {
      expect(validator.validateEmail('', intl), intl.emailInputError1);
    });

    test('Invalid email returns error2', () {
      expect(
        validator.validateEmail('abc', intl),
        intl.emailInputError2,
      );
    });

    test('Valid email returns null', () {
      expect(
        validator.validateEmail('test@mail.com', intl),
        isNull,
      );
    });
  });

  group('Password validation', () {
    test('Empty password returns error1', () {
      expect(
        validator.validatePassword('', intl),
        intl.passInputError1,
      );
    });

    test('Short password returns error2', () {
      expect(
        validator.validatePassword('Ab1@', intl),
        intl.passInputError2,
      );
    });

    test('Missing required characters returns error3', () {
      expect(
        validator.validatePassword('abcdefgh', intl),
        intl.passInputError3,
      );
    });

    test('Valid password returns null', () {
      expect(
        validator.validatePassword('Abcdef@1', intl),
        isNull,
      );
    });
  });

  group('Confirm password validation', () {
    test('Empty confirm password returns error1', () {
      final controller = TextEditingController(text: 'Abcdef@1');
      expect(
        validator.validateConfirmPassword('', intl, controller),
        intl.passInputError1,
      );
    });

    test('Password mismatch returns error4', () {
      final controller = TextEditingController(text: 'Abcdef@1');
      expect(
        validator.validateConfirmPassword('Wrong@1', intl, controller),
        intl.passInputError4,
      );
    });

    test('Matching password returns null', () {
      final controller = TextEditingController(text: 'Abcdef@1');
      expect(
        validator.validateConfirmPassword('Abcdef@1', intl, controller),
        isNull,
      );
    });
  });

  group('Event date validation', () {
    test('Empty start date returns error', () {
      final start = TextEditingController(text: '');
      final end = TextEditingController(text: '10/01/2025');

      expect(
        validator.validateDateForEvent(intl, start, end),
        intl.eventStartError1,
      );
    });

    test('Invalid start date format returns error', () {
      final start = TextEditingController(text: 'invalid');
      final end = TextEditingController(text: '10/01/2025');

      expect(
        validator.validateDateForEvent(intl, start, end),
        intl.eventStartError2,
      );
    });

    test('Start date after end date returns error', () {
      final start = TextEditingController(text: '12/01/2025');
      final end = TextEditingController(text: '10/01/2025');

      expect(
        validator.validateDateForEvent(intl, start, end),
        intl.eventStartAfterEndError,
      );
    });

    test('Valid event dates return null', () {
      final start = TextEditingController(text: '10/01/2025');
      final end = TextEditingController(text: '12/01/2025');

      expect(
        validator.validateDateForEvent(intl, start, end),
        isNull,
      );
    });
  });

  group('Phone number validation', () {
    test('Empty phone returns error1', () {
      expect(
        validator.validatePhoneNumber('', intl),
        intl.phoneInputError1,
      );
    });

    test('Invalid phone returns error2', () {
      expect(
        validator.validatePhoneNumber('123', intl),
        intl.phoneInputError2,
      );
    });

    test('Valid phone returns null', () {
      expect(
        validator.validatePhoneNumber('0912345678', intl),
        isNull,
      );
    });
  });

  group('Name validation', () {
    test('Empty name returns error1', () {
      expect(
        validator.validateName('', intl),
        intl.nameInputError1,
      );
    });

    test('Too short name returns error2', () {
      expect(
        validator.validateName('A', intl),
        intl.nameInputError2,
      );
    });

    test('Valid name returns null', () {
      expect(
        validator.validateName('John Doe', intl),
        isNull,
      );
    });
  });

  group('Amount validation', () {
    test('Empty amount returns error1', () {
      expect(
        validator.validateAmount('', intl),
        intl.amountInputError1,
      );
    });

    test('Non-numeric amount returns error2', () {
      expect(
        validator.validateAmount('abc', intl),
        intl.amountInputError2,
      );
    });

    test('Zero or negative amount returns error3', () {
      expect(
        validator.validateAmount('0', intl),
        intl.amountInputError3,
      );
    });

    test('Valid amount returns null', () {
      expect(
        validator.validateAmount('1,000.5', intl),
        isNull,
      );
    });
  });

  group('Number input validation', () {
    test('Empty number returns error1', () {
      expect(
        validator.validateNumberInput('', intl),
        intl.numberInputError1,
      );
    });

    test('Non-digit number returns error2', () {
      expect(
        validator.validateNumberInput('12a', intl),
        intl.numberInputError2,
      );
    });

    test('Valid number returns null', () {
      expect(
        validator.validateNumberInput('123456', intl),
        isNull,
      );
    });
  });

  group('OTP validation', () {
    test('Empty otp returns error1', () {
      expect(
        validator.validateOtp('', intl),
        intl.otpInputError1,
      );
    });

    test('Invalid otp returns error2', () {
      expect(
        validator.validateOtp('123', intl),
        intl.otpInputError2,
      );
    });

    test('Valid otp returns null', () {
      expect(
        validator.validateOtp('123456', intl),
        isNull,
      );
    });
  });
}
