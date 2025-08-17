import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget CustomDropdownWidget({
  required String label,
  required String? value,
  required Function(String?)? onChanged,
  required List<DropdownMenuItem<String>> items,
  bool isSmall = false,
}) {
  final context = navigatorKey.currentContext!;

  // Tìm xem giá trị value có nằm trong items không
  final bool isValueValid =
      value != null && items.any((item) => item.value == value);

  // Nếu value không hợp lệ (null hoặc không nằm trong list) → set về null
  final String? safeValue = isValueValid ? value : null;

  // Thêm item mặc định nếu cần thiết
  final bool hasEmptyItem = items.any(
    (item) => item.value == null || item.value == '',
  );
  final List<DropdownMenuItem<String>> displayItems = [
    if (!hasEmptyItem)
      const DropdownMenuItem<String>(value: '', child: Text('-- --')),
    ...items,
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: safeValue,
        items: displayItems,
        onChanged: onChanged,
        decoration: const InputDecoration(
          // Bỏ qua AppTheme bằng cách set đầy đủ tất cả border
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppThemes.primary3Color, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppThemes.primary1Color, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
