import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class RechargeReport extends StatefulWidget {
  const RechargeReport({super.key});

  @override
  State<RechargeReport> createState() => _RechargeReportState();
}

class _RechargeReportState extends State<RechargeReport> {
  bool isExternal = true;

  @override
  void initState() {
    super.initState();
    context.read<LoadedHistoryBloc>().add(
      GetHistoryInitEvent(1, 10, WalletHistoryType.external),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        title: isExternal ? intl.externalExpense : intl.internalExpense,
        action: IconButton(
          icon: Icon(
            isExternal ? Icons.arrow_circle_down : Icons.arrow_circle_up,
          ),
          color: Colors.white,
          onPressed: () {
            setState(() {
              isExternal = !isExternal;
            });
            context.read<LoadedHistoryBloc>().add(
              GetHistoryInitEvent(
                1,
                10,
                isExternal
                    ? WalletHistoryType.external
                    : WalletHistoryType.internal,
              ),
            );
          },
        ),
        child: Column(
          children: [
            BlocListener<RechargeBloc, RechargeState>(
              listenWhen: (previous, current) => previous != current,
              listener: (context, state) => {
                if (state is GetDepositDetailSuccessState)
                  {
                    showCustomDialog(
                      context: context,
                      content: Column(
                        children: [
                          CustomRow(
                            title: intl.code,
                            info: state.depositDetail.code,
                          ),
                          CustomRow(
                            title: intl.amount,
                            info:
                                '${formatNumber(state.depositDetail.amount)} ${state.depositDetail.currency.code}',
                          ),
                          CustomRow(
                            title: intl.date,
                            info: DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(state.depositDetail.date),
                          ),
                        ],
                      ),
                    ),
                  }
                else if (state is GetWithdrawDetailSuccessState)
                  {
                    showCustomDialog(
                      context: context,
                      content: Column(
                        children: [
                          CustomRow(
                            title: intl.code,
                            info: state.withdrawDetail.code,
                          ),
                          CustomRow(
                            title: intl.amount,
                            info:
                                '${formatNumber(state.withdrawDetail.amount)} ${state.withdrawDetail.bankAccount.currency?.code}',
                          ),
                          CustomRow(
                            title: intl.date,
                            info: DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(state.withdrawDetail.date),
                          ),
                          CustomRow(
                            title: intl.bank,
                            info:
                                '${state.withdrawDetail.bankAccount.accountNumber} - ${state.withdrawDetail.bankAccount.bankName}',
                          ),
                        ],
                      ),
                    ),
                  },
              },
              child: SizedBox.shrink(),
            ),

            BlocBuilder<LoadedHistoryBloc, LoadedHistoryState>(
              buildWhen: (p, c) =>
                  p.externalTransaction != c.externalTransaction ||
                  p.internalTransaction != c.internalTransaction ||
                  p.isLoading != c.isLoading,
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
                } else if (state.externalTransaction.isEmpty && isExternal) {
                  return noTransactionWidget(intl, theme);
                } else if (state.internalTransaction.isEmpty && !isExternal) {
                  return noTransactionWidget(intl, theme);
                }

                return isExternal
                    ? listExternalTransactionResults(intl, state)
                    : listInternalTransactionResults(intl, state);
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  LayoutBuilder noTransactionWidget(AppLocalizations intl, ThemeData theme) {
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

  Column listExternalTransactionResults(
    AppLocalizations intl,
    LoadedHistoryState state,
  ) {
    final hasMore = state.page < state.totalPage;
    final transactions = state.externalTransaction;
    final totalExpenses = transactions.length;

    final groupedTransactions = <String, List<ExternalTransactionModel>>{};
    for (var t in transactions) {
      final key = DateFormat('yyyy-MM-dd').format(t.date.toLocal());
      groupedTransactions.putIfAbsent(key, () => []).add(t);
    }

    final sortedKeys = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        const SizedBox(height: 16),

        // Header tổng số giao dịch
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: intl.externalExpense,
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
                        style: const TextStyle(color: AppThemes.primary3Color),
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
          itemCount: sortedKeys.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Lazy load
            if (index == sortedKeys.length && hasMore) {
              context.read<LoadedHistoryBloc>().add(
                GetHistoryMoreEvent(
                  state.page + 1,
                  10,
                  WalletHistoryType.external,
                ),
              );
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            if (index >= sortedKeys.length) return const SizedBox.shrink();

            final dateKey = sortedKeys[index];
            final dateTransactions = groupedTransactions[dateKey] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dateKey,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        letterSpacing: 0,
                        height: 16 / 12,
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  ),
                ),
                ...dateTransactions.map((t) => ExternalExpenseCard(expense: t)),
              ],
            );
          },
        ),
      ],
    );
  }

  Column listInternalTransactionResults(
    AppLocalizations intl,
    LoadedHistoryState state,
  ) {
    final hasMore = state.page < state.totalPage;
    final transactions = state.internalTransaction;
    final totalExpenses = transactions.length;

    final groupedTransactions = <String, List<InternalTransactionModel>>{};
    for (var t in transactions) {
      final key = DateFormat('yyyy-MM-dd').format(t.date!.toLocal());
      groupedTransactions.putIfAbsent(key, () => []).add(t);
    }

    final sortedKeys = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        const SizedBox(height: 16),

        // Header tổng số giao dịch
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: intl.internalExpense,
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
                        style: const TextStyle(color: AppThemes.primary3Color),
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
          itemCount: sortedKeys.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Lazy load
            if (index == sortedKeys.length && hasMore) {
              context.read<LoadedHistoryBloc>().add(
                GetHistoryMoreEvent(
                  state.page + 1,
                  10,
                  WalletHistoryType.internal,
                ),
              );
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            if (index >= sortedKeys.length) return const SizedBox.shrink();

            final dateKey = sortedKeys[index];
            final dateTransactions = groupedTransactions[dateKey] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dateKey,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        letterSpacing: 0,
                        height: 16 / 12,
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  ),
                ),
                ...dateTransactions.map((t) => InternalExpenseCard(expense: t)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title cố định, không wrap
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
          ),

          const SizedBox(width: 12),

          // Info ăn toàn bộ phần còn lại, wrap khi dài
          Expanded(
            child: Text(
              info,
              softWrap: true,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppThemes.primary3Color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExternalExpenseCard extends StatelessWidget {
  const ExternalExpenseCard({super.key, required this.expense});

  final ExternalTransactionModel expense;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: '${expense.code.substring(0, 8)}...',
      subtitle: DateFormat('dd/MM/yyyy HH:mm').format(expense.date),
      trailing: Column(
        children: [
          Text(
            (expense.type == ExternalTransactionType.deposit
                ? '+ ${formatNumber(expense.amount)} ${expense.currency.code}'
                : '- ${formatNumber(expense.amount.abs())} ${expense.currency.code}'),
            style: TextStyle(
              color: (expense.type == ExternalTransactionType.deposit)
                  ? AppThemes.successColor
                  : AppThemes.minusMoney,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: () {
        if (expense.type == ExternalTransactionType.deposit) {
          context.read<RechargeBloc>().add(GetDepositDetailEvent(expense.id));
        } else if (expense.type == ExternalTransactionType.withdraw) {
          context.read<RechargeBloc>().add(GetWithdrawDetailEvent(expense.id));
        }
      },
    );
  }
}

class InternalExpenseCard extends StatelessWidget {
  const InternalExpenseCard({super.key, required this.expense});

  final InternalTransactionModel expense;

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return InfoCard(
      title: '${expense.code?.substring(0, 8)}...',
      subtitle: DateFormat('HH:mm').format(expense.date!),
      trailing: Column(
        children: [
          Text(
            (expense.toUser == HiveService.getUser().fullName)
                ? '+ ${formatNumber(expense.amount ?? 0)} VND'
                : '- ${formatNumber(expense.amount?.abs() ?? 0)} VND',
            style: TextStyle(
              color: (expense.toUser == HiveService.getUser().fullName)
                  ? AppThemes.successColor
                  : AppThemes.minusMoney,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (expense.toUser == HiveService.getUser().fullName)
                ? '${intl.from} ${expense.fromUser}'
                : '${intl.to} ${expense.toUser}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onTap: () {
        showCustomDialog(
          context: context,
          content: Column(
            children: [
              CustomRow(title: intl.from, info: expense.fromUser ?? ''),
              CustomRow(title: intl.to, info: expense.toUser ?? ''),
              CustomRow(
                title: intl.amount,
                info: '${formatNumber(expense.amount ?? 0)} VND',
              ),
              CustomRow(title: intl.code, info: expense.code ?? ''),
              CustomRow(title: intl.group, info: expense.group ?? ''),
              CustomRow(
                title: intl.date,
                info: DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format(expense.date ?? DateTime.now()),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        intl.description,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        expense.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppThemes.primary3Color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
