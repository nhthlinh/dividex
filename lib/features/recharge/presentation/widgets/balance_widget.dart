import 'package:flutter/material.dart';

class BalanceRow extends StatefulWidget {
  final String balanceLabel;
  final String balance;

  const BalanceRow({
    super.key,
    required this.balanceLabel,
    required this.balance,
  });

  @override
  State<BalanceRow> createState() => _BalanceRowState();
}

class _BalanceRowState extends State<BalanceRow> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label + nút toggle
        Row(
          children: [
            Text(
              widget.balanceLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ],
        ),

        // Hiển thị số dư hoặc ***
        InkWell(
          onTap: () => setState(() {
            isHidden = !isHidden;
          }),
          child: Row(
            children: [
              isHidden
                  ? Icon(
                      Icons.visibility_off,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Icons.visibility,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              const SizedBox(width: 8),
              Text(
                isHidden ? '••••••' : widget.balance,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
