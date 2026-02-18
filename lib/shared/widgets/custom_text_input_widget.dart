// DONE

import 'package:flutter/material.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/services.dart';

enum InputType {
  text,
  number,
  password,
  email,
  phone,
  date,
  multiLine,
}

enum TextInputSize { large, medium, small }

class CustomTextInputWidget<T> extends StatelessWidget {
  final TextInputSize size;
  final String? label;
  final String? hintText;
  final TextEditingController controller;

  final bool? obscureText; // Ẩn hiện văn bản
  final String? Function(String?)? validator; // Hàm kiểm tra lỗi
  final TextInputType keyboardType;
  final bool isReadOnly; // Chỉ đọc
  final int? maxLines; // Số dòng tối đa (mặc định là 1)
  final bool isRequired; // Bắt buộc nhập
  final Widget? prefixIcon; // Icon ở đầu
  final Widget? suffixIcon; // Icon ở cuối
  final ValueChanged<String>? onChanged; // Hàm khi nội dung thay đổi
  final VoidCallback? onTap; // Hàm khi nhấn vào ô input
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextInputWidget({
    super.key,
    required this.size,
    this.label,
    this.hintText,
    required this.controller,
    this.validator,
    required this.keyboardType,
    required this.isReadOnly,
    this.maxLines,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.isRequired = false,
    this.obscureText = false,
    this.onTap,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    // Config cho từng size
    final sizeConfig = {
      TextInputSize.large: const Size(340, 70),
      TextInputSize.medium: const Size(150, 70),
      TextInputSize.small: const Size(70, 70),
    };

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width < 340
            ? MediaQuery.of(context).size.width - 32
            : sizeConfig[size]!.width,
        minHeight: sizeConfig[size]!.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            buildLabel(context),
            const SizedBox(height: 4),
          ],
          TextFormField(
            onTap: onTap ?? () {},
            obscureText: obscureText!,
            maxLines: maxLines ?? 1,
            readOnly: isReadOnly,
            keyboardType: keyboardType,
            validator:
                validator ??
                (isRequired
                    ? (value) =>
                          value == null || value.isEmpty ? 'Required' : null
                    : null),
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.next,
            decoration: inputDeco().copyWith(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppThemes.borderColor),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
            errorBuilder: (context, errorText) => Text(
              errorText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppThemes.errorColor,
                fontSize: 12,
              ),
            ),
            inputFormatters: inputFormatters,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  RichText buildLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 12,
          letterSpacing: 0,
          height: 16 / 12,
          color: Colors.grey,
        ),
        children: isRequired
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppThemes.primary3Color),
                ),
              ]
            : [],
      ),
    );
  }

  InputDecoration inputDeco() {
    return InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppThemes.borderColor, width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppThemes.borderColor, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppThemes.primary3Color, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppThemes.errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppThemes.errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
