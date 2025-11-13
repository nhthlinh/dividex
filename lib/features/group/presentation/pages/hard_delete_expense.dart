import 'dart:io';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/group/presentation/pages/group_detail.dart';
import 'package:Dividex/features/home/presentation/pages/setting_page.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HardDeleteExpensePage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupAvatarUrl;

  const HardDeleteExpensePage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupAvatarUrl,
  });

  @override
  State<HardDeleteExpensePage> createState() => _HardDeleteExpensePageState();
}

class _HardDeleteExpensePageState extends State<HardDeleteExpensePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseDataBloc>().add(
      InitialEvent(id: widget.groupId, type: LoadExpenseType.hasBeenDeleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        title: widget.groupName,
        child: Column(
          children: [
            BlocBuilder<ExpenseDataBloc, ExpenseDataState>(
              buildWhen: (p, c) =>
                  p.expenses != c.expenses || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (state.expenses.isEmpty) {
                  return noExpenseWidget(intl, theme);
                }

                final hasMore = state.page < state.totalPage;

                return listExpenseResults(
                  intl,
                  hasMore,
                  state.totalItems,
                  state.expenses,
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  LayoutBuilder noExpenseWidget(AppLocalizations intl, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: intl.expense,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                    height: 16 / 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Icon(
                    Icons.currency_exchange_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(intl.noSearchResults, style: theme.textTheme.titleSmall),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Column listExpenseResults(
    AppLocalizations intl,
    bool hasMore,
    int totalExpenses,
    List<ExpenseModel> expenses,
  ) {
    final groupedExpenses = <String, List<ExpenseModel>>{};
    for (var e in expenses) {
      final key = e.expenseDate?.toString().substring(0, 10) ?? 'Unknown';
      groupedExpenses.putIfAbsent(key, () => []).add(e);
    }

    final sortedKeys = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: intl.expense,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: totalExpenses > 0
                  ? [
                      TextSpan(
                        text: totalExpenses > 99 ? ' 99+' : ' $totalExpenses',
                        style: TextStyle(color: AppThemes.primary3Color),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(height: 8),

        ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: buildGroupedExpenseList(
            context,
            groupedExpenses,
            sortedKeys,
            intl,
          ),
        ),
      ],
    );
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.expense, required this.widget});

  final ExpenseModel expense;
  final HardDeleteExpensePage widget;

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return InfoCard(
      title: expense.name ?? '',
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage:
            (widget.groupAvatarUrl != '' && widget.groupAvatarUrl.isNotEmpty)
            ? NetworkImage(widget.groupAvatarUrl)
            : NetworkImage(
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.groupName)}&background=random&color=fff&size=128',
              ),
      ),
      subtitle: expense.updatedAt != null
          ? '${intl.deleteDate}: ${expense.updatedAt!.toLocal().toString().split(' ')[0]}'
          : null,
      trailing: Column(
        children: [
          Text(
            (expense.totalAmount != null)
                ? (expense.totalAmount! >= 0
                      ? '+ ${expense.totalAmount} ${expense.currency?.code}'
                      : '- ${expense.totalAmount!.abs()} ${expense.currency?.code}')
                : '',
            style: TextStyle(
              color: (expense.totalAmount != null && expense.totalAmount! >= 0)
                  ? AppThemes.successColor
                  : AppThemes.minusMoney,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: () {
        showCustomDialog(
          context: context,
          content: Column(
            children: [
              SettingOption(
                label: intl.hardDelete,
                context: context,
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  context.read<ExpenseBloc>().add(
                    HardDeleteExpenseEvent(expenseId: expense.id!),
                  );
                },
              ),
              SettingOption(
                label: intl.restore,
                context: context,
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  context.read<ExpenseBloc>().add(
                    RestoreExpenseEvent(expenseId: expense.id!),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
