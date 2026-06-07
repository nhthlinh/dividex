import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/models/payer_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/bloc/load_user_bloc.dart';
import 'package:Dividex/shared/bloc/load_user_event.dart' as user_event;
import 'package:Dividex/shared/bloc/load_user_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/features/image/presentation/widgets/image_picker_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/two_option_selector_widget.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final LoadedUsersBloc? loadedUsersBloc;
  final bool showCreateOptionDialogOnInit;
  final EventModel? initialSelectedEvent;
  final List<PayerModel>? initialSelectedPayer;
  final bool bypassValidationForTesting;

  const AddExpensePage({
    super.key,
    this.loadedUsersBloc,
    this.showCreateOptionDialogOnInit = true,
    this.initialSelectedEvent,
    this.initialSelectedPayer,
    this.bypassValidationForTesting = false,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  static const Key manualOptionButtonKey = Key(
    'expense_create_manual_option_button',
  );
  static const Key scanningOptionButtonKey = Key(
    'expense_create_scanning_option_button',
  );
  static const Key nameInputKey = Key('expense_create_name_input');
  static const Key amountInputKey = Key('expense_create_amount_input');
  static const Key eventInputKey = Key('expense_create_event_input');
  static const Key payerInputKey = Key('expense_create_payer_input');
  static const Key dateInputKey = Key('expense_create_date_input');
  static const Key reminderInputKey = Key('expense_create_reminder_input');
  static const Key splitEqualOptionKey = Key(
    'expense_create_split_equal_option',
  );
  static const Key splitCustomOptionKey = Key(
    'expense_create_split_custom_option',
  );
  static const Key submitButtonKey = Key('expense_create_submit_button');

  final formKey = GlobalKey<FormState>();
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final ValueNotifier<CurrencyEnum?> _selectedCurrency = ValueNotifier(null);
  final ValueNotifier<CategoryModel?> _selectedCategory = ValueNotifier(null);
  final TextEditingController selectedEventTextEditingController =
      TextEditingController();
  EventModel? _selectedEvent;

  List<PayerModel> _selectedPayer = [];
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  List<Uint8List?> images = [];
  SplitTypeEnum splitType = SplitTypeEnum.equal;
  List<UserDebt> userDebts = [];
  List<UserModel> users = [];
  List<UserModel> usersInEvent = [];

  List<ImageExpenseItemModel> items = [];
  bool showMoreInfomation = false;

  final List<CurrencyEnum> _units = getAllCurrencies().map((e) => e).toList();

  final clearFormTrigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _selectedEvent = widget.initialSelectedEvent;
    if (_selectedEvent != null) {
      selectedEventTextEditingController.text = _selectedEvent!.name ?? '----';
    }

    _selectedPayer = widget.initialSelectedPayer != null
        ? widget.initialSelectedPayer!
        : [];

    if (widget.showCreateOptionDialogOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOptionDialog();
      });
    }
  }

  void _showOptionDialog() {
    final intl = AppLocalizations.of(context)!;
    showCustomDialog(
      context: context,
      content: Column(
        children: [
          Text(
            intl.createExpenseBy,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: intl.manually,
                    buttonKey: manualOptionButtonKey,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    size: ButtonSize.medium,
                    type: ButtonType.secondary,
                    customColor: AppThemes.errorColor,
                  ),
                  CustomButton(
                    text: intl.scanning,
                    buttonKey: scanningOptionButtonKey,
                    onPressed: () async {
                      Navigator.pop(context);
                      final result = await context.pushNamed(
                        AppRouteNames.scanExpense,
                      );
                      if (result != null && mounted) {
                        _handleScanResult(result);
                      } else {
                        showCustomToast(
                          intl.cantReadImage,
                          type: ToastType.error,
                        );
                      }
                    },
                    size: ButtonSize.medium,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleScanResult(dynamic result) {
    final ImageExpenseModel imageInfo = result['imageInfo'];
    final Uint8List bytes = result['bytes'];

    // 1️⃣ Lưu ảnh
    setState(() {
      images = [bytes];
    });

    // 2️⃣ Đổ dữ liệu OCR vào form
    expenseNameController.text = imageInfo.name;
    expenseAmountController.text = imageInfo.totalAmount.toString();

    _selectedCurrency.value = getAllCurrencies().firstWhere(
      (c) => c.code == (imageInfo.currency.toUpperCase()),
      orElse: () => getAllCurrencies().firstWhere((c) => c.code == 'VND'),
    );

    _selectedCategory.value = CategoryModel.categories.firstWhere(
      (c) => c.key == (imageInfo.category),
      orElse: () =>
          CategoryModel.categories.firstWhere((c) => c.key == 'miscellaneous'),
    );
    noteController.text = imageInfo.note ?? '';
    dateController.text = DateFormat(
      "h:mm a - dd/MM/yyyy",
    ).format(imageInfo.expenseDate ?? DateTime.now());
    reminderController.text = DateFormat(
      "dd/MM/yyyy",
    ).format((imageInfo.expenseDate ?? DateTime.now()).add(Duration(days: 3)));

    items = imageInfo.items;
  }

  @override
  void dispose() {
    expenseNameController.dispose();
    expenseAmountController.dispose();
    selectedEventTextEditingController.dispose();
    noteController.dispose();
    dateController.dispose();
    reminderController.dispose();
    clearFormTrigger.dispose();
    super.dispose();
  }

  String? validateExpense() {
    // final intl = AppLocalizations.of(context)!;

    try {
      final selectedEvent = _selectedEvent ?? widget.initialSelectedEvent;

      final selectedPayers = _selectedPayer;

      /// Event
      if (selectedEvent == null) {
        return "selectedEvent == null";
      }

      /// Payer
      if (selectedPayers.isEmpty) {
        return "selectedPayers is empty";
      }

      /// Amount
      final totalAmount = double.tryParse(expenseAmountController.text);

      if (totalAmount == null) {
        return "Amount parse failed";
      }

      if (totalAmount <= 0) {
        return "Amount <= 0";
      }

      /// Date
      DateTime parsedExpenseDate;

      try {
        parsedExpenseDate = DateFormat(
          "h:mm a - dd/MM/yyyy",
        ).parse(dateController.text);
      } catch (e) {
        return "Expense date parse failed: ${dateController.text}";
      }

      debugPrint(parsedExpenseDate.toString());

      /// Reminder
      if (reminderController.text.isNotEmpty) {
        try {
          DateFormat("dd/MM/yyyy").parse(reminderController.text);
        } catch (e) {
          return "Reminder parse failed: ${reminderController.text}";
        }
      }

      /// User debt
      if (userDebts.isEmpty) {
        return "userDebts empty";
      }

      /// Equal split
      if (splitType == SplitTypeEnum.equal) {
        final calculated = calculateUserDebts(usersInEvent, totalAmount);

        if (calculated.isEmpty) {
          return "calculateUserDebts returns empty";
        }

        userDebts = calculated;
      }

      /// Custom split
      if (splitType == SplitTypeEnum.custom) {
        final totalDebt = userDebts.fold<double>(0, (sum, e) => sum + e.amount);

        if ((totalDebt - totalAmount).abs() > 0.01) {
          return """
Split not match
Debt:$totalDebt
Amount:$totalAmount
""";
        }
      }

      /// Payer amount
      final payerTotal = selectedPayers.fold<double>(
        0,
        (sum, e) => sum + (e.amount),
      );

      if ((payerTotal - totalAmount).abs() > 0.01) {
        return """
Payer amount mismatch
Payer:$payerTotal
Expense:$totalAmount
""";
      }

      return null;
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());

      return e.toString();
    }
  }

  void submitExpense() {
    if (!(widget.bypassValidationForTesting ||
        (formKey.currentState?.validate() ?? false))) {
      return;
    }

    final error = validateExpense();

    if (error != null) {
      debugPrint("VALIDATION FAILED");
      debugPrint(error);

      showCustomToast(error, type: ToastType.error);

      return;
    }

    debugPrint("VALIDATION SUCCESS");

    final selectedEvent = _selectedEvent ?? widget.initialSelectedEvent;

    final formattedDate = DateFormat(
      "yyyy-MM-dd HH:mm",
    ).format(DateFormat("h:mm a - dd/MM/yyyy").parse(dateController.text));

    final formattedReminder = reminderController.text.isNotEmpty
        ? DateFormat(
            "yyyy-MM-dd",
          ).format(DateFormat("dd/MM/yyyy").parse(reminderController.text))
        : '';

    context.read<ExpenseBloc>().add(
      CreateExpenseEvent(
        expenseNameController.text,
        double.parse(expenseAmountController.text),
        _selectedCurrency.value?.code ?? CurrencyEnum.vnd.code,
        _selectedCategory.value?.key,
        selectedEvent!.id!,
        _selectedPayer.map((p) => {p.user.id ?? '': p.amount}).toList(),
        noteController.text,
        formattedDate,
        formattedReminder,
        splitType,
        userDebts,
        images.whereType<Uint8List>().toList(),
      ),
    );

    debugPrint("EVENT SENT");
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(
      context,
    )!; // Lấy đối tượng AppLocalizations

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () async => {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            clearFormTrigger.value =
                !clearFormTrigger.value; // Trigger form reset
            _showOptionDialog();
          }),
        },
        title: intl.addExpense,
        child: expenseForm(intl),
      ),
    );
  }

  CustomFormWrapper expenseForm(AppLocalizations intl) {
    return CustomFormWrapper(
      clearTrigger: clearFormTrigger,
      formKey: formKey,
      fields: [
        FormFieldConfig(controller: expenseNameController, isRequired: true),
        FormFieldConfig(controller: expenseAmountController, isRequired: true),
        FormFieldConfig(selectedValue: _selectedCurrency, isRequired: true),
        // FormFieldConfig(selectedValue: _selectedCategory, isRequired: true),
        FormFieldConfig(
          controller: selectedEventTextEditingController,
          isRequired: true,
        ),
        FormFieldConfig(controller: dateController, isRequired: true),
      ],
      builder: (isValid, isSubmitting, setSubmitting) => Column(
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
            textFieldKey: nameInputKey,
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
                    textFieldKey: amountInputKey,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        CustomValidator().validateAmount(value, intl),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3, // 30%
                  child: ValueListenableBuilder<CurrencyEnum?>(
                    valueListenable: _selectedCurrency,
                    builder: (context, value, _) {
                      return CustomDropdownWidget<CurrencyEnum?>(
                        label: intl.expenseCurrencyLabel,
                        value: _selectedCurrency.value,
                        options: _units,
                        displayString: (b) => b?.code ?? '',
                        buildOption: (b, selected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  b?.code ?? '',
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
                                    b?.description ?? '',
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

          CustomTextInputWidget(
            size: TextInputSize.large,
            controller: selectedEventTextEditingController,
            textFieldKey: eventInputKey,
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
            CustomTextButton(
              key: payerInputKey,
              isRequired: true,
              isLeftAligned: true,
              description: intl.expensePayerLabel,
              label: intl.addMembers,
              onPressed: () async {
                final result = await context.pushNamed<List<PayerModel>>(
                  AppRouteNames.choosePayer,
                  extra: {
                    'id': _selectedEvent?.id,
                    'type': user_event.LoadType.eventParticipants,
                    'initialSelectedPayers': _selectedPayer,
                    'amount':
                        double.tryParse(expenseAmountController.text) ?? 0,
                    'isMultiSelect': true,
                    'isCanChooseMyself': true,
                  },
                );

                if (result != null) {
                  setState(() {
                    _selectedPayer = result;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            UserGrid(
              users: _selectedPayer.isNotEmpty
                  ? _selectedPayer.map((p) => p.user).toList()
                  : [],
              onTap: (user) {
                setState(() {
                  _selectedPayer.removeWhere((p) => p.user.id == user.id);
                });
              },
            ),

            // CustomTextInputWidget(
            //   size: TextInputSize.large,
            //   controller: selectedPayerTextEditingController,
            //   textFieldKey: payerInputKey,
            //   keyboardType: TextInputType.text,
            //   isReadOnly: true,
            //   isRequired: true,
            //   label: intl.expensePayerLabel,
            //   suffixIcon: const Icon(Icons.keyboard_arrow_down),
            //   onTap: () {
            //     context.pushNamed(
            //       AppRouteNames.chooseMember,
            //       extra: {
            //         'id': _selectedEvent?.id,
            //         'type': user_event.LoadType.eventParticipants,
            //         'initialSelected': _selectedPayer != null
            //             ? [_selectedPayer!]
            //             : <UserModel>[],
            //         'onChanged': (List<UserModel> user) {
            //           setState(() {
            //             _selectedPayer = user.first;
            //             selectedPayerTextEditingController.text =
            //                 user.first.fullName ?? '----';
            //           });
            //         },
            //         'isMultiSelect': true,
            //         'isCanChooseMyself': true,
            //       },
            //     );
            //   },
            // ),
            // UserGrid(
            //   users: _selectedPayer != null ? [_selectedPayer!] : [],
            //   onTap: (user) {
            //     setState(() {
            //       _selectedPayer = null;
            //       selectedPayerTextEditingController.text = '';
            //     });
            //   },
            // ),
          ],
          const SizedBox(height: 8),

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
                    textFieldKey: dateInputKey,
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
                    textFieldKey: reminderInputKey,
                    size: TextInputSize.medium,
                    isRequired: true,
                    validator: null,
                  ),
                ),
              ],
            ),
          ),

          if (_selectedEvent != null &&
              expenseAmountController.text.isNotEmpty) ...[
            const SizedBox(height: 16),

            (widget.loadedUsersBloc != null)
                ? BlocProvider<LoadedUsersBloc>.value(
                    value: widget.loadedUsersBloc!,
                    child: twoOptionSelector(intl),
                  )
                : BlocProvider(
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

          Row(
            children: [
              Text(
                intl.showMoreInfo,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                  letterSpacing: 0,
                  height: 16 / 12,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showMoreInfomation = !showMoreInfomation;
                  });
                },
                icon: showMoreInfomation
                    ? const Icon(Icons.keyboard_arrow_up)
                    : const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
          if (showMoreInfomation) ...[
            // Category
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
            // Note
            CustomTextInputWidget(
              size: TextInputSize.large,
              isReadOnly: false,
              label: intl.expenseNoteLabel,
              controller: noteController,
              keyboardType: TextInputType.text,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            // Image
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
                  initialImage: images.isNotEmpty ? images.first : null,
                  type: PickerType.gallery,
                  onFilesPicked: (imageBytesList) {
                    setState(() {
                      images = imageBytesList;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          CustomButton(
            text: intl.add,
            buttonKey: submitButtonKey,
            onPressed:
                (!isValid ||
                    isSubmitting ||
                    userDebts.isEmpty ||
                    userDebts.fold<double>(
                          0,
                          (previousValue, element) =>
                              previousValue + (element.amount),
                        ) !=
                        (double.tryParse(expenseAmountController.text) ?? 0))
                ? null
                : () async {
                    setSubmitting(true);
                    submitExpense();
                    setSubmitting(false);
                  },
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
          leftOptionKey: splitEqualOptionKey,
          rightOptionKey: splitCustomOptionKey,
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
                  'items': items,
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
