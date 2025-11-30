import 'package:flutter/material.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';

class SimpleLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBack;


  const SimpleLayout({
    super.key,
    required this.title,
    required this.child,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Title + back button ở y = 50
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          /// Wave cố định dưới cùng
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: WavePainter(),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: child,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
