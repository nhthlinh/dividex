import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
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
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/change_string.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/bar_chart.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
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
  const EventReportPage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.groupId,
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
      event_event.GetEventEvent(eventId: widget.eventId),
    );
    context.read<EventBalanceBloc>().add(
      event_event.EventBalanceSuccessEvent(eventId: widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      // onRefresh: () async {
      //   context.read<ExpenseDataBloc>().add(
      //     expense_event.InitialEvent(
      //       id: widget.eventId,
      //       type: LoadExpenseType.event,
      //     ),
      //   );
      //   context.read<EventBloc>().add(
      //     event_event.GetChartDataEvent(
      //       eventId: widget.eventId,
      //       year: DateTime.now().year,
      //     ),
      //   );
      // },
      currentIndex: 0,
      child: Layout(
        onRefresh: () {
          context.read<ExpenseDataBloc>().add(
            expense_event.InitialEvent(
              id: widget.eventId,
              type: LoadExpenseType.event,
            ),
          );
          context.read<EventBloc>().add(
            event_event.GetEventEvent(eventId: widget.eventId),
          );
          return Future.value();
        },
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
                if (state is! EventLoadedState) {
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// STATUS CARD
                        StatusCard(event: state.event),

                        const SizedBox(height: 8),

                        /// OVERVIEW CARD
                        ContentCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: _overviewItem(
                                  icon: Icons.account_balance_wallet,
                                  value: formatNumber(state.event.total),
                                  label: intl.totalAmount,
                                  color: Colors.redAccent,
                                ),
                              ),

                              Container(
                                width: 1.5,
                                height: 120,
                                color: Colors.grey.shade300,
                              ),

                              Expanded(
                                child: _overviewItem(
                                  icon: Icons.groups_rounded,
                                  value: "${state.event.totalMembers}",
                                  label: intl.members,
                                  color: Colors.blue,
                                ),
                              ),

                              Container(
                                width: 1.5,
                                height: 120,
                                color: Colors.grey.shade300,
                              ),

                              Expanded(
                                child: _overviewItem(
                                  icon: Icons.receipt_long_outlined,
                                  value: "${state.event.totalExpenses}",
                                  label: intl.expense,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     intl.contributon,
                    //     style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    //       fontSize: 12,
                    //       letterSpacing: 0,
                    //       height: 16 / 12,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    // ContributionPieChart(chartData: state.chartData),

                    // const SizedBox(height: 5),
                    // MonthlyBarChart(
                    //   data: state.barChartData,
                    //   year: DateTime.now().year,
                    // ),
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            BlocBuilder<EventBalanceBloc, EventState>(
              builder: (context, state) {
                if (state is! EventBalanceState) {
                  return const Center(
                    child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                  );
                }

                final myId = HiveService.getUser().id;
                final balances = state.balances;

                final myDebts = balances
                    .where((e) => e.debtor?.id == myId)
                    .toList();

                final othersOweMe = balances
                    .where((e) => e.creditor?.id == myId)
                    .toList();

                final totalDebt = myDebts.fold<double>(
                  0,
                  (sum, e) => sum + (e.value ?? 0),
                );

                final totalReceive = othersOweMe.fold<double>(
                  0,
                  (sum, e) => sum + (e.value ?? 0),
                );

                return ContentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// header
                      Row(
                        children: [
                          Text(
                            intl.netBalance,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),

                          ),

                          Spacer(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (totalDebt == 0 && totalReceive == 0)
                                Text(
                                  intl.settleUp,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppThemes.successColor,
                                  ),
                                ),

                              if (totalDebt != 0)
                              Text(
                                "${intl.youOwe}: "
                                "${formatNumber(totalDebt)} đ",

                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppThemes.errorColor,
                                ),
                              ),

                              if (totalReceive != 0)

                              Text(
                                "${intl.oweYou}: "
                                "${formatNumber(totalReceive)} đ",

                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppThemes.successColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      if (myDebts.isNotEmpty) ...[
                        Text(
                          intl.youNeedToPay,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        SizedBox(height: 8),

                        ...myDebts.map(
                          (e) => _debtRow(
                            debtorName: intl.you,
                            debtorAvatar:
                                HiveService.getUser().avatarUrl?.publicUrl,
                            creditorName: e.creditor?.fullName ?? "",
                            creditorAvatar: e.creditor?.avatar?.publicUrl,
                            amount: e.value ?? 0,
                          ),
                        ),
                      ],

                      if (othersOweMe.isNotEmpty) ...[
                        SizedBox(height: 20),

                        Text(
                          intl.peopleNeedToPayYou,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        SizedBox(height: 8),

                        ...othersOweMe.map(
                          (e) => _debtRow(
                            debtorName: e.debtor?.fullName ?? "",
                            debtorAvatar: e.debtor?.avatar?.publicUrl,
                            creditorName: intl.you,
                            creditorAvatar:
                                HiveService.getUser().avatarUrl?.publicUrl,
                            amount: e.value ?? 0,
                          ),
                        ),
                      ],
                    ],
                  ),
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
                  state.page,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _debtRow({
    required String debtorName,
    required String creditorName,
    String? debtorAvatar,
    String? creditorAvatar,
    required double amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    debtorAvatar ??
                                                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(debtorName)}&background=random&color=fff&size=128',
                  ),
                ),

                SizedBox(height: 8),

                Text(getLastTwoWords(debtorName), textAlign: TextAlign.center),
              ],
            ),
          ),

          Column(
            children: [
              Image.asset(
                'lib/assets/images/arrow_image.png',
                width: 16,
                height: 16,
              ),

              Text(
                formatNumber(amount),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppThemes.successColor,
                ),
              ),
            ],
          ),

          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    creditorAvatar ??
                        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(creditorName)}&background=random&color=fff&size=128',
                  ),
                ),

                SizedBox(height: 8),

                Text(getLastTwoWords(creditorName), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(.12),
          child: Icon(icon, color: color),
        ),

        const SizedBox(height: 12),

        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
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
    int page,
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

        if (hasMore) ...[
          BlocProvider<ExpenseDataBloc>(
            create: (context) => context.read<ExpenseDataBloc>(),
            child: CustomButton(
              text: intl.more,
              onPressed: () {
                context.read<ExpenseDataBloc>().add(
                  LoadMoreExpenses(
                    id: '',
                    type: LoadExpenseType.all,
                    page: page + 1,
                  ),
                );
              },
              size: ButtonSize.small,
            ),
          ),
        ],
      ],
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final now = DateTime.now();

    final eventStart = event.eventStart!;
    final eventEnd = event.eventEnd!;

    late String title;
    late String description;
    late Color color;
    late IconData icon;

    if (now.isBefore(eventStart)) {
      /// UPCOMING
      title = intl.upcoming;
      description = intl.eventUpcomingDescription;
      color = AppThemes.infoColor;

      icon = Icons.schedule_rounded;
    } else if (now.isAfter(eventEnd)) {
      /// ENDED
      title = intl.ended;
      description = intl.eventEndedDescription;
      color = AppThemes.errorColor;

      icon = Icons.flag_circle_rounded;
    } else {
      /// IN PROGRESS
      title = intl.inProgress;
      description = intl.eventActiveFrom;

      color = AppThemes.warningColor;

      icon = Icons.show_chart_rounded;
    }
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),

                    const SizedBox(height: 4),

                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: "$description ",
                            style: const TextStyle(color: Colors.grey),
                          ),

                          TextSpan(
                            text:
                                "${DateFormat('dd/MM').format(eventStart)} - "
                                "${DateFormat('dd/MM/yyyy').format(eventEnd)}",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            intl.eventDescriptionLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            (event.description ?? '') == ''
                ? intl.noDescription
                : event.description ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
        backgroundImage: AssetImage(
          getCategoryByKey(expense.category?.key ?? '')?.getImage() ??
              'lib/assets/icons/money-transfer.png',
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
