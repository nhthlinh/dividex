import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/features/search/presentation/pages/filter_page.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionFilterWidget extends StatefulWidget {
  final FilterType type;
  final InternalTransactionFilterArguments? internalFilter;
  final ExternalTransactionFilterArguments? externalFilter;
  final void Function(InternalTransactionFilterArguments)? onApplyInternal;
  final void Function(ExternalTransactionFilterArguments)? onApplyExternal;

  const TransactionFilterWidget({
    super.key,
    required this.type,
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
  FilterType type = FilterType.externalTransaction;

  // Common filters
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;

  // Internal-specific
  String? keyword;
  String? groupId;

  // External
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
    type = widget.type;
    amountControllerFrom.text = widget.type == FilterType.externalTransaction
        ? widget.externalFilter?.minAmount?.toString() ?? ''
        : widget.internalFilter?.minAmount?.toString() ?? '';
    amountControllerTo.text = widget.type == FilterType.externalTransaction
        ? widget.externalFilter?.maxAmount?.toString() ?? ''
        : widget.internalFilter?.maxAmount?.toString() ?? '';
    startController.text = widget.type == FilterType.externalTransaction
        ? widget.externalFilter?.start != null
              ? DateFormat('dd/MM/yyyy').format(widget.externalFilter!.start!)
              : ''
        : widget.internalFilter?.start != null
        ? DateFormat('dd/MM/yyyy').format(widget.internalFilter!.start!)
        : '';
    endController.text = widget.type == FilterType.externalTransaction
        ? widget.externalFilter?.end != null
              ? DateFormat('dd/MM/yyyy').format(widget.externalFilter!.end!)
              : ''
        : widget.internalFilter?.end != null
        ? DateFormat('dd/MM/yyyy').format(widget.internalFilter!.end!)
        : '';
    if (widget.internalFilter != null &&
        widget.type == FilterType.internalTransaction) {
      keyword = widget.internalFilter?.keyword;
      groupId = widget.internalFilter?.groupId;
    }
    if (widget.externalFilter != null &&
        widget.type == FilterType.externalTransaction) {
      code = widget.externalFilter?.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            if (type == FilterType.externalTransaction) {
              final filter = ExternalTransactionFilterArguments(
                start: startController.text.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(startController.text) : null,
                end: endController.text.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(endController.text) : null,
                minAmount: double.tryParse(amountControllerFrom.text),
                maxAmount: double.tryParse(amountControllerTo.text),
              );
              if (widget.onApplyExternal != null) {
                widget.onApplyExternal!(filter);
              }
            } else if (type == FilterType.internalTransaction) {
              final filter = InternalTransactionFilterArguments(
                start: startController.text.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(startController.text) : null,
                end: endController.text.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(endController.text) : null,
                minAmount: double.tryParse(amountControllerFrom.text),
                maxAmount: double.tryParse(amountControllerTo.text),
                keyword: keyword,
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
