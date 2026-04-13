import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late CustomValidator validator;
  late AppLocalizations intl;

  setUp(() {
    validator = CustomValidator();
    intl = _MockAppLocalizations();

    when(() => intl.emailInputError1).thenReturn('email-empty');
    when(() => intl.emailInputError2).thenReturn('email-invalid');

    when(() => intl.passInputError1).thenReturn('password-empty');
    when(() => intl.passInputError2).thenReturn('password-too-short');
    when(() => intl.passInputError3).thenReturn('password-weak');
    when(() => intl.passInputError4).thenReturn('password-not-match');

    when(() => intl.eventStartError1).thenReturn('start-empty');
    when(() => intl.eventEndError1).thenReturn('end-empty');
    when(() => intl.eventStartError2).thenReturn('start-invalid');
    when(() => intl.eventEndError2).thenReturn('end-invalid');
    when(() => intl.eventStartAfterEndError).thenReturn('start-after-end');
    when(() => intl.eventEndBeforeStartError).thenReturn('end-before-start');

    when(() => intl.phoneInputError1).thenReturn('phone-empty');
    when(() => intl.phoneInputError2).thenReturn('phone-invalid');

    when(() => intl.nameInputError1).thenReturn('name-empty');
    when(() => intl.nameInputError2).thenReturn('name-invalid');

    when(() => intl.amountInputError1).thenReturn('amount-empty');
    when(() => intl.amountInputError2).thenReturn('amount-not-number');
    when(() => intl.amountInputError3).thenReturn('amount-non-positive');

    when(() => intl.numberInputError1).thenReturn('number-empty');
    when(() => intl.numberInputError2).thenReturn('number-invalid');

    when(() => intl.otpInputError1).thenReturn('otp-empty');
    when(() => intl.otpInputError2).thenReturn('otp-invalid');

    when(() => intl.pinInputError1).thenReturn('pin-empty');
    when(() => intl.pinInputError2).thenReturn('pin-invalid');
  });

  group('CustomValidator.validateEmail', () {
    test('returns error when email is null', () {
      final result = validator.validateEmail(null, intl);
      expect(result, 'email-empty');
    });

    test('returns error when email format is invalid', () {
      final result = validator.validateEmail('invalid-email', intl);
      expect(result, 'email-invalid');
    });

    test('returns null for valid email', () {
      final result = validator.validateEmail('john.doe@example.com', intl);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validatePassword', () {
    test('returns error when password is empty', () {
      final result = validator.validatePassword('', intl);
      expect(result, 'password-empty');
    });

    test('returns error when password is shorter than 8 chars', () {
      final result = validator.validatePassword('Aa1!', intl);
      expect(result, 'password-too-short');
    });

    test('returns error when password misses required character groups', () {
      final result = validator.validatePassword('abcdefgh', intl);
      expect(result, 'password-weak');
    });

    test('returns null for strong password', () {
      final result = validator.validatePassword('Abcd1234!', intl);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validateConfirmPassword', () {
    test('returns error when confirm password is empty', () {
      final controller = TextEditingController(text: 'Abcd1234!');
      final result = validator.validateConfirmPassword('', intl, controller);
      expect(result, 'password-empty');
    });

    test('returns error when confirm password does not match', () {
      final controller = TextEditingController(text: 'Abcd1234!');
      final result = validator.validateConfirmPassword(
        'Xyz1234!',
        intl,
        controller,
      );
      expect(result, 'password-not-match');
    });

    test('returns null when confirm password matches', () {
      final controller = TextEditingController(text: 'Abcd1234!');
      final result = validator.validateConfirmPassword(
        'Abcd1234!',
        intl,
        controller,
      );
      expect(result, isNull);
    });
  });

  group('CustomValidator.validateDateForEvent', () {
    test('returns error when start date is empty', () {
      final start = TextEditingController(text: '');
      final end = TextEditingController(text: '01/12/2026');

      final result = validator.validateDateForEvent(intl, start, end);
      expect(result, 'start-empty');
    });

    test('returns error when end date is empty', () {
      final start = TextEditingController(text: '01/11/2026');
      final end = TextEditingController(text: '');

      final result = validator.validateDateForEvent(intl, start, end);
      expect(result, 'end-empty');
    });

    test('returns error for invalid start date format', () {
      final start = TextEditingController(text: '2026-11-01');
      final end = TextEditingController(text: '01/12/2026');

      final result = validator.validateDateForEvent(intl, start, end);
      expect(result, 'start-invalid');
    });

    test('returns error for invalid end date format', () {
      final start = TextEditingController(text: '01/11/2026');
      final end = TextEditingController(text: '2026-12-01');

      final result = validator.validateDateForEvent(intl, start, end);
      expect(result, 'end-invalid');
    });

    test('returns error when start date is after end date', () {
      final start = TextEditingController(text: '02/12/2026');
      final end = TextEditingController(text: '01/12/2026');

      final result = validator.validateDateForEvent(intl, start, end);
      expect(result, 'start-after-end');
    });

    test('returns null when date range is valid', () {
      final start = TextEditingController(text: '01/12/2026');
      final end = TextEditingController(text: '02/12/2026');

      final result = validator.validateDateForEvent(intl, start, end);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validatePhoneNumber', () {
    test('returns error when phone number is empty', () {
      final result = validator.validatePhoneNumber('', intl);
      expect(result, 'phone-empty');
    });

    test('normalizes +84 and accepts valid Vietnam number', () {
      final result = validator.validatePhoneNumber('+84901234567', intl);
      expect(result, isNull);
    });

    test('returns error when phone length is invalid', () {
      final result = validator.validatePhoneNumber('090123456', intl);
      expect(result, 'phone-invalid');
    });

    test('returns error when phone prefix is invalid', () {
      final result = validator.validatePhoneNumber('0201234567', intl);
      expect(result, 'phone-invalid');
    });
  });

  group('CustomValidator.validateName', () {
    test('returns error when name is empty', () {
      final result = validator.validateName('', intl);
      expect(result, 'name-empty');
    });

    test('returns error when name is shorter than 2 chars', () {
      final result = validator.validateName('A', intl);
      expect(result, 'name-invalid');
    });

    test('returns null when name length is within range', () {
      final result = validator.validateName('Alice', intl);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validateAmount', () {
    test('returns error when amount is empty', () {
      final result = validator.validateAmount('   ', intl);
      expect(result, 'amount-empty');
    });

    test('returns error when amount is not numeric', () {
      final result = validator.validateAmount('12a3', intl);
      expect(result, 'amount-not-number');
    });

    test('returns error when amount is zero', () {
      final result = validator.validateAmount('0', intl);
      expect(result, 'amount-non-positive');
    });

    test('returns null for valid comma-formatted positive amount', () {
      final result = validator.validateAmount('1,234.50', intl);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validateNumberInput', () {
    test('returns error when number input is empty', () {
      final result = validator.validateNumberInput('', intl);
      expect(result, 'number-empty');
    });

    test('returns error when number input has non-digit chars', () {
      final result = validator.validateNumberInput('123a', intl);
      expect(result, 'number-invalid');
    });

    test('returns null for numeric input', () {
      final result = validator.validateNumberInput('123456', intl);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validateOtp', () {
    test('returns error when otp is empty', () {
      final result = validator.validateOtp('', intl);
      expect(result, 'otp-empty');
    });

    test('returns error when otp is not 6 digits', () {
      final result = validator.validateOtp('12345', intl);
      expect(result, 'otp-invalid');
    });

    test('returns null for valid 6-digit otp', () {
      final result = validator.validateOtp('123456', intl);
      expect(result, isNull);
    });
  });

  group('CustomValidator.validatePin', () {
    test('returns error when pin is empty', () {
      final result = validator.validatePin('', intl);
      expect(result, 'pin-empty');
    });

    test('returns error when pin is not 6 digits', () {
      final result = validator.validatePin('99999', intl);
      expect(result, 'pin-invalid');
    });

    test('returns null for valid 6-digit pin', () {
      final result = validator.validatePin('654321', intl);
      expect(result, isNull);
    });
  });
}
