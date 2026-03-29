import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/features/home/presentation/bloc/account/verify_account_bloc.dart';
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
  static const Key accountNumberInputKey = Key('add_account_number_input');
  static const Key bankDropdownKey = Key('add_account_bank_dropdown');
  static const Key accountNameInputKey = Key('add_account_name_input');
  static const Key currencyDropdownKey = Key('add_account_currency_dropdown');
  static const Key submitButtonKey = Key('add_account_submit_button');

  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final accountNumber = TextEditingController();
  final accountName = TextEditingController();
  final branch = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<BankInfo?> selectedBranch = ValueNotifier(null);
  ValueNotifier<CurrencyEnum> selectedCurrency = ValueNotifier(
    CurrencyEnum.vnd,
  );

  final clearFormTrigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    accountNumber.addListener(_checkAndTrigger);
    selectedBranch.addListener(_checkAndTrigger);
  }

  void _checkAndTrigger() {
    final acc = accountNumber.text.trim();
    final bank = selectedBranch.value;

    if (acc.isNotEmpty && bank != null) {
      _onAccountBankReady();
    }
  }

  void _onAccountBankReady() {
    String accNumber = accountNumber.text.trim();
    context.read<VerifyAccountBloc>().add(
      VerifyAccountEvent(accNumber, selectedBranch.value?.code ?? ''),
    );
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
        onRefresh: () {
          clearFormTrigger.value =
              !clearFormTrigger.value; // Trigger form reset
          return Future.value();
        }, // No specific refresh logic needed for this page
        title: intl.account,
        child: CustomFormWrapper(
          clearTrigger: clearFormTrigger,
          formKey: _formKey,
          fields: [
            FormFieldConfig(controller: accountNumber, isRequired: true),
            FormFieldConfig(selectedValue: selectedBranch, isRequired: true),
            FormFieldConfig(selectedValue: selectedCurrency, isRequired: true),
            FormFieldConfig(controller: accountName, isRequired: true),
          ],
          builder: (isValid, isSubmitting, setSubmitting) => Column(
            children: [
              CustomTextInputWidget(
                textFieldKey: AddAccountPage.accountNumberInputKey,
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
                    key: AddAccountPage.bankDropdownKey,
                    label: intl.bank,
                    value: value,
                    options: banksList,
                    displayString: (b) => b.shortName,
                    buildOption: (b, selected) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              b.logo,
                              height: 50,
                              width: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.account_balance),
                            ),
                            const SizedBox(width: 4),
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
              BlocListener<VerifyAccountBloc, VerifyAccountState>(
                listener: (context, state) {
                  if (state is VerifyAccountSuccessState) {
                    accountName.text = state.accountName;
                  }
                },
                child: CustomTextInputWidget(
                  textFieldKey: AddAccountPage.accountNameInputKey,
                  size: TextInputSize.large,
                  controller: accountName,
                  keyboardType: TextInputType.text,
                  isReadOnly: true,
                  isRequired: true,
                  label: intl.accountName,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<CurrencyEnum>(
                valueListenable: selectedCurrency,
                builder: (context, value, _) {
                  return CustomDropdownWidget<CurrencyEnum>(
                    key: AddAccountPage.currencyDropdownKey,
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
                buttonKey: AddAccountPage.submitButtonKey,
                text: intl.add,
                onPressed: (!isValid || isSubmitting)
                    ? null
                    : () async {
                        setSubmitting(true);

                        _submit();

                        setSubmitting(false);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
