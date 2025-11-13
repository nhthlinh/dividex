import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFilterWidget extends StatefulWidget {
  final ExpenseFilterArguments? filter;
  final void Function(ExpenseFilterArguments)? onApply;

  const ExpenseFilterWidget({super.key, this.filter, this.onApply});

  @override
  State<ExpenseFilterWidget> createState() => _ExpenseFilterWidgetState();
}

class _ExpenseFilterWidgetState extends State<ExpenseFilterWidget> {
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;

  String? name;
  String? eventId;
  String? groupId;
  String? category;

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
    amountControllerFrom.text = widget.filter?.minAmount?.toString() ?? '';
    amountControllerTo.text = widget.filter?.maxAmount?.toString() ?? '';
    startController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(widget.filter!.start!);
    endController.text = DateFormat('dd/MM/yyyy').format(widget.filter!.end!);
    eventId = widget.filter?.eventId;
    groupId = widget.filter?.groupId;
    category = widget.filter?.category;
    name = widget.filter?.name;
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            final filter = ExpenseFilterArguments(
              start: startDate,
              end: endDate,
              minAmount: minAmount,
              maxAmount: maxAmount,
              name: name,
              groupId: groupId,
              eventId: eventId,
              category: category,
            );
            if (widget.onApply != null) {
              widget.onApply!(filter);
            }
          },
          text: intl.accept,
        ),
      ],
    );
  }
}
