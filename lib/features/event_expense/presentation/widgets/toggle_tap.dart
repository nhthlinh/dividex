import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class ToggleTab extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const ToggleTab({
    super.key,
    this.initialValue = true,
    required this.onChanged,
  });

  @override
  State<ToggleTab> createState() => _ToggleTabState();
}

class _ToggleTabState extends State<ToggleTab> with SingleTickerProviderStateMixin {
  late bool isCustomByAmount;

  @override
  void initState() {
    super.initState();
    isCustomByAmount = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      isCustomByAmount = !isCustomByAmount;
      widget.onChanged(isCustomByAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: 250,
        height: 50,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            // Animated toggle indicator
            AnimatedAlign(
              alignment: isCustomByAmount ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: 120,
                height: 42,
                decoration: BoxDecoration(
                  color: AppThemes.primary3Color,
                  borderRadius: BorderRadius.circular(21),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
            // Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel(intl.byAmount, isSelected: isCustomByAmount),
                _buildLabel(intl.byItem, isSelected: !isCustomByAmount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {required bool isSelected}) {
    return Container(
      width: 120,
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          letterSpacing: 0,
          height: 16 / 12,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}