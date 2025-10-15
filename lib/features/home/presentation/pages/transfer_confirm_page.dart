import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransferConfirmPage extends StatefulWidget {
  final UserModel toUser;
  final double amount;
  final String? description;
  const TransferConfirmPage({
    super.key,
    required this.toUser,
    required this.amount,
    required this.description,
  });

  @override
  State<TransferConfirmPage> createState() => _TransferConfirmPageState();
}

class _TransferConfirmPageState extends State<TransferConfirmPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController toController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController binController = TextEditingController();

  @override
  void initState() {
    super.initState();

    toController.text = widget.toUser.fullName!;
    amountController.text = widget.amount.toString();
    descriptionController.text = widget.description ?? '';
    feeController.text = '0.00';
  }

  @override
  void dispose() {
    toController.dispose();
    feeController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    binController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Process the transfer here
      context.pushNamed(
        AppRouteNames.transferSuccess,
        extra: {
          'toUser': widget.toUser,
          'amount': widget.amount,
        },
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextInputWidget(
              size: TextInputSize.large,
              controller: toController,
              keyboardType: TextInputType.text,
              isReadOnly: true,
            ),
            const SizedBox(height: 8),
            CustomTextInputWidget(
              size: TextInputSize.large,
              controller: amountController,
              keyboardType: TextInputType.number,
              isReadOnly: true,
            ),
            const SizedBox(height: 8),
            CustomTextInputWidget(
              size: TextInputSize.large,
              controller: feeController,
              keyboardType: TextInputType.number,
              isReadOnly: true,
            ),
            const SizedBox(height: 8),
            CustomTextInputWidget(
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
                      validator: (value) => CustomValidator().validateNumberInput(value, intl),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: intl.confirm,
                      onPressed: isValid ? _submit : () {},
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
