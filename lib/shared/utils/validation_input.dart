import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomValidator {
  String? validateEmail(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.emailInputError1;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return intl.emailInputError2;
    }
    return null;
  }

  String? validatePassword(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.passInputError1;
    }

    if (value.length < 8) {
      return intl.passInputError2;
    }

    final missingUppercase = !RegExp(r'[A-Z]').hasMatch(value);
    final missingLowercase = !RegExp(r'[a-z]').hasMatch(value);
    final missingDigit = !RegExp(r'\d').hasMatch(value);
    final missingSpecial = !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (missingUppercase || missingLowercase || missingDigit || missingSpecial) {
      return intl.passInputError3;
    }

    return null; // hợp lệ
  }

  String? validateConfirmPassword(
    String? value,
    AppLocalizations intl,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return intl.passInputError1;
    }
    if (value != passwordController.text) {
      return intl.passInputError4;
    }
    return null; // valid
  }

  String? validateDateForEvent(
    AppLocalizations intl,
    TextEditingController startController,
    TextEditingController endController,
  ) {
    final startText = startController.text.trim();
    final endText = endController.text.trim();
    final dateFormat = DateFormat('dd/MM/yyyy');

    if (startText.isEmpty) {
      return intl.eventStartError1;
    }

    if (endText.isEmpty) {
      return intl.eventEndError1;
    }

    DateTime? startDate;
    DateTime? endDate;

    try {
      startDate = dateFormat.parse(startText);
    } catch (_) {
      return intl.eventStartError2; // "Ngày bắt đầu không hợp lệ"
    }

    try {
      endDate = dateFormat.parse(endText);
    } catch (_) {
      return intl.eventEndError2; // "Ngày kết thúc không hợp lệ"
    }

    if (startDate.isAfter(endDate)) {
      return intl
          .eventStartAfterEndError; // "Ngày bắt đầu không thể sau ngày kết thúc"
    }

    if (endDate.isBefore(startDate)) {
      return intl
          .eventEndBeforeStartError; // "Ngày kết thúc không thể trước ngày bắt đầu"
    }

    return null; // ✅ hợp lệ
  }

  String? validatePhoneNumber(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.phoneInputError1;
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value) && value.length < 10) {
      return intl.phoneInputError2; // "Số điện thoại không hợp lệ"
    }
    return null; // hợp lệ
  }

  String? validateName(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.nameInputError1;
    }
    if (value.length < 2 || value.length > 50) {
      return intl.nameInputError2;
    }

    return null; // hợp lệ
  }

  String? validateAmount(String? value, AppLocalizations intl) {
    if (value == null || value.trim().isEmpty) {
      return intl.amountInputError1;
    }

    // Thử parse số
    final parsed = double.tryParse(value.replaceAll(',', '').trim());
    if (parsed == null) {
      return intl.amountInputError2;
    }

    // Kiểm tra > 0
    if (parsed <= 0) {
      return intl.amountInputError3;
    }

    return null; // hợp lệ
  }

  String? validateNumberInput(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.numberInputError1;
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return intl.numberInputError2;
    }
    return null; // valid
  }

  String? validateOtp(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.otpInputError1;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return intl.otpInputError2;
    }
    return null; // valid
  }

  String? validatePin(String? value, AppLocalizations intl) {
    if (value == null || value.isEmpty) {
      return intl.pinInputError1;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return intl.pinInputError2;
    }
    return null; // valid
  }
}
