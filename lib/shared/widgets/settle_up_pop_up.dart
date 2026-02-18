import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showSettleUpDialog({
  required BuildContext context,
  required UserModel receiver,
  required double amount,
  required CurrencyEnum currency,
  required String groupId,
}) async {
  final formattedAmount =
      '${amount.toStringAsFixed(0)} ${currency.code.toUpperCase()}';
  final intl = AppLocalizations.of(context)!;

  return showCustomDialog(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text.rich(
          TextSpan(
            text: intl.pay,
            style: Theme.of(context).textTheme.titleSmall,
            children: [
              TextSpan(
                text: receiver.fullName != null ? ' ${receiver.fullName}' : '',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppThemes.primary3Color,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: intl.pay, style: const TextStyle(fontSize: 15)),
              TextSpan(
                text: formattedAmount,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: intl.toSettleUpDebtInGroup),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Buttons
        Row(
          children: [
            CustomButton(
              text: intl.outSideTransfer,
              size: ButtonSize.medium,
              type: ButtonType.secondary,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            CustomButton(
              text: intl.transfer,
              size: ButtonSize.medium,
              onPressed: () {
                context.pushNamed(
                  AppRouteNames.transfer,
                  extra: {
                    'toUser': receiver,
                    'amount': amount,
                    'currency': currency,
                    'groupId': groupId,
                  },
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}
