import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/create_pin.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransferConfirmPage extends StatefulWidget {
  final UserModel toUser;
  final double originalAmount;
  final double realAmount;
  final CurrencyEnum currency;
  final String? description;
  final String? groupId;

  const TransferConfirmPage({
    super.key,
    required this.toUser,
    required this.originalAmount,
    required this.realAmount,
    required this.currency,
    required this.description,
    this.groupId,
  });

  @override
  State<TransferConfirmPage> createState() => _TransferConfirmPageState();
}

class _TransferConfirmPageState extends State<TransferConfirmPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController toController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController originalAmountController =
      TextEditingController();
  final TextEditingController realAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController binController = TextEditingController();

  @override
  void initState() {
    super.initState();

    toController.text = widget.toUser.fullName!;
    originalAmountController.text = formatNumber(widget.originalAmount);
    realAmountController.text = formatNumber(widget.realAmount);
    descriptionController.text = widget.description ?? '';
    feeController.text = '0.00';
  }

  @override
  void dispose() {
    toController.dispose();
    feeController.dispose();
    originalAmountController.dispose();
    realAmountController.dispose();
    descriptionController.dispose();
    binController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<RechargeBloc>().add(
        TransferEvent(
          widget.originalAmount,
          widget.realAmount,
          widget.currency.code,
          widget.toUser.id ?? '',
          widget.description ?? '',
          pin: binController.text,
          groupId: widget.groupId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.confirm,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocListener<RechargeBloc, RechargeState>(
                listener: (context, state) {
                  if (state is RechargeSuccessState) {
                    context.pushNamed(
                      AppRouteNames.transferSuccess,
                      extra: {
                        'toUser': widget.toUser, 
                        'amount': widget.originalAmount,
                        'currency': widget.currency,
                      },
                    );
                  }
                  if (state is CreatePinRequired) {
                    showCreatePinDialog(context: context);
                  }
                },
                child: const SizedBox.shrink(),
              ),
              CustomTextInputWidget(
                label: intl.to,
                size: TextInputSize.large,
                controller: toController,
                keyboardType: TextInputType.text,
                isReadOnly: true,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 340,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7, // 70%
                      child:  CustomTextInputWidget(
                        label: intl.originalAmount,
                        size: TextInputSize.large,
                        controller: originalAmountController,
                        keyboardType: TextInputType.number,
                        isReadOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // chỉ cho nhập số
                          ThousandsFormatter(), // formatter của bạn
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Original Amount Currency Dropdown
                    Expanded(
                      flex: 3, // 30%
                      child: CustomTextInputWidget(
                        size: TextInputSize.large,
                        isReadOnly: true,
                        label: intl.expenseCurrencyLabel,
                        controller: TextEditingController(
                            text: widget.currency.code.toUpperCase()),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              widget.currency != CurrencyEnum.vnd
                  ? SizedBox(
                      width: 340,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7, // 70%
                            child:  CustomTextInputWidget(
                              label: intl.realAmount,
                              size: TextInputSize.large,
                              controller: realAmountController,
                              keyboardType: TextInputType.number,
                              isReadOnly: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, // chỉ cho nhập số
                                ThousandsFormatter(), // formatter của bạn
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Real Amount Currency Dropdown
                          Expanded(
                            flex: 3, // 30%
                            child: CustomTextInputWidget(
                              size: TextInputSize.large,
                              isReadOnly: true,
                              label: intl.expenseCurrencyLabel,
                              controller: TextEditingController(
                                  text: 'VND'),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              CustomTextInputWidget(
                label: intl.fee,
                size: TextInputSize.large,
                controller: feeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // chỉ cho nhập số
                  ThousandsFormatter(), // formatter của bạn
                ],
                isReadOnly: true,
              ),
              const SizedBox(height: 8),
              CustomTextInputWidget(
                label: intl.description,
                size: TextInputSize.large,
                controller: descriptionController,
                keyboardType: TextInputType.text,
                isReadOnly: true,
              ),
              const SizedBox(height: 8),
              CustomFormWrapper(
                formKey: _formKey,
                fields: [
                  FormFieldConfig(controller: binController, isRequired: true),
                ],
                builder: (isValid) {
                  return Column(
                    children: [
                      CustomTextInputWidget(
                        size: TextInputSize.large,
                        controller: binController,
                        keyboardType: TextInputType.number,
                        label: intl.binLabel,
                        isRequired: true,
                        isReadOnly: false,
                        validator: (value) =>
                            CustomValidator().validatePin(value, intl),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: intl.confirm,
                        onPressed: isValid ? _submit : null,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
