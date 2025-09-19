import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AddButtonPopup extends StatelessWidget {
  const AddButtonPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    // List item động
    final items = [
      _PopupItem(
        iconPath: 'lib/assets/icons/group.png',
        label: intl.addGroup,
        onTap: () {
          
        },
      ),
      _PopupItem(
        iconPath: 'lib/assets/icons/event.png',
        label: intl.addEvent,
        onTap: () {
          
        },
      ),
      _PopupItem(
        iconPath: 'lib/assets/icons/money-transfer.png',
        label: intl.addExpense,
        onTap: () {
          
        },
      ),
      // 👉 bạn có thể thêm bao nhiêu item tuỳ ý ở đây
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) {
            return _buildPopupItem(context, item.iconPath, item.label, item.onTap);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopupItem(
    BuildContext context,
    String iconImagePath,
    String label,
    Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 100, // giữ ô cân đối
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconImagePath, width: 40, height: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopupItem {
  final String iconPath;
  final String label;
  final Function()? onTap;

  _PopupItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });
}
