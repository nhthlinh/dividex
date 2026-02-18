import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<BankAccount?> selectedToAccount = ValueNotifier(null);
  final amountController = TextEditingController();
  List<int> amountExample = [10000, 20000, 50000, 100000, 200000, 500000];

  final clearFormTrigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAccountsEvent());
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      double a = double.parse(amountController.text.trim().replaceAll('.', ''));
      BankAccount toAccount = selectedToAccount.value!;

      context.read<RechargeBloc>().add(
        CreateWithdrawEvent(a, toAccount.accountNumber, toAccount.bankName),
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
          context.read<AccountBloc>().add(GetAccountsEvent());
          clearFormTrigger.value = !clearFormTrigger.value; // Trigger form reset
          return Future.value();
        },
        title: intl.withdraw,
        child: CustomFormWrapper(
          clearTrigger: clearFormTrigger,
          formKey: _formKey,
          fields: [
            FormFieldConfig(controller: amountController, isRequired: true),
            FormFieldConfig(selectedValue: selectedToAccount, isRequired: true),
          ],
          builder: (isValid) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  BlocListener<RechargeBloc, RechargeState>(
                    listenWhen: (p, c) => p != c,
                    listener: (context, state) {
                      double a = double.parse(
                        amountController.text.trim().replaceAll('.', ''),
                      );
                      BankAccount toAccount = selectedToAccount.value!;
                      if (state is RechargeSuccessState) {
                        context.pushNamed(
                          AppRouteNames.withdrawSuccess,
                          extra: {'toAccount': toAccount, 'amount': a},
                        );
                      }
                    },
                    child: SizedBox.shrink(),
                  ),

                  BlocBuilder<AccountBloc, AccountState>(
                    buildWhen: (p, c) => p.accounts != c.accounts,
                    builder: (context, state) {
                      if (state.accounts.isEmpty) {
                        return Center(
                          child: SpinKitFadingCircle(
                            color: AppThemes.primary3Color,
                          ),
                        );
                      } else {
                        final accounts = state.accounts;

                        if (accounts.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!context.mounted) return;
                            showCustomToast(
                              'You have not linked any bank account yet. Please add an account to proceed with withdrawal.',
                              type: ToastType.error,
                            );
                          });
                        }

                        return ValueListenableBuilder<BankAccount?>(
                          valueListenable: selectedToAccount,
                          builder: (context, value, _) {
                            return CustomDropdownWidget<BankAccount>(
                              label: intl.account,
                              value: selectedToAccount.value,
                              options: accounts,
                              displayString: (account) =>
                                  '${account.accountNumber} ${account.bankName}',
                              buildOption: (account, selected) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        account.bankName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
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
                                          account.accountNumber,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
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
                        );
                      }
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
                        return Container(
                          margin: const EdgeInsets.all(4),
                          child: CustomButton(
                            size: ButtonSize.medium,
                            text:
                                '${formatNumber(amount)} ${HiveService.getUser().preferredCurrency ?? 'VND'}',
                            onPressed: () {
                              setState(() {
                                if (amountController.text !=
                                    amount.toString()) {
                                  amountController.text = amount.toString();
                                } else {
                                  amountController.text = '0';
                                }
                              });
                            },
                            customColor:
                                amountController.text != amount.toString()
                                ? const Color.fromARGB(137, 232, 140, 160)
                                : AppThemes.primary3Color,
                          ),
                        );
                      }),
                    ],
                  ),

                  const Spacer(),
                  CustomButton(
                    text: intl.confirm,
                    onPressed: isValid ? _submit : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
