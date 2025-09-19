import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ContentCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 240, 240, 240),
              blurRadius: 12, // độ mờ
              spreadRadius: 0, // lan rộng
              offset: const Offset(0, 4), // dịch xuống dưới
            ),
          ]
        ),
        child: child,
      ),
    );
  }
}
