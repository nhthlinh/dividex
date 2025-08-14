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
  String? _selectedUnit;
  String? _selectedCategory;
  String? _selectedEvent;
  String? _selectedPayer;
  String? _selectedReminder;

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
    _selectedUnit = 'VND'; // Mặc định là VND
    _selectedCategory = 'Food'; // Mặc định là Food
    _selectedEvent = 'Birthday'; // Mặc định là Birthday
    _selectedPayer = 'John Doe'; // Mặc định là John Doe
    _selectedReminder = '1 day before'; // Mặc định là 1 day before
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
          Positioned(
            bottom: 0, // Hoặc top: 0 nếu muốn ở đầu
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200, // Chiều cao gợn sóng
              child: CustomPaint(painter: WavePainter()),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
              child: expenseForm(intl),
            ),
          ),
        ],
      ),
    );
  }

  Form expenseForm(AppLocalizations intl) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextInput(
            label: intl.expenseNameLabel,
            hintText: intl.expenseNameHint,
            controller: expenseNameController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.person, color: Colors.grey),
            validator: (value) {
              return validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextInput(
                label: intl.expenseAmountLabel,
                hintText: intl.expenseAmountHint,
                controller: expenseAmountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                validator: (value) {
                  return validateAmount(value, intl);
                },
                isFullWidth: false,
              ),
              const SizedBox(width: 8),
              CustomDropdownWidget(
                isSmall: true,
                label: intl.expenseUnitLabel,
                items: _units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                value: _selectedUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomDropdownWidget(
            label: intl.expenseCategoryLabel,
            items: _categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomDropdownWidget(
            label: intl.expenseEventLabel,
            items: _events.map((event) {
              return DropdownMenuItem<String>(value: event, child: Text(event));
            }).toList(),
            value: _selectedEvent,
            onChanged: (String? newValue) {
              setState(() {
                _selectedEvent = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomDropdownWidget(
            label: intl.expensePayerLabel,
            items: _payers.map((payer) {
              return DropdownMenuItem<String>(value: payer, child: Text(payer));
            }).toList(),
            value: _selectedPayer,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPayer = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
            style: Theme.of(navigatorKey.currentContext!).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
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
          CustomDropdownWidget(
            label: intl.expenseReminderLabel,
            value: _selectedReminder,
            onChanged: (String? newValue) {},
            items: _reminders.map((remind) {
              return DropdownMenuItem<String>(
                value: remind,
                child: Text(remind),
              );
            }).toList(),
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
