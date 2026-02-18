import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final currentUser = HiveService.getUser();

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () {
          context.read<AccountBloc>().add(GetAccountsEvent());
          return Future.value();
        },
        title: intl.account,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage:
                  (currentUser.avatarUrl != null &&
                      currentUser.avatarUrl!.publicUrl.isNotEmpty)
                  ? NetworkImage(currentUser.avatarUrl!.publicUrl)
                  : NetworkImage(
                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(currentUser.fullName ?? 'User')}&background=random&color=fff&size=128',
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              currentUser.fullName ?? '',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppThemes.primary3Color),
            ),
            const SizedBox(height: 16),
            Text(
              intl.addAccountGuide,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BlocBuilder<AccountBloc, AccountState>(
              buildWhen: (p, c) => p.accounts != c.accounts,
              builder: (context, state) {
                if (state.accounts.isEmpty) {
                  return SizedBox.shrink();
                } else {
                  final accounts = state.accounts;

                  if (accounts.isEmpty) {
                    return SizedBox.shrink();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return ContentCard(
                        onTap: () {
                          context.pushNamed(
                            AppRouteNames.accountDetail,
                            pathParameters: {'id': account.id ?? ''},
                            extra: account,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  intl.accountNumber,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppThemes.primary3Color,
                                      ),
                                ),
                                Text(
                                  account.accountNumber,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppThemes.primary3Color,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  intl.branch,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  account.bankName,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),

            const SizedBox(height: 16),
            CustomButton(
              text: intl.addNewAccount,
              onPressed: () {
                context.pushNamed(AppRouteNames.addAccount);
              },
            ),
          ],
        ),
      ),
    );
  }
}
