import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/group/presentation/widgets/chart_widget.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class GroupReportPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupAvatarUrl;
  const GroupReportPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupAvatarUrl,
  });

  @override
  State<GroupReportPage> createState() => _GroupReportPageState();
}

class _GroupReportPageState extends State<GroupReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseDataBloc>().add(InitialEvent(id: widget.groupId));
    context.read<GroupBloc>().add(
      group_event.GetGroupReportEvent(widget.groupId),
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
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is! GroupReportState) {
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
                            intl.event,
                            state.groupReport?.eventsTotal.toString() ?? '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.totalExpenses,
                            state.groupReport?.sharedExpensesTotal.toString() ??
                                '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.totalSpending,
                            state.groupReport?.totalAmount.toString() ?? '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.leader,
                            state.groupReport?.leader?.fullName.toString() ??
                                '',
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
                    ContributionPieChart(chartData: state.chartData ?? []),
                  ],
                );
              },
            ),

            const SizedBox(height: 8), 
            
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
    List<ExpenseModel>? expenses,
  ) {
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
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expenses?.length != null
              ? (expenses!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == expenses!.length) {
              context.read<ExpenseDataBloc>().add(
                LoadMoreExpenses(id: widget.groupId),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            final expense = expenses[index];

            return InfoCard(
              title: expense.name ?? '',
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage:
                    (widget.groupAvatarUrl != '' &&
                        widget.groupAvatarUrl.isNotEmpty)
                    ? NetworkImage(widget.groupAvatarUrl)
                    : NetworkImage(
                        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.groupName)}&background=random&color=fff&size=128',
                      ),
              ),
              subtitle: expense.event ?? '',
              trailing: Column(
                children: [
                  Text(
                    (expense.totalAmount != null)
                        ? (expense.totalAmount! >= 0
                              ? '+ ${expense.totalAmount} ${expense.currency?.code}'
                              : '- ${expense.totalAmount!.abs()} ${expense.currency?.code}')
                        : '',
                    style: TextStyle(
                      color:
                          (expense.totalAmount != null &&
                              expense.totalAmount! >= 0)
                          ? AppThemes.successColor
                          : AppThemes.minusMoney,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.status == ExpenseStatus.done
                        ? intl.done
                        : intl.notYet,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: expense.status == ExpenseStatus.done
                          ? AppThemes.successColor
                          : AppThemes.minusMoney,
                    ),
                  ),
                ],
              ),
              onTap: () {
                context.pushNamed(AppRouteNames.expenseDetail, pathParameters: {"id": expense.id ?? ''});
              },
            );
          },
        ),
      ],
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
}
