import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/home/presentation/pages/app_shell.dart';
import 'package:Dividex/features/home/presentation/widgets/button_grid.dart';
import 'package:Dividex/features/home/presentation/widgets/general_widget.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String fullName = HiveService.getUser().fullName ?? "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return AppShell(
      currentIndex: 0,
      child: Layout(
        canBeBack: false,
        title: intl.welcomeUser(fullName),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: FancyCard(title: fullName, subtitle: '')),
            const SizedBox(height: 24),
            SquareButtonsWrap(
              items: [
                ButtonItem(
                  icon: Image.asset('lib/assets/icons/account.png', width: 28, height: 28),
                  label: intl.account,
                  onTap: () {},
                ),
                ButtonItem(
                  icon: Image.asset('lib/assets/icons/transfer.png', width: 28, height: 28),
                  label: intl.transfer,
                  onTap: () {},
                ),
                ButtonItem(
                  icon: Image.asset('lib/assets/icons/withdraw.png', width: 28, height: 28),
                  label: intl.withdraw,
                  onTap: () {},
                ),
                ButtonItem(
                  icon: Image.asset('lib/assets/icons/friend.png', width: 28, height: 28),
                  label: intl.friend,
                  onTap: () {},
                ),
                ButtonItem(
                  icon: Image.asset('lib/assets/icons/group_icon.png', width: 28, height: 28),
                  label: intl.group,
                  onTap: () {}
                ),
                ButtonItem(
                  icon: Image.asset('lib/assets/icons/transaction-report.png', width: 28, height: 28),
                  label: intl.transactionReport,
                  onTap: () {},
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}
