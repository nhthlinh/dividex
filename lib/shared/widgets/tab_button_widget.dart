import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    this.icon,
    required this.text,
    this.isSpecial = false,
    required this.ontap,
    this.isRed = false,
    this.color,
  });

  final bool isSpecial;
  final IconData? icon;
  final String text;
  final VoidCallback ontap;
  final bool isRed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Define colors
    final Color specialColor = Theme.of(context).primaryColor;

    final Color contentColor = isSpecial
        ? Colors.white
        : (isDark ? Colors.white : Colors.black);

    final Color borderColor = (isSpecial ? specialColor : contentColor);

    final Color backgroundColor = isSpecial ? specialColor : Colors.transparent;

    return GestureDetector(
      onTap: ontap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isRed ? Colors.red : color ?? backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isRed ? Colors.red : borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(color: contentColor),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: contentColor, size: 18),
          ],
        ),
      ),
    );
  }
}
