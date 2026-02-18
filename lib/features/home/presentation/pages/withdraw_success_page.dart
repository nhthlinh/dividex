import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WithdrawSuccessPage extends StatefulWidget {
  final BankAccount toAccount;
  final double amount;
  const WithdrawSuccessPage({
    super.key,
    required this.toAccount,
    required this.amount,
  });

  @override
  State<WithdrawSuccessPage> createState() => _WithdrawSuccessPageState();
}

class _WithdrawSuccessPageState extends State<WithdrawSuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () {
          // No specific refresh logic needed for this page, but you can add any necessary actions here if required.
          return Future.value();
        },
        title: intl.success,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Image(
                image: AssetImage("lib/assets/images/withdraw_successful.png"),
                width: 300,
                height: 300,
              ),
              SizedBox(height: 24),
              Text(
                intl.withdrawSuccessful,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppThemes.primary3Color,
                ),
              ),
              SizedBox(height: 8),
              Text(
                intl.youHaveSuccessfullyWithdraw,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${formatNumber(widget.amount)} VND ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.infoColor,
                    ),
                  ),
                  Text(
                    '${intl.to} ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${widget.toAccount.accountNumber} - ${widget.toAccount.bankName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.primary3Color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: intl.confirm,
                onPressed: () {
                  context.goNamed(AppRouteNames.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
