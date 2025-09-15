// DONE

import 'package:flutter/material.dart';
import 'package:Dividex/config/themes/app_theme.dart';

enum ButtonSize { large, medium, small }

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // null = disabled
  final ButtonSize size;
  final ButtonType type;
  final Color? customColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.type = ButtonType.primary,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    // Config cho từng size
    final sizeConfig = {
      ButtonSize.large: const Size(300, 44),
      ButtonSize.medium: const Size(140, 44),
      ButtonSize.small: const Size(70, 25),
    };

    // Config text style
    final textStyle = switch (size) {
      ButtonSize.large ||
      ButtonSize.medium => Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 24 / Theme.of(context).textTheme.bodyMedium!.fontSize!,
      ),
      ButtonSize.small => Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 24 / Theme.of(context).textTheme.bodySmall!.fontSize!,
      ),
    };

    // Xác định trạng thái
    final bool isDisabled = onPressed == null;

    // Base color (nếu có customColor thì ưu tiên dùng, không thì fallback về primary3)
    final Color baseColor = customColor ?? AppThemes.primary3Color;

    // Primary
    final Color primaryBg = isDisabled ? AppThemes.primary6Color : baseColor;
    const Color primaryText = Colors.white;

    // Secondary
    final Color secondaryBorder = isDisabled ? AppThemes.primary6Color : baseColor;
    final Color secondaryText = isDisabled ? AppThemes.primary6Color : baseColor;
    final Color secondaryBg = Colors.white;

    // Style nút
    final ButtonStyle style = ButtonStyle(
      minimumSize: WidgetStateProperty.all(sizeConfig[size]),
      maximumSize: WidgetStateProperty.all(sizeConfig[size]),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: type == ButtonType.secondary
              ? BorderSide(color: secondaryBorder, width: 1.5)
              : BorderSide.none,
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return type == ButtonType.primary
              ? AppThemes.primary1Color
              : secondaryBg;
        }
        return type == ButtonType.primary ? primaryBg : secondaryBg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.white;
        }
        return type == ButtonType.primary ? primaryText : secondaryText;
      }),
      elevation: WidgetStateProperty.all(0),
    );

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle?.copyWith(
          color: type == ButtonType.primary ? primaryText : secondaryText,
        ),
      ),
    );
  }
}
