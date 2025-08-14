import 'package:flutter/material.dart';

class TestButtonWithDes extends StatelessWidget {
  final String description;
  final String? label;
  final VoidCallback? onPressed; // <-- Cho phép null

  const TestButtonWithDes({
    super.key,
    this.label,
    required this.onPressed,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(label!),
        ),
      ],
    );
  }
}


// Helper widget for custom TextButton (defined at the bottom of this file)
class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? textColor;

  const CustomTextButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: textColor ?? Theme.of(context).primaryColor, // Mặc định là màu chính của theme
        )
      ),
    );
  }
}
