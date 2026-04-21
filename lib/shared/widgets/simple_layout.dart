import 'package:flutter/material.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';

class SimpleLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBack;
  final Future<void> Function() onRefresh;

  const SimpleLayout({
    super.key,
    required this.title,
    required this.child,
    this.showBack = true,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 56;
    const double contentTopOffset = 72;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Wave cố định dưới cùng
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: CustomPaint(painter: WavePainter()),
              ),
            ),

            Positioned.fill(
              top: contentTopOffset,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: SizedBox(
                height: headerHeight,
                child: Row(
                  children: [
                    if (showBack)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    else
                      const SizedBox(width: 48),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
