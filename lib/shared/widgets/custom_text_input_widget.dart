import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final String? label; // Optional label
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isReadOnly;
  final int? maxLines;
  final Widget? suffixIcon; // Thêm thuộc tính cho icon ở cuối
  final VoidCallback? onTap; // Thêm thuộc tính cho hàm khi tap
  final List<TextInputFormatter>? inputFormatters;
  final Icon? prefixIcon;
  final TextStyle? style; // Thêm thuộc tính cho icon ở đầu
  final bool autoFocus; // Thêm thuộc tính để tự động focus vào TextFormField
  final bool isFullWidth;
  final Function(String value)?
  onChanged; // Thêm thuộc tính để xác định hàm khi thay đổi nội dung

  const CustomTextInput({
    super.key,
    this.label,
    this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.isReadOnly = false,
    this.maxLines,
    this.suffixIcon, // Khởi tạo suffixIcon
    this.onTap, // Khởi tạo onTap
    this.inputFormatters,
    this.prefixIcon,
    this.style,
    this.autoFocus = false,
    this.isFullWidth = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 300;
    final double width = isSmallScreen
        ? MediaQuery.of(context).size.width - 32
        : 350;

    return SizedBox(
      width: isFullWidth ? width : 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).primaryColor, // Màu chữ của label
              ),
            ),
            const SizedBox(height: 6),
          ],
          TextFormField(
            autofocus: autoFocus,
            style: style ?? Theme.of(context).textTheme.bodySmall,
            maxLines: maxLines,
            readOnly: isReadOnly,
            keyboardType: keyboardType,
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            onTap: onTap, // Gán hàm onTap vào TextFormField
            inputFormatters: inputFormatters,
            onChanged: onChanged ?? (value) {}, // Đảm bảo luôn có hàm onChanged
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // dd/MM/yyyy
    if (text.length == 2 && oldValue.text.length < newValue.text.length) {
      return newValue.copyWith(
        text: '$text/',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
    if (text.length == 5 && oldValue.text.length < newValue.text.length) {
      return newValue.copyWith(
        text: '$text/',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }

    // Loại bỏ các ký tự không phải số hoặc '/'
    final newText = text.replaceAll(RegExp(r'[^0-9/]'), '');
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
