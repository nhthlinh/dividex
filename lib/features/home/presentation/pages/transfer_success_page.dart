import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransferSuccessPage extends StatefulWidget {
  final UserModel toUser;
  final double amount;
  const TransferSuccessPage({super.key, required this.toUser, required this.amount});

  @override
  State<TransferSuccessPage> createState() => _TransferSuccessPageState();
}

class _TransferSuccessPageState extends State<TransferSuccessPage> {
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
        title: intl.success,
        child: Column(children: [
          Image(
            image: AssetImage("lib/assets/images/transfer_successful.png"),
            width: 150,
            height: 150,
          ),
          SizedBox(height: 24),
          Text(
            intl.transferSuccessful,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppThemes.primary3Color),
          ),
          SizedBox(height: 8),
          Text(
            intl.youHaveSuccessfullyTransferred,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.amount} VND ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppThemes.infoColor),
              ),
              Text(
                '${intl.to} ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${widget.toUser.fullName}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppThemes.primary3Color),
              ),
            ],
          ),
          CustomButton(text: intl.confirm, onPressed: () {
            context.goNamed(AppRouteNames.home);
          })
        ],)
      ),
    );
  }
}
