import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionFilterWidget extends StatefulWidget {
  final bool? isExternal;
  final InternalTransactionFilterArguments? internalFilter;
  final ExternalTransactionFilterArguments? externalFilter;
  final void Function(InternalTransactionFilterArguments)? onApplyInternal;
  final void Function(ExternalTransactionFilterArguments)? onApplyExternal;

  const TransactionFilterWidget({
    super.key,
    this.isExternal,
    this.internalFilter,
    this.externalFilter,
    this.onApplyInternal,
    this.onApplyExternal,
  });

  @override
  State<TransactionFilterWidget> createState() =>
      _TransactionFilterWidgetState();
}

class _TransactionFilterWidgetState extends State<TransactionFilterWidget> {
  bool isExternal = true;

  // Common filters
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;

  // Internal-specific
  String? name;
  String? groupId;
  String? code;

  final amountControllerFrom = TextEditingController();
  final amountControllerTo = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();

  @override
  void dispose() {
    amountControllerFrom.dispose();
    amountControllerTo.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isExternal != null) {
      isExternal = widget.isExternal!;
      amountControllerFrom.text = widget.isExternal!
          ? widget.externalFilter?.minAmount?.toString() ?? ''
          : widget.internalFilter?.minAmount?.toString() ?? '';
      amountControllerTo.text = widget.isExternal!
          ? widget.externalFilter?.maxAmount?.toString() ?? ''
          : widget.internalFilter?.maxAmount?.toString() ?? '';
      startController.text = widget.isExternal!
          ? widget.externalFilter?.start != null
                ? DateFormat('dd/MM/yyyy').format(widget.externalFilter!.start!)
                : ''
          : widget.internalFilter?.start != null
          ? DateFormat('dd/MM/yyyy').format(widget.internalFilter!.start!)
          : '';
      if (widget.internalFilter != null) {
        name = widget.internalFilter?.name;
        groupId = widget.internalFilter?.groupId;
      }
      if (widget.externalFilter != null) {
        code = widget.externalFilter?.code;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              size: ButtonSize.medium,
              type: isExternal ? ButtonType.secondary : ButtonType.primary,
              text: intl.internalExpense,
              onPressed: () {
                setState(() {
                  isExternal = false;
                });
              },
            ),
            CustomButton(
              size: ButtonSize.medium,
              type: isExternal ? ButtonType.primary : ButtonType.secondary,
              text: intl.externalExpense,
              onPressed: () {
                setState(() {
                  isExternal = true;
                });
              },
            ),
          ],
        ),
        // Date Range Inputs
        SizedBox(
          width: 340,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5, // 60%
                child: DateInputField(
                  label: intl.from,
                  hintText: '13/05/2025',
                  controller: startController,
                  size: TextInputSize.large,
                  isRequired: true,
                  validator: null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5, // 40%
                child: DateInputField(
                  label: intl.to,
                  hintText: '13/05/2025',
                  controller: endController,
                  size: TextInputSize.large,
                  isRequired: true,
                  validator: null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Amount Range Inputs
        SizedBox(
          width: 340,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: CustomTextInputWidget(
                  size: TextInputSize.large,
                  isReadOnly: false,
                  isRequired: true,
                  label: intl.from,
                  hintText: intl.expenseAmountHint,
                  controller: amountControllerFrom,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      CustomValidator().validateAmount(value, intl),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: CustomTextInputWidget(
                  size: TextInputSize.large,
                  isReadOnly: false,
                  isRequired: true,
                  label: intl.to,
                  hintText: intl.expenseAmountHint,
                  controller: amountControllerTo,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      CustomValidator().validateAmount(value, intl),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        CustomButton(
          size: ButtonSize.large,
          onPressed: () {
            if (isExternal) {
              final filter = ExternalTransactionFilterArguments(
                start: startDate,
                end: endDate,
                minAmount: minAmount,
                maxAmount: maxAmount,
              );
              if (widget.onApplyExternal != null) {
                widget.onApplyExternal!(filter);
              }
            } else {
              final filter = InternalTransactionFilterArguments(
                start: startDate,
                end: endDate,
                minAmount: minAmount,
                maxAmount: maxAmount,
                name: name,
                groupId: groupId,
              );
              if (widget.onApplyInternal != null) {
                widget.onApplyInternal!(filter);
              }
            }
          },
          text: intl.accept,
        ),
      ],
    );
  }
}
