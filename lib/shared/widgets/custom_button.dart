import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isBig;
  final Color? color;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isBig = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive width
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 300;
    final double width = isSmallScreen
        ? MediaQuery.of(context).size.width -
              20 // ✅
        : (isBig ? 330 : 140);

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppThemes.primary5Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
