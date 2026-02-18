import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class TwoOptionSelector extends StatelessWidget {
  final String label;
  final String leftLabel;
  final String leftIcon;
  final String rightLabel;
  final String rightIcon;
  final ValueChanged<int> onSelectionChanged;
  final int
  selectedIndex; // 0 là không chọn gì hết, 1 là chọn trái, 2 là chọn phải

  const TwoOptionSelector({
    super.key,
    required this.label,
    required this.leftLabel,
    required this.leftIcon,
    required this.rightLabel,
    required this.rightIcon,
    required this.onSelectionChanged,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppThemes.primary3Color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(
                context: context,
                label: leftLabel,
                icon: leftIcon,
                selected: selectedIndex == 1,
                onTap: () => onSelectionChanged(1),
              ),
              _buildOption(
                context: context,
                label: rightLabel,
                icon: rightIcon,
                selected: selectedIndex == 2,
                onTap: () => onSelectionChanged(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String label,
    required String icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = selected ? AppThemes.primary3Color : Colors.grey;
    final background = selected ? AppThemes.primary6Color : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppThemes.primary3Color : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 20, height: 20),
            const SizedBox(width: 6),
            if (selected) ...[
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
