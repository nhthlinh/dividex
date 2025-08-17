import 'dart:math';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/home/presentation/widgets/add_button_widget.dart';
import 'package:Dividex/features/home/presentation/widgets/member_selector_widget.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final int eventId;

  const AddEventPage({super.key, required this.eventId});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventStartDateController = TextEditingController();
  final TextEditingController eventEndDateController = TextEditingController();

  final ValueNotifier<String?> _selectedGroup = ValueNotifier('Birthday');
  
  // Members of event
  List<Member> selectedMembers = [
    Member(id: '1', name: 'John Doe', avatarUrl: 'https://example.com/john.jpg'),
  ];

  final List<String> _groups = ['Birthday', 'Wedding', 'Conference'];

  @override
  void initState() {
    super.initState();
    // TODO: Load existing event data if editing
    // Load Group
    // Load Members
    // Load Start Date
    // Load End Date
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventStartDateController.dispose();
    eventEndDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
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
          intl.addEvent,
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
                child: eventForm(intl),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form eventForm(AppLocalizations intl) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextInput(
            label: intl.eventNameLabel,
            hintText: intl.eventNameHint,
            controller: eventNameController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.event, color: Colors.grey),
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.eventDescriptionLabel,
            hintText: intl.eventDescriptionHint,
            controller: eventDescriptionController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.details_outlined, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<String?>(
            valueListenable: _selectedGroup,
            builder: (context, value, _) {
              return CustomDropdownWidget(
                label: intl.eventGroupLabel,
                items: _groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                value: value,
                onChanged: (newValue) => _selectedGroup.value = newValue,
              );
            },
          ), 
          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.eventStartDateLabel, 
            hintText: '13/05/2025',
            controller: eventStartDateController,
            isReadOnly: true, // Không cho phép gõ trực tiếp
            onTap: () => _selectDate(
              navigatorKey.currentContext!,
              eventStartDateController,
            ), // Mở DatePicker khi tap
            suffixIcon: const Icon(Icons.calendar_today), // Icon lịch
            inputFormatters: [DateInputFormatter()],
            validator: (value) {
              return CustomValidator().validateDateForEvent(intl, eventStartDateController, eventEndDateController);
            },
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.eventEndDateLabel,
            hintText: '13/05/2025',
            controller: eventEndDateController,
            isReadOnly: true, // Không cho phép gõ trực tiếp
            onTap: () => _selectDate(
              navigatorKey.currentContext!,
              eventEndDateController,
            ), // Mở DatePicker khi tap
            suffixIcon: const Icon(Icons.calendar_today), // Icon lịch
            inputFormatters: [DateInputFormatter()],
            validator: (value) {
              return CustomValidator().validateDateForEvent(intl, eventStartDateController, eventEndDateController);
            },
          ),
          const SizedBox(height: 16),
          
          MemberSelector(
            initialSelectedMembers: selectedMembers,
            onSelectedMembersChanged: (selected) {
              setState(() {
                selectedMembers = selected;
              });
            },
          ),

          const SizedBox(height: 30),
          CustomButton(
            buttonText: intl.add,
            onPressed: () {
              // Handle add expense
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
