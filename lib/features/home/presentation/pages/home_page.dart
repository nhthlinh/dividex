import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart' as expense_data_event;
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/features/home/presentation/widgets/button_grid.dart';
import 'package:Dividex/features/home/presentation/widgets/fancy_card.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    context.read<RechargeBloc>().add(GetWalletInfoEvent());
    context.read<UserBloc>().add(GetMeEvent());
    context.read<ExpenseDataBloc>().add(
      expense_data_event.InitialEvent(id: '', pageSize: 4, type: expense_data_event.LoadExpenseType.all),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowRatingDialog();
    });
  }

  void _checkAndShowRatingDialog() {
    final loginCount = HiveService.getUser().countUserLogin ?? 0;

    if (loginCount > 0 && loginCount % 5 == 0) {
      _showRatingDialog(loginCount);
    }
  }

  void _showRatingDialog(int loginCount) {
    final intl = AppLocalizations.of(context)!;
    int selectedRating = 5;

    showCustomDialog(
      context: context,
      content: Column(
        children: [
          Text(
            intl.rateUsTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < selectedRating
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                  );
                }),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                text: intl.cancel,
                onPressed: () {
                  Navigator.pop(context);
                },
                size: ButtonSize.medium,
                type: ButtonType.secondary,
                customColor: AppThemes.errorColor,
              ),
              CustomButton(
                text: intl.accept,
                onPressed: () {
                  _submitRating(selectedRating, loginCount);
                  Navigator.pop(context);
                },
                size: ButtonSize.medium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitRating(int rating, int loginCount) async {
    try {
      context.read<UserBloc>().add(ReviewEvent(stars: rating));
      HiveService.saveUser(
        HiveService.getUser().copyWith(countUserLogin: loginCount + 1),
      );
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return AppShell(
      currentIndex: 0,
      child: Layout(
        onRefresh: () {
          context.read<RechargeBloc>().add(GetWalletInfoEvent());
          context.read<UserBloc>().add(GetMeEvent());
          context.read<ExpenseDataBloc>().add(
            expense_data_event.InitialEvent(id: '', pageSize: 4, type: expense_data_event.LoadExpenseType.all),
          );
          return Future.value();
        },
        isHomePage: true,
        action: notiButton(),
        canBeBack: false,
        title: intl.welcomeUser(fullName.split(' ').last),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: FancyCard(title: fullName, subtitle: ''),
              ),
              const SizedBox(height: 20),
              buttonGrid(intl, context),
              const SizedBox(height: 24),
              BlocBuilder<ExpenseDataBloc, ExpenseDataState>(
                buildWhen: (p, c) =>
                    p.expenses != c.expenses || p.isLoading != c.isLoading,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: SpinKitFadingCircle(
                            color: AppThemes.primary3Color,
                          ),
                        ),
                      ),
                    );
                  } else if (state.expenses.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return _buildRecentExpensesSection(
                    intl,
                    state.expenses,
                  );
                },
              ),

            ],
          ),
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
          onTap: () {
            context.pushNamed(AppRouteNames.account);
          },
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/transfer.png',
            width: 28,
            height: 28,
          ),
          label: intl.transfer,
          onTap: () {
            context.pushNamed(AppRouteNames.transfer);
          },
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/withdraw.png',
            width: 28,
            height: 28,
          ),
          label: intl.withdraw,
          onTap: () {
            context.pushNamed(AppRouteNames.withdraw);
          },
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
          onTap: () {
            context.pushNamed(AppRouteNames.group);
          },
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/transaction-report.png',
            width: 28,
            height: 28,
          ),
          label: intl.transactionReport,
          onTap: () {
            context.pushNamed(AppRouteNames.transactionReport);
          },
        ),
        ButtonItem(
          icon: Image.asset(
            'lib/assets/icons/wallet_report.png',
            width: 28,
            height: 28,
          ),
          label: intl.walletReport,
          onTap: () {
            context.pushNamed(AppRouteNames.walletReport);
          },
        ),
      ],
    );
  }

  Widget _buildRecentExpensesSection(
    AppLocalizations intl,
    List<ExpenseModel> allExpenses,
  ) {
    // Lấy 4 chi tiêu gần đây nhất
    final recentExpenses =
        allExpenses.length > 4 ? allExpenses.sublist(0, 4) : allExpenses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                intl.recentExpenses,
                style: Theme.of(context).textTheme.titleSmall
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRouteNames.transactionReport);
                },
                child: Text(
                  intl.viewAll,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppThemes.primary3Color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentExpenses.length,
            itemBuilder: (context, index) {
              final expense = recentExpenses[index];
              return InfoCard(
                key: Key('recent_expense_${expense.id}'),
                title: (expense.name ?? '').length > 16
                    ? '${(expense.name ?? '').substring(0, 16)}...'
                    : (expense.name ?? ''),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage(
                    getCategoryByKey(expense.category ?? '')?. getImage() ??
                        'lib/assets/icons/money-transfer.png',
                  ),
                ),
                subtitle: expense.event,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (expense.totalAmount != null)
                          ? (expense.totalAmount! >= 0
                              ? '+ ${formatNumber(expense.totalAmount!)} ${expense.currency?.code}'
                              : '- ${formatNumber(expense.totalAmount!.abs())} ${expense.currency?.code}')
                          : '',
                      style: TextStyle(
                        color: (expense.totalAmount != null &&
                                expense.totalAmount! >= 0)
                            ? AppThemes.successColor
                            : AppThemes.minusMoney,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (expense.category == 'Transfer') return;
                  context.pushNamed(
                    AppRouteNames.expenseDetail,
                    pathParameters: {"id": expense.id ?? ''},
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  BlocBuilder<LoadedNotiBloc, LoadedNotiState> notiButton() {
    return BlocBuilder<LoadedNotiBloc, LoadedNotiState>(
      builder: (context, state) {
        if (state is NotificationLoaded) {
          return Stack(
            children: [
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  context.pushNamed(AppRouteNames.notification);
                },
              ),

              if (state.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      state.totalItems.toString(),
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
            context.pushNamed(AppRouteNames.notification);
          },
        );
      },
    );
  }
}