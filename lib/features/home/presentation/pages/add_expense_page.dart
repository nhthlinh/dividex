import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/home/presentation/widgets/add_button_widget.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final int expenseId;

  const AddExpensePage({super.key, required this.expenseId});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final ValueNotifier<String?> _selectedUnit = ValueNotifier('VND');
  final ValueNotifier<String?> _selectedCategory = ValueNotifier('Food');
  final ValueNotifier<String?> _selectedEvent = ValueNotifier('Birthday');
  final ValueNotifier<String?> _selectedPayer = ValueNotifier('John Doe');
  final ValueNotifier<String?> _selectedReminder = ValueNotifier(
    '1 day before',
  );

  final List<String> _units = ['VND', 'USD', 'EUR'];
  final List<String> _categories = ['Food', 'Transport', 'Entertainment'];
  final List<String> _events = ['Birthday', 'Wedding', 'Conference'];
  final List<String> _payers = ['John Doe', 'Jane Smith', 'Alice Johnson'];
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
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
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
                  child: expenseForm(intl),
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
                  validator: (value) => CustomValidator().validateAmount(value, intl),
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
          ValueListenableBuilder<String?>(
            valueListenable: _selectedCategory,
            builder: (context, value, _) {
              return CustomDropdownWidget(
                label: intl.expenseCategoryLabel,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                value: value,
                onChanged: (newValue) => _selectedCategory.value = newValue,
              );
            },
          ), 
          const SizedBox(height: 16),
          ValueListenableBuilder<String?>(
            valueListenable: _selectedEvent,
            builder: (context, value, _) {
              return CustomDropdownWidget(
                label: intl.expenseEventLabel,
                items: _events.map((event) {
                  return DropdownMenuItem<String>(
                    value: event,
                    child: Text(event),
                  );
                }).toList(),
                value: value,
                onChanged: (newValue) => _selectedEvent.value = newValue,
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<String?>(
            valueListenable: _selectedPayer,
            builder: (context, value, _) {
              return CustomDropdownWidget(
                label: intl.expensePayerLabel,
                items: _payers.map((payer) {
                  return DropdownMenuItem<String>(
                    value: payer,
                    child: Text(payer),
                  );
                }).toList(),
                value: value,
                onChanged: (newValue) => _selectedPayer.value = newValue,
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
          CustomTextButton(
            buttonText: intl.addExpenseImageLabel,
            onPressed: () {
              // Handle image upload
            },
          ),
          
          const SizedBox(height: 20),

          CustomButton(
            buttonText: intl.add,
            onPressed: () {
              // Handle add expense
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
