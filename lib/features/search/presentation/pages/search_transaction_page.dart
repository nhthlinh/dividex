import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/presentation/pages/all_expense_report.dart';
import 'package:Dividex/features/group/presentation/pages/hard_delete_expense.dart';
import 'package:Dividex/features/home/presentation/recharge_report.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/features/search/presentation/bloc/search_transaction_bloc.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SearchTransactionPage extends StatefulWidget {
  const SearchTransactionPage({super.key});

  @override
  State<SearchTransactionPage> createState() => _SearchTransactionPageState();
}

class _SearchTransactionPageState extends State<SearchTransactionPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 1,
      child: SimpleLayout(
        title: intl.transaction,
        child: Column(
          children: [
            // Search
            CustomTextInputWidget(
              size: TextInputSize.large,
              isReadOnly: false,
              keyboardType: TextInputType.text,
              label: intl.searchTab,
              controller: _searchController,
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<SearchTransactionBloc>().add(
                    InitialEvent(
                      SearchTransactionTypeEnum.all,
                      ExpenseFilterArguments(name: _searchController.text),
                      ExternalTransactionFilterArguments(
                        code: _searchController.text,
                      ),
                      InternalTransactionFilterArguments(
                        code: _searchController.text,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ),

            // results
            BlocBuilder<SearchTransactionBloc, SearchTransactionsState>(
              buildWhen: (p, c) => p.isLoading != c.isLoading,
              builder: (context, searchState) {
                if (searchState.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (searchState.expense.isEmpty &&
                    searchState.externalTransactions.isEmpty &&
                    searchState.internalTransactions.isEmpty) {
                  return notFoundWidget(intl, context);
                }

                final hasMore = searchState.page < searchState.totalPage;
                final expense = searchState.expense;
                final external = searchState.externalTransactions;
                final internal = searchState.internalTransactions;

                return Column(
                  children: [
                    if (expense.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          intl.expense,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...expense.map((e) => expenseCard(e, context, intl)),
                    ],
                    if (external.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          intl.externalExpense,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...external.map((e) => ExternalExpenseCard(expense: e)),
                    ],
                    if (internal.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          intl.internalExpense,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...internal.map((e) => InternalExpenseCard(expense: e)),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Center notFoundWidget(AppLocalizations intl, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            intl.noSearchResults,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            intl.tryDifferentKeyword,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

Widget expenseCard(
  ExpenseModel expense,
  BuildContext context,
  AppLocalizations intl,
) {
  return InfoCard(
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
            color: (expense.totalAmount != null && expense.totalAmount! >= 0)
                ? AppThemes.successColor
                : AppThemes.minusMoney,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          (expense.totalAmount != null && expense.category != 'Transfer')
              ? (expense.totalAmount! >= 0 ? intl.youLent : intl.youBorrowed)
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
  );
}
