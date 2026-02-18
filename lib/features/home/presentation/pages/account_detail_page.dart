import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDetailPage extends StatefulWidget {
  final String id;
  final BankAccount? account; // Optional account data
  const AccountDetailPage({super.key, required this.id, this.account});

  @override
  State<AccountDetailPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountDetailPage> {
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
        title: intl.account,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    intl.accountNumber,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    widget.account?.accountNumber ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppThemes.primary3Color,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Divider(color: AppThemes.borderColor),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    intl.expenseCurrencyLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    widget.account?.currency?.code ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppThemes.primary3Color,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Divider(color: AppThemes.borderColor),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    intl.branch,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    widget.account?.bankName ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppThemes.primary3Color,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Divider(color: AppThemes.borderColor),
              const SizedBox(height: 16),

              CustomButton(
                text: intl.delete,
                onPressed: () {
                  context.read<AccountBloc>().add(
                    DeleteAccountEvent(widget.id),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
