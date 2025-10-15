import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/shared/models/banks.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final accountNumber = TextEditingController();
  final branch = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<BankInfo?> selectedBranch = ValueNotifier(null);
  ValueNotifier<CurrencyEnum> selectedCurrency = ValueNotifier(
    CurrencyEnum.vnd,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accountNumber.dispose();
    branch.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      String accNumber = accountNumber.text.trim();

      context.read<AccountBloc>().add(
        CreateAccountEvent(
          BankAccount(
            id: '',
            bankName: selectedBranch.value?.code ?? '',
            accountNumber: accNumber,
            currency: selectedCurrency.value,
          ),
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
        title: intl.account,
        child: CustomFormWrapper(
          formKey: _formKey,
          fields: [
            FormFieldConfig(controller: accountNumber, isRequired: true),
            FormFieldConfig(selectedValue: selectedBranch, isRequired: true),
            FormFieldConfig(selectedValue: selectedCurrency, isRequired: true),
          ],
          builder: (isValid) => Column(
            children: [
              CustomTextInputWidget(
                size: TextInputSize.large,
                controller: accountNumber,
                keyboardType: TextInputType.number,
                isReadOnly: false,
                isRequired: true,
                label: intl.accountNumberLabel,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<BankInfo?>(
                valueListenable: selectedBranch,
                builder: (context, value, _) {
                  return CustomDropdownWidget<BankInfo>(
                    label: intl.branch,
                    value: value,
                    options: banksList,
                    displayString: (b) => '${b.shortName} - ${b.code}',
                    buildOption: (b, selected) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              b.logo,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.account_balance),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              b.shortName,
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
                                b.code,
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
                      selectedBranch.value = val;
                    },
                    isRequired: true,
                  );
                },
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<CurrencyEnum>(
                valueListenable: selectedCurrency,
                builder: (context, value, _) {
                  return CustomDropdownWidget<CurrencyEnum>(
                    label: intl.expenseCurrencyLabel,
                    value: selectedCurrency.value,
                    options: getAllCurrencies().map((e) => e).toList(),
                    displayString: (b) => b.code,
                    buildOption: (b, selected) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Text(
                              b.code,
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
                                b.description,
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
                      selectedCurrency.value = val!;
                    },
                    isRequired: true,
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: intl.add,
                onPressed: isValid
                    ? () {
                        _submit();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
