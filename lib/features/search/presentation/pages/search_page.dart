import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return AppShell(
      currentIndex: 1,
      child: SimpleLayout(
        title: intl.search, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InfoCard(
              title: intl.transaction,
              subtitle: intl.searchTransactionSubtitle,
              trailing: Image.asset('lib/assets/images/transaction_search_image.png', width: 105, height: 80),
              onTap: () {
                // Navigate to search transaction page
              },
            ),
            const SizedBox(height: 16),
            InfoCard(
              title: intl.user,
              subtitle: intl.searchUserSubtitle,
              trailing: Image.asset('lib/assets/images/user_search_image.png', width: 105, height: 80),
              onTap: () {
                context.pushNamed(AppRouteNames.searchUser);
              },
            ),
          ],
        ),
      ),
    );
  }
}