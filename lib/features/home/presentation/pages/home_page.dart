import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/features/home/presentation/widgets/button_grid.dart';
import 'package:Dividex/features/home/presentation/widgets/fancy_card.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        isHomePage: true,
        action: notiButton(),
        canBeBack: false,
        title: intl.welcomeUser(fullName),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FancyCard(title: fullName, subtitle: ''),
            ),
            const SizedBox(height: 24),
            buttonGrid(intl, context),
          ],
        ),
      ),
    );
  }

  SquareButtonsWrap buttonGrid(AppLocalizations intl, BuildContext context) {
    return SquareButtonsWrap(
      items: [
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/account.png',
            width: 28,
            height: 28,
          ),
          label: intl.account,
          onTap: () {},
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/transfer.png',
            width: 28,
            height: 28,
          ),
          label: intl.transfer,
          onTap: () {},
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/withdraw.png',
            width: 28,
            height: 28,
          ),
          label: intl.withdraw,
          onTap: () {},
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/friend.png',
            width: 28,
            height: 28,
          ),
          label: intl.friend,
          onTap: () {
            context.pushNamed(AppRouteNames.friend);
          },
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/group_icon.png',
            width: 28,
            height: 28,
          ),
          label: intl.group,
          onTap: () {},
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/transaction-report.png',
            width: 28,
            height: 28,
          ),
          label: intl.transactionReport,
          onTap: () {},
        ),
      ],
    );
  }

  BlocBuilder<NotificationBloc, NotificationState> notiButton() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoaded) {
          return Stack(
            children: [
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // context.pushNamed(AppRouteNames.notification);
                },
              ),
              if (state.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      state.unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          );
        }
        return IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // context.pushNamed(AppRouteNames.notification);
          },
        );
      },
    );
  }
}
