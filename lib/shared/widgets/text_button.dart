import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// Nút dạng TextButton có thể kèm mô tả bên cạnh.
class CustomTextButton extends StatelessWidget {
  final String? label; // nội dung nút
  final String description; // mô tả đi kèm (nếu có)
  final VoidCallback? onPressed; // callback khi bấm
  final Color? textColor; // màu chữ của nút
  final bool isLeftAligned; // canh trái hay phải
  final bool isRequired;

  const CustomTextButton({
    super.key,
    this.label,
    this.description = '',
    this.onPressed,
    this.textColor,
    this.isLeftAligned = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 340,
      child: Row(
        mainAxisAlignment: isLeftAligned
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (description.isNotEmpty) ...[
            RichText(
              text: TextSpan(
                text: description,
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
            ),
            const SizedBox(width: 8),
          ],
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onPressed,
            child: Text(
              label ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor ?? AppThemes.primary3Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
