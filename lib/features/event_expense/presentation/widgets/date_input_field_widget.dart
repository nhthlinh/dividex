import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final FormFieldValidator<String>? validator;
  final TextInputSize size;
  final bool isPickedHour;

  const DateInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isRequired = false,
    this.validator,
    required this.size,
    this.isPickedHour = false,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    if (widget.isPickedHour) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked == null) return;

      final DateTime combinedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        timePicked.hour,
        timePicked.minute,
      );

      setState(() {
        widget.controller.text = DateFormat('h:mm a - dd/MM/yyyy').format(combinedDateTime);
      });
      return;
    } else {
      setState(() {
        widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextInputWidget(
      isRequired: widget.isRequired,
      size: widget.size,
      keyboardType: TextInputType.datetime,
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      isReadOnly: true,
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () =>
            _selectDate(context),
      ), // Mở DatePicker khi tap
      validator: widget.validator,
    );
  }
}
