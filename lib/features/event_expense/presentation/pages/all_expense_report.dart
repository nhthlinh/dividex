import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/bar_chart.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AllExpenseReportPage extends StatefulWidget {
  const AllExpenseReportPage({super.key});

  @override
  State<AllExpenseReportPage> createState() => _AllExpenseReportPageState();
}

class _AllExpenseReportPageState extends State<AllExpenseReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseDataBloc>().add(
      InitialEvent(id: '', type: LoadExpenseType.all),
    );
    context.read<ExpenseBloc>().add(GetBarChartData(year: DateTime.now().year));
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        title: intl.transactionReport,
        child: Column(
          children: [
            BlocBuilder<ExpenseBloc, ExpenseState>(
              buildWhen: (p, c) => c is ExpenseBarChartData && p != c,
              builder: (context, state) {
                if (state is ExpenseBarChartData) {
                  return MonthlyBarChart(
                    data: state.data,
                    year: DateTime.now().year,
                  );
                }
                return const SizedBox.shrink();
              },
            ),

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
                  state.page
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
    int page
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

        if (hasMore) ... [
          BlocProvider<ExpenseDataBloc>(
            create: (context) => context.read<ExpenseDataBloc>(),
            child: CustomButton(
              text: intl.more,
              onPressed: () {
                context.read<ExpenseDataBloc>().add(
                  LoadMoreExpenses(id: '', type: LoadExpenseType.all, page: page + 1),
                );
              },
              size: ButtonSize.small,
            ),
          ),
        ]
      ],
    );
  }
}

List<Widget> buildGroupedExpenseList(
  BuildContext context,
  Map<String, List<ExpenseModel>> groupedExpenses,
  List<String> sortedKeys,
  AppLocalizations intl,
) {
  List<Widget> widgets = [];

  for (var date in sortedKeys) {
    final displayDate = DateFormat('dd MMM yyyy').format(DateTime.parse(date));

    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            displayDate,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12,
              letterSpacing: 0,
              height: 16 / 12,
              color: AppThemes.primary3Color,
            ),
          ),
        ),
      ),
    );

    for (var expense in groupedExpenses[date]!) {
      widgets.add(
        InfoCard(
          title: (expense.name ?? '').length > 10
              ? '${(expense.name ?? '').substring(0, 10)}...'
              : (expense.name ?? ''),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              getCategoryByKey(expense.category ?? '')?.getImage() ??
                'lib/assets/icons/money-transfer.png',
            ),
          ),
          subtitle: expense.event,
          trailing: Column(
            children: [
              Text(
                (expense.totalAmount != null)
                    ? (expense.totalAmount! >= 0
                          ? '+ ${formatNumber(expense.totalAmount!)} ${expense.currency?.code}'
                          : '- ${formatNumber(expense.totalAmount!.abs())} ${expense.currency?.code}')
                    : '',
                style: TextStyle(
                  color:
                      (expense.totalAmount != null && expense.totalAmount! >= 0)
                      ? AppThemes.successColor
                      : AppThemes.minusMoney,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                (expense.totalAmount != null && expense.category != 'Transfer')
                    ? (expense.totalAmount! >= 0
                          ? intl.youLent
                          : intl.youBorrowed)
                    : intl.transfer,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
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
        ),
      );
    }
  }

  return widgets;
}
