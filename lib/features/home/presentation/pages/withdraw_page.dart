import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Account {
  final String? id;
  final String? accountNumber;
  final String? bankName;

  Account({this.id, this.accountNumber, this.bankName});
}

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<Account?> selectedToAccount = ValueNotifier(null);
  final amountController = TextEditingController();
  List<int> amountExample = [10000, 20000, 50000, 100000, 200000, 500000];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      double a = double.parse(amountController.text.trim());
      Account toAccount = selectedToAccount.value!;

      context.pushNamed(
        AppRouteNames.withdrawSuccess,
        extra: {'toAccount': toAccount, 'amount': a},
      );
    }
  }

  List<Account> getAllAccounts() {
    return [
      Account(id: '1', accountNumber: '1234567890', bankName: 'Bank A'),
      Account(id: '2', accountNumber: '0987654321', bankName: 'Bank B'),
      Account(id: '3', accountNumber: '1122334455', bankName: 'Bank C'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.withdraw,
        child: CustomFormWrapper(
          formKey: _formKey,
          fields: [
            FormFieldConfig(controller: amountController, isRequired: true),
            FormFieldConfig(selectedValue: selectedToAccount, isRequired: true),
          ],
          builder: (isValid) {
            return Column(
              children: [
                ValueListenableBuilder<Account?>(
                  valueListenable: selectedToAccount,
                  builder: (context, value, _) {
                    return CustomDropdownWidget<Account>(
                      label: intl.account,
                      value: selectedToAccount.value,
                      options: getAllAccounts(),
                      displayString: (account) =>
                          '${account.accountNumber ?? ''} ${account.bankName ?? ''}',
                      buildOption: (account, selected) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 4,
                          ),
                          child: Row(
                            children: [
                              Text(
                                account.bankName ?? '',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: selected
                                          ? AppThemes.primary3Color
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  account.accountNumber ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: selected
                                            ? AppThemes.primary3Color
                                            : Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check,
                                  color: AppThemes.primary3Color,
                                ),
                            ],
                          ),
                        );
                      },
                      onChanged: (val) {
                        selectedToAccount.value = val;
                      },
                      isRequired: true,
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomTextInputWidget(
                  size: TextInputSize.large,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  isReadOnly: false,
                  label: intl.amount,
                  isRequired: true,
                  validator: (value) =>
                      CustomValidator().validateAmount(value, intl),
                ),

                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...amountExample.map((amount) {
                      return CustomButton(
                        text: '$amount đ',
                        onPressed: () {
                          if (amountController.text != amount.toString()) {
                            amountController.text = amount.toString();
                          } else {
                            amountController.text = '0';
                          }
                        },
                        customColor: amountController.text != amount.toString() ? Colors.white : AppThemes.primary3Color,
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 16),

                CustomButton(
                  text: intl.confirm,
                  onPressed: isValid ? _submit : () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
