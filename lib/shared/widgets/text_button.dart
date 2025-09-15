import 'package:flutter/material.dart';

/// Nút dạng TextButton có thể kèm mô tả bên cạnh.
class LabeledTextButton extends StatelessWidget {
  final String? label;              // nội dung nút
  final String description;         // mô tả đi kèm (nếu có)
  final VoidCallback? onPressed;    // callback khi bấm
  final Color? textColor;           // màu chữ của nút

  const LabeledTextButton({
    super.key,
    this.label,
    this.description = '',
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (description.isNotEmpty) ...[
          Text(
            description,
            style: theme.textTheme.bodySmall,
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
            style: theme.textTheme.titleSmall?.copyWith(
              color: textColor ?? theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
