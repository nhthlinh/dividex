import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/category_bloc.dart'
    as category_event;
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/home/presentation/widgets/group_dropdown_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/image_picker_widget.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final int expenseId;

  const AddExpensePage({super.key, required this.expenseId});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final ValueNotifier<String?> _selectedUnit = ValueNotifier(null);
  final ValueNotifier<String?> _selectedCategory = ValueNotifier(null);
  final ValueNotifier<EventModel?> _selectedEvent = ValueNotifier(null);
  ValueNotifier<UserModel?> _selectedPayer = ValueNotifier(null);
  final ValueNotifier<String?> _selectedReminder = ValueNotifier(
    '1 day before',
  );
  List<String?> imagePaths = [];

  final List<String> _units = getAllCurrencies().map((e) => e.name).toList();
  List<String> _categories = [];
  List<GroupModel> _groups = [];
  List<UserModel> _payers = [];
  final List<String> _reminders = [
    '1 day before',
    '1 hour before',
    'No reminder',
  ];

  @override
  void initState() {
    super.initState();
    // TODO: Load existing expense data if editing
    // Load Unit
    // Load Category
    // Load Event
    // Load Payer
    // Load Reminder
  }

  @override
  void dispose() {
    expenseNameController.dispose();
    expenseAmountController.dispose();
    noteController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void submitExpense() {
    if (formKey.currentState?.validate() ?? false) {
      print('Expense submitted');
      print('Name: ${expenseNameController.text}');
      print('Amount: ${expenseAmountController.text}');
      print('Note: ${noteController.text}');
      print('Date: ${dateController.text}');

      print(_selectedCategory.value);
      print(_selectedUnit.value);
      print(_selectedEvent.value);
      print(_selectedPayer.value);
      print(_selectedReminder.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(
      context,
    )!; // Lấy đối tượng AppLocalizations

    return Scaffold(
      appBar: AppBar(
        title: Text(
          intl.addExpense,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(painter: WavePainter()),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<category_event.LoadedCategoriesBloc>(
                        create: (context) =>
                            category_event.LoadedCategoriesBloc()..add(
                              category_event.InitialEvent(
                                key: '',
                                page: 1,
                                pageSize: 5,
                              ),
                            ),
                      ),
                      BlocProvider<group_event.LoadedGroupsBloc>(
                        create: (context) =>
                            group_event.LoadedGroupsBloc()..add(
                              group_event.InitialEvent(
                                HiveService.getUser().id ?? '',
                              ),
                            ),
                      ),
                      BlocProvider<LoadedUsersBloc>(
                        create: (context) => LoadedUsersBloc(),
                      ),
                    ],
                    child: expenseForm(intl),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form expenseForm(AppLocalizations intl) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextInput(
            label: intl.expenseNameLabel,
            hintText: intl.expenseNameHint,
            controller: expenseNameController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.person, color: Colors.grey),
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7, // 70%
                child: CustomTextInput(
                  label: intl.expenseAmountLabel,
                  hintText: intl.expenseAmountHint,
                  controller: expenseAmountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Colors.grey,
                  ),
                  validator: (value) =>
                      CustomValidator().validateAmount(value, intl),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3, // 30%
                child: ValueListenableBuilder<String?>(
                  valueListenable: _selectedUnit,
                  builder: (context, value, _) {
                    return CustomDropdownWidget(
                      isSmall: true,
                      label: intl.expenseUnitLabel,
                      items: _units.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      value: value,
                      onChanged: (newValue) => _selectedUnit.value = newValue,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<
            category_event.LoadedCategoriesBloc,
            category_event.LoadedCategoriesState
          >(
            buildWhen: (p, c) =>
                p.categories != c.categories || p.isLoading != c.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state.categories.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<category_event.LoadedCategoriesBloc>().add(
                          category_event.RefreshCategoriesEvent(
                            key: '',
                            page: 1,
                            pageSize: 5,
                          ),
                        );
                      },
                      child: Center(child: Text('Empty')),
                    );
                  },
                );
              }

              _categories = state.categories;

              return ValueListenableBuilder<String?>(
                valueListenable: _selectedCategory,
                builder: (context, value, _) {
                  return Autocomplete<String>(
                    initialValue: TextEditingValue(text: value ?? ''),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _categories;
                      }
                      return _categories.where(
                        (category) => category.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      );
                    },
                    onSelected: (selected) {
                      _selectedCategory.value = selected;
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onEditingComplete) {
                          return CustomTextInput(
                            controller: controller,
                            label: intl.expenseCategoryLabel,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                          );
                        },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),

          BlocBuilder<group_event.LoadedGroupsBloc, LoadedGroupsState>(
            buildWhen: (p, c) =>
                p.groups != c.groups || p.isLoading != c.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state.groups.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<group_event.LoadedGroupsBloc>().add(
                          group_event.RefreshGroupsEvent(
                            HiveService.getUser().id ?? '',
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: Center(child: Text('Empty')),
                        ),
                      ),
                    );
                  },
                );
              }

              _groups = state.groups;

              return GroupDropdownWidget(
                initialValue: _selectedEvent.value,
                groups: _groups,
                onChanged: (event) {
                  setState(() {
                    _selectedEvent.value = event;
                    context.read<LoadedUsersBloc>().add(
                      InitialEvent(
                        event?.id,
                        LoadUsersAction.getEventParticipants,
                      ),
                    );
                  });
                },
              );
            },
          ),

          const SizedBox(height: 16),
          BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
            buildWhen: (p, c) =>
                p.users != c.users || p.isLoading != c.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return Text(
                  intl.expensePayerLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }

              if (state.users.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<LoadedUsersBloc>().add(
                          RefreshUsersEvent(
                            _selectedEvent.value?.id,
                            LoadUsersAction.getEventParticipants,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: Center(child: Text('Chose event first')),
                        ),
                      ),
                    );
                  },
                );
              }
              if (!state.isLoading && state.users.isNotEmpty) {
                // Cập nhật danh sách payer
                _payers = state.users;
              }
              return ValueListenableBuilder<UserModel?>(
                valueListenable: _selectedPayer,
                builder: (context, value, _) {
                  return CustomDropdownWidget<UserModel>(
                    label: intl.expensePayerLabel,
                    items: _payers.map((payer) {
                      return DropdownMenuItem<UserModel>(
                        value: payer,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  payer.avatar ?? '',
                                ),
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                payer.fullName ?? '',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    value: value,
                    onChanged: (newValue) => _selectedPayer.value = newValue,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                buttonText: intl.expenseSplitEquallyLabel,
                onPressed: () {},
                isBig: false,
              ),
              const SizedBox(width: 8),
              CustomButton(
                buttonText: intl.expenseSplitCustomLabel,
                onPressed: () {},
                isBig: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            intl.addConfigLabel,
            style: Theme.of(navigatorKey.currentContext!).textTheme.titleSmall
                ?.copyWith(
                  color: Theme.of(navigatorKey.currentContext!).primaryColor,
                ),
          ),
          const SizedBox(height: 10),
          CustomTextInput(
            label: intl.expenseNoteLabel,
            hintText: intl.expenseNoteLabel,
            controller: noteController,
            prefixIcon: const Icon(Icons.note, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.expenseDateLabel, // Label cho trường ngày sinh
            hintText: '13/05/2025',
            controller: dateController,
            isReadOnly: true, // Không cho phép gõ trực tiếp
            onTap: () => _selectDate(
              navigatorKey.currentContext!,
            ), // Mở DatePicker khi tap
            suffixIcon: const Icon(Icons.calendar_today), // Icon lịch
            inputFormatters: [DateInputFormatter()],
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<String?>(
            valueListenable: _selectedReminder,
            builder: (context, value, _) {
              return CustomDropdownWidget(
                label: intl.expenseReminderLabel,
                items: _reminders.map((remind) {
                  return DropdownMenuItem<String>(
                    value: remind,
                    child: Text(remind),
                  );
                }).toList(),
                value: value,
                onChanged: (newValue) => _selectedReminder.value = newValue,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            intl.addExpenseImageLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Center(
            child: ImagePickerField(
              isAvatar: false,
              multiple: true,
              onChanged: (paths) {
                setState(() {
                  imagePaths = paths;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          CustomButton(
            buttonText: intl.add,
            onPressed: () {
              submitExpense();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
