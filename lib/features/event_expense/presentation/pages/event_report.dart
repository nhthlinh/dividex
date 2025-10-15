import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

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
      InitialEvent(id: widget.eventId, type: LoadExpenseType.event),
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
                LoadMoreExpenses(
                  id: widget.eventId,
                  type: LoadExpenseType.event,
                ),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            final expense = expenses[index];

            return ExpenseCard(expense: expense, widget: widget);
          },
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
          const SizedBox(height: 4),
          Text(
            expense.status == ExpenseStatus.done ? intl.done : intl.notYet,
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
  }
}
