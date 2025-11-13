import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart'
    as event_event;
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart'
    as expense_event;
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/group/presentation/pages/group_detail.dart';
import 'package:Dividex/features/group/presentation/widgets/chart_widget.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/bar_chart.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventReportPage extends StatefulWidget {
  final String eventId;
  final String groupId;
  final String eventName;
  final String groupName;
  final String groupAvatarUrl;
  const EventReportPage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.groupId,
    required this.groupName,
    required this.groupAvatarUrl,
  });

  @override
  State<EventReportPage> createState() => _EventReportPageState();
}

class _EventReportPageState extends State<EventReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseDataBloc>().add(
      expense_event.InitialEvent(
        id: widget.eventId,
        type: LoadExpenseType.event,
      ),
    );
    context.read<EventBloc>().add(
      event_event.GetChartDataEvent(
        eventId: widget.eventId,
        year: DateTime.now().year,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        title: widget.eventName,
        action: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            context.pushNamed(
              AppRouteNames.eventSetting,
              pathParameters: {
                'eventId': widget.eventId,
                'groupId': widget.groupId,
              },
              extra: {'eventName': widget.eventName},
            );
          },
        ),
        child: Column(
          children: [
            BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is! EventChartDataState) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        intl.overview,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          height: 16 / 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ContentCard(
                      child: Column(
                        children: [
                          buildGroupInfoRow(
                            intl.eventNameLabel,
                            state.eventData?.name ?? '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.eventStartDateLabel,
                            DateFormat('dd/MM/yyyy').format(
                              state.eventData?.eventStart ?? DateTime.now(),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.eventEndDateLabel,
                            DateFormat('dd/MM/yyyy').format(
                              state.eventData?.eventEnd ?? DateTime.now(),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  intl.eventDescriptionLabel,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  state.eventData?.description ?? '',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppThemes.primary3Color,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        intl.contributon,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          height: 16 / 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ContributionPieChart(chartData: state.chartData),

                    const SizedBox(height: 5),
                    MonthlyBarChart(
                      data: state.barChartData,
                      year: DateTime.now().year,
                    ),
                  ],
                );
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGroupInfoRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppThemes.primary3Color),
          ),
        ],
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
  final EventReportPage widget;

  @override
  Widget build(BuildContext context) {
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
      subtitle: widget.eventName,
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
        context.pushNamed(
          AppRouteNames.expenseDetail,
          pathParameters: {"id": expense.id ?? ''},
        );
      },
    );
  }
}
