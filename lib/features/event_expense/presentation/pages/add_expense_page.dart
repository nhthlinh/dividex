import 'dart:typed_data';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/features/image/presentation/widgets/image_picker_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:Dividex/shared/widgets/two_option_selector_widget.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final ValueNotifier<CurrencyEnum> _selectedCurrency = ValueNotifier(
    CurrencyEnum.vnd,
  );
  final ValueNotifier<CategoryModel?> _selectedCategory = ValueNotifier(null);
  final TextEditingController selectedEventTextEditingController =
      TextEditingController();
  EventModel? _selectedEvent;
  final TextEditingController selectedPayerTextEditingController =
      TextEditingController();
  UserModel? _selectedPayer;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  List<Uint8List?> images = [];
  SplitTypeEnum splitType = SplitTypeEnum.equal;
  List<UserDebt> userDebts = [];
  List<UserModel> users = [];
  List<UserModel> usersInEvent = [];

  final List<CurrencyEnum> _units = getAllCurrencies().map((e) => e).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    expenseNameController.dispose();
    expenseAmountController.dispose();
    selectedEventTextEditingController.dispose();
    selectedPayerTextEditingController.dispose();
    noteController.dispose();
    dateController.dispose();
    reminderController.dispose();
    super.dispose();
  }

  void submitExpense() {
    if (formKey.currentState?.validate() ?? false) {
      final intl = AppLocalizations.of(context)!;
      final formattedDate = DateFormat(
        "yyyy-MM-dd HH:mm",
      ).format(DateFormat("h:mm a - dd/MM/yyyy").parse(dateController.text));

      String formattedReminder = reminderController.text.isNotEmpty
          ? DateFormat(
              "yyyy-MM-dd",
            ).format(DateFormat("dd/MM/yyyy").parse(reminderController.text))
          : '';

      if (userDebts.isEmpty) {
        return;
      }

      if (splitType == SplitTypeEnum.equal && userDebts.isNotEmpty) {
        userDebts = calculateUserDebts(
          usersInEvent,
          double.tryParse(expenseAmountController.text) ?? 0,
        );
      }

      if (splitType == SplitTypeEnum.custom && userDebts.isNotEmpty) {
        final totalDebt = userDebts.fold<double>(
          0,
          (previousValue, element) => previousValue + (element.amount),
        );
        final totalAmount = double.tryParse(expenseAmountController.text) ?? 0;
        if (totalDebt != totalAmount) {
          showCustomToast(intl.expenseSplitNotMatch, type: ToastType.error);
          return;
        }
      }

      context.read<ExpenseBloc>().add(
        CreateExpenseEvent(
          expenseNameController.text,
          double.tryParse(expenseAmountController.text) ?? 0,
          _selectedCurrency.value!.code,
          _selectedCategory.value!.key,
          _selectedEvent!.id!,
          _selectedPayer!.id,
          noteController.text,
          formattedDate,
          formattedReminder,
          splitType,
          userDebts,
          images.whereType<Uint8List>().toList(),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(
      context,
    )!; // Lấy đối tượng AppLocalizations

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(title: intl.addExpense, child: expenseForm(intl)),
    );
  }

  CustomFormWrapper expenseForm(AppLocalizations intl) {
    return CustomFormWrapper(
      formKey: formKey,
      fields: [
        FormFieldConfig(controller: expenseNameController, isRequired: true),
        FormFieldConfig(controller: expenseAmountController, isRequired: true),
        FormFieldConfig(selectedValue: _selectedCurrency, isRequired: true),
        FormFieldConfig(selectedValue: _selectedCategory, isRequired: true),
        FormFieldConfig(
          controller: selectedEventTextEditingController,
          isRequired: true,
        ),
        FormFieldConfig(
          controller: selectedPayerTextEditingController,
          isRequired: true,
        ),
        FormFieldConfig(controller: dateController, isRequired: true),
      ],
      builder: (isValid) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            intl.addExpenseSubtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12,
              letterSpacing: 0,
              height: 16 / 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),

          CustomTextInputWidget(
            size: TextInputSize.large,
            isReadOnly: false,
            isRequired: true,
            label: intl.expenseNameLabel,
            hintText: intl.expenseNameHint,
            controller: expenseNameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 340,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7, // 70%
                  child: CustomTextInputWidget(
                    size: TextInputSize.large,
                    isReadOnly: false,
                    isRequired: true,
                    label: intl.expenseAmountLabel,
                    hintText: intl.expenseAmountHint,
                    controller: expenseAmountController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        CustomValidator().validateAmount(value, intl),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3, // 30%
                  child: ValueListenableBuilder<CurrencyEnum>(
                    valueListenable: _selectedCurrency,
                    builder: (context, value, _) {
                      return CustomDropdownWidget<CurrencyEnum>(
                        label: intl.expenseCurrencyLabel,
                        value: _selectedCurrency.value,
                        options: _units,
                        displayString: (b) => b.code,
                        buildOption: (b, selected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            child: Row(
                              children: [
                                // if (b.avatarUrl != null)
                                //   Image.network(
                                //     b.avatarUrl!,
                                //     width: 50,
                                //     height: 50,
                                //     errorBuilder: (context, error, stackTrace) =>
                                //         const Icon(Icons.group),
                                //   )
                                // else
                                //   const Icon(Icons.group),
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
                          _selectedCurrency.value = val!;
                        },
                        isRequired: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<CategoryModel?>(
            valueListenable: _selectedCategory,
            builder: (context, value, _) {
              return CustomDropdownWidget<CategoryModel>(
                label: intl.expenseCategoryLabel,
                value: _selectedCategory.value,
                options: CategoryModel.categories,
                displayString: (b) => b.localizedName(context),
                buildOption: (b, selected) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            b.localizedName(context),
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
                  _selectedCategory.value = val;
                },
                isRequired: true,
              );
            },
          ),

          const SizedBox(height: 16),

          CustomTextInputWidget(
            size: TextInputSize.large,
            controller: selectedEventTextEditingController,
            keyboardType: TextInputType.text,
            isReadOnly: true,
            isRequired: true,
            label: intl.expenseEventLabel,
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
            onTap: () {
              context.pushNamed(
                AppRouteNames.chooseEvent,
                extra: {
                  'initialSelected': _selectedEvent,
                  'onChanged': (EventModel event) {
                    setState(() {
                      _selectedEvent = event;
                      selectedEventTextEditingController.text =
                          event.name ?? '----';
                    });
                  },
                },
              );
            },
          ),

          const SizedBox(height: 8),
          if (_selectedEvent != null) ...[
            CustomTextInputWidget(
              size: TextInputSize.large,
              controller: selectedPayerTextEditingController,
              keyboardType: TextInputType.text,
              isReadOnly: true,
              isRequired: true,
              label: intl.expensePayerLabel,
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
              onTap: () {
                context.pushNamed(
                  AppRouteNames.chooseMember,
                  extra: {
                    'id': _selectedEvent?.id,
                    'type': user_event.LoadType.eventParticipants,
                    'initialSelected': _selectedPayer != null
                        ? [_selectedPayer!]
                        : <UserModel>[],
                    'onChanged': (List<UserModel> user) {
                      setState(() {
                        _selectedPayer = user.first;
                        selectedPayerTextEditingController.text =
                            user.first.fullName ?? '----';
                      });
                    },
                    'isMultiSelect': false,
                    'isCanChooseMyself': true,
                  },
                );
              },
            ),
            UserGrid(
              users: _selectedPayer != null ? [_selectedPayer!] : [],
              onTap: (user) {
                setState(() {
                  _selectedPayer = null;
                  selectedPayerTextEditingController.text = '';
                });
              },
            ),
          ],

          const SizedBox(height: 8),
          CustomTextInputWidget(
            size: TextInputSize.large,
            isReadOnly: false,
            label: intl.expenseNoteLabel,
            controller: noteController,
            keyboardType: TextInputType.text,
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: 340,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6, // 60%
                  child: DateInputField(
                    label: intl.expenseDateLabel,
                    hintText: '4:30 p.m - 13/05/2025',
                    controller: dateController,
                    size: TextInputSize.large,
                    isRequired: true,
                    validator: null,
                    isPickedHour: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4, // 40%
                  child: DateInputField(
                    label: intl.expenseReminderLabel,
                    hintText: '13/05/2025',
                    controller: reminderController,
                    size: TextInputSize.medium,
                    isRequired: true,
                    validator: null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.addExpenseImageLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                  letterSpacing: 0,
                  height: 16 / 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ImagePickerWidget(
                type: PickerType.gallery,
                onFilesPicked: (imageBytesList) {
                  setState(() {
                    images = imageBytesList;
                  });
                },
              ),
            ],
          ),

          if (_selectedEvent != null &&
              expenseAmountController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            BlocProvider(
              create: (context) => LoadedUsersBloc()
                ..add(
                  user_event.InitialEvent(
                    _selectedEvent?.id,
                    user_event.LoadType.eventParticipants,
                  ),
                ),
              child: twoOptionSelector(intl),
            ),
          ],

          const SizedBox(height: 20),

          CustomButton(
            text: intl.add,
            onPressed:
                (isValid &&
                    userDebts.isNotEmpty &&
                    userDebts.fold<double>(
                          0,
                          (previousValue, element) =>
                              previousValue + (element.amount),
                        ) ==
                        (double.tryParse(expenseAmountController.text) ?? 0))
                ? submitExpense
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  BlocBuilder twoOptionSelector(AppLocalizations intl) {
    return BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
      buildWhen: (p, c) => p.users != c.users || p.isLoading != c.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: ColoredBox(
              color: Colors.transparent,
              child: SpinKitFadingCircle(color: AppThemes.primary3Color),
            ),
          );
        }

        final members = state.users; // giả sử trong state có field này
        usersInEvent = members;

        if (splitType == SplitTypeEnum.equal) {
          userDebts = calculateUserDebts(
            members,
            double.tryParse(expenseAmountController.text) ?? 0,
          );
        }

        return TwoOptionSelector(
          label: intl.expenseSplitType,
          leftLabel: intl.expenseSplitEquallyLabel,
          leftIcon: 'lib/assets/icons/balance.png',
          rightLabel: intl.expenseSplitCustomLabel,
          rightIcon: 'lib/assets/icons/unbalance.png',
          onSelectionChanged: (value) async {
            double totalEntered = double.parse(expenseAmountController.text);
            if (totalEntered.isNaN || totalEntered <= 0) {
              return;
            }

            if (value == 2) {
              splitType = SplitTypeEnum.custom;
              // Trang chia bill
              final result = await context.pushNamed(
                AppRouteNames.customSplit,
                extra: {
                  'id': _selectedEvent?.id,
                  'type': user_event.LoadType.eventParticipants,
                  'initialSelected': userDebts,
                  'initialUsers': members,
                  'initialType': splitType,
                  'onChanged': (List<UserDebt> value) {
                    setState(() {
                      userDebts = value;
                    });
                  },
                  'amount': double.parse(expenseAmountController.text),
                },
              );

              if (result is List<UserDebt>) {
                setState(() {
                  userDebts = result;
                });
              }
            } else {
              splitType = SplitTypeEnum.equal;
              // Chia đều
              setState(() {
                splitType = SplitTypeEnum.equal;
                userDebts = calculateUserDebts(
                  members,
                  double.tryParse(expenseAmountController.text) ?? 0,
                );
              });
            }
          },
          selectedIndex: splitType == SplitTypeEnum.equal ? 1 : 2,
        );
      },
    );
  }

  List<UserDebt> calculateUserDebts(
    List<UserModel> members,
    double totalAmount,
  ) {
    return members.map((m) {
      if (totalAmount <= 0 || members.isEmpty) {
        return UserDebt(userId: m.id ?? '', amount: 0);
      }
      final balance = totalAmount / members.length;
      return UserDebt(userId: m.id ?? '', amount: balance);
    }).toList();
  }
}
