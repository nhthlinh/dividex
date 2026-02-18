import 'package:flutter/material.dart';

/// Mô tả 1 nút: icon (Widget) + label + callback
class ButtonItem {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  ButtonItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

/// 1 nút vuông 100x100, icon size 40x40, label dưới icon
class SquareIconButton extends StatelessWidget {
  final ButtonItem item;
  final double size; // total square size
  final double iconSize;

  const SquareIconButton({
    super.key,
    required this.item,
    this.size = 100,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(255, 240, 240, 240),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon area (fixed size)
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Center(child: item.icon),
                ),
                const SizedBox(height: 8),
                // Label (allow multi-line, centered)
                Flexible(
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrap of square buttons (flows on small screens)
class SquareButtonsWrap extends StatelessWidget {
  final List<ButtonItem> items;
  final double spacing;
  final double itemSize;

  const SquareButtonsWrap({
    super.key,
    required this.items,
    this.spacing = 12,
    this.itemSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: items
          .map((i) => SquareIconButton(item: i, size: itemSize))
          .toList(),
    );
  }
}
