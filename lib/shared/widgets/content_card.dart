import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;

  const ContentCard({super.key, required this.child, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 240, 240, 240),
                blurRadius: 12, // độ mờ
                spreadRadius: 0, // lan rộng
                offset: const Offset(0, 4), // dịch xuống dưới
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
