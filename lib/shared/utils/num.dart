import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatNumber(num value) {
  final formatter = NumberFormat.decimalPattern('vi_VN');
  return formatter.format(value);
}

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###", "vi_VN");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Nếu rỗng thì giữ nguyên
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Loại bỏ mọi ký tự không phải số
    final cleaned = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final value = double.tryParse(cleaned) ?? 0;

    // Format lại (chuyển , -> . cho Việt Nam)
    final formatted = _formatter.format(value).replaceAll(',', '.');

    // Tính vị trí con trỏ mới
    int selectionIndex = formatted.length - (oldValue.text.length - oldValue.selection.end);

    // Giữ con trỏ trong phạm vi an toàn
    if (selectionIndex < 0) selectionIndex = 0;
    if (selectionIndex > formatted.length) selectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
