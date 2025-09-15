import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  required String label, // luôn có label
  required Widget content, // nội dung chính
  List<Widget>? actions, // tuỳ chọn thêm nút (OK, Cancel, ...)
}) {
  final theme = Theme.of(context);

  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Label (luôn có)
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              /// Nội dung chính
              Flexible(
                child: SingleChildScrollView(
                  child: content,
                ),
              ),

              /// Các nút hành động (nếu có)
              if (actions != null && actions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
