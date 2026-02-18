import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/features/search/presentation/expense_filter.dart';
import 'package:Dividex/features/search/presentation/wallet_filter.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';

enum FilterType {
  all,
  expense,
  transaction,
  internalTransaction,
  externalTransaction,
}

class FilterPage extends StatefulWidget {
  final FilterType filterType;
  final ExpenseFilterArguments? initialExpenseFilter;
  final ExternalTransactionFilterArguments? initialExternalFilter;
  final InternalTransactionFilterArguments? initialInternalFilter;
  final void Function(ExpenseFilterArguments)? onApplyExpense;
  final void Function(ExternalTransactionFilterArguments)? onApplyExternal;
  final void Function(InternalTransactionFilterArguments)? onApplyInternal;
  const FilterPage({
    super.key,
    required this.filterType,
    this.initialExpenseFilter,
    this.initialExternalFilter,
    this.initialInternalFilter,
    this.onApplyExpense,
    this.onApplyExternal,
    this.onApplyInternal,
  });
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  FilterType type = FilterType.all;
  FilterType typeBig = FilterType.all;

  @override
  void initState() {
    super.initState();
    typeBig =
        widget.filterType == FilterType.externalTransaction ||
            widget.filterType == FilterType.internalTransaction
        ? FilterType.transaction
        : widget.filterType == FilterType.expense
        ? FilterType.expense
        : FilterType.all;
    type = widget.filterType;
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 1,
      child: SimpleLayout(
        onRefresh: () {
          typeBig =
              widget.filterType == FilterType.externalTransaction ||
                  widget.filterType == FilterType.internalTransaction
              ? FilterType.transaction
              : widget.filterType == FilterType.expense
              ? FilterType.expense
              : FilterType.all;
          type = widget.filterType;
          
          return Future.value();
        },
        title: intl.filter,
        child: Column(
          children: [
            Image(
              image: AssetImage("lib/assets/images/filter_image.png"),
              width: 200,
              height: 200,
            ),
            SizedBox(height: 8),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  intl.chooseTypeFilter,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                    height: 16 / 12,
                    color: Colors.grey,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    filterTypeBigButton(intl.wallet, FilterType.transaction),
                    filterTypeBigButton(intl.expense, FilterType.expense),
                  ],
                ),
              ],
            ),

            if (typeBig == FilterType.transaction) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    intl.inOrEx,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 12,
                      letterSpacing: 0,
                      height: 16 / 12,
                      color: Colors.grey,
                    ),
                  ),
                  filterTypeButton(
                    intl.internalExpense,
                    FilterType.internalTransaction,
                  ),
                  filterTypeButton(
                    intl.externalExpense,
                    FilterType.externalTransaction,
                  ),
                ],
              ),
            ],

            if (type == FilterType.expense) ...[
              ExpenseFilterWidget(
                key: const ValueKey('expense'),
                filter: widget.initialExpenseFilter,
                onApply: (filter) {
                  widget.onApplyExpense?.call(filter);
                  Navigator.pop(context);
                },
              ),
            ] else if (type == FilterType.externalTransaction) ...[
              TransactionFilterWidget(
                key: const ValueKey('external'),
                type: FilterType.externalTransaction,
                externalFilter: widget.initialExternalFilter,
                onApplyExternal: (filter) {
                  widget.onApplyExternal?.call(filter);
                  Navigator.pop(context);
                },
              ),
            ] else if (type == FilterType.internalTransaction) ...[
              TransactionFilterWidget(
                key: const ValueKey('internal'),
                type: FilterType.internalTransaction,
                internalFilter: widget.initialInternalFilter,
                onApplyInternal: (filter) {
                  widget.onApplyInternal?.call(filter);
                  Navigator.pop(context);
                },
              ),
            ],

            const SizedBox(height: 16),
            CustomButton(
              customColor: AppThemes.errorColor,
              text: intl.cancel,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  CustomButton filterTypeButton(String label, FilterType filterType) {
    return CustomButton(
      size: ButtonSize.small,
      type: type == filterType ? ButtonType.primary : ButtonType.secondary,
      text: label,
      onPressed: () {
        setState(() {
          type = filterType;
          if (filterType == FilterType.expense) {
            setState(() {
              typeBig = filterType;
            });
          }
        });
      },
    );
  }

  CustomButton filterTypeBigButton(String label, FilterType filterType) {
    return CustomButton(
      size: ButtonSize.medium,
      type: typeBig == filterType ? ButtonType.primary : ButtonType.secondary,
      text: label,
      onPressed: () {
        setState(() {
          typeBig = filterType;
          if (filterType == FilterType.expense) {
            type = filterType;
          }
        });
      },
    );
  }
}
