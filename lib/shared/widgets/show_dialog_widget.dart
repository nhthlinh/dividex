import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  String? title,
  required Widget child,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final backgroundColor = isDark ? Colors.black : Colors.white;

  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color.fromARGB(25, 0, 0, 0), // Làm mờ nền
    builder: (context) => Center( // Center giúp dialog không bị full chiều cao
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
        backgroundColor: backgroundColor,
        insetPadding: const EdgeInsets.all(24), // tránh sát viền
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 600,
          ),
          child: SingleChildScrollView( // ngăn nội dung quá dài gây vỡ layout
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(title, style: theme.textTheme.titleSmall),
                    ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
