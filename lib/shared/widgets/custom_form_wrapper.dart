import 'package:flutter/material.dart';

class FormFieldConfig<T> {
  final TextEditingController? controller;
  final ValueNotifier<T>? selectedValue;
  final bool isRequired;

  FormFieldConfig({
    this.controller,
    this.selectedValue,
    this.isRequired = false,
  });
}

class CustomFormWrapper extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final Widget Function(bool isValid)
  builder; // callback: truyền trạng thái hợp lệ
  final GlobalKey<FormState>? formKey;
  final ValueNotifier<bool> clearTrigger;

  const CustomFormWrapper({
    super.key,
    required this.fields,
    required this.builder,
    this.formKey,
    required this.clearTrigger,
  });

  @override
  State<CustomFormWrapper> createState() => _CustomFormWrapperState();
}

class _CustomFormWrapperState extends State<CustomFormWrapper> {
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      if (field.controller != null) {
        field.controller!.addListener(_validate);
      } else if (field.selectedValue != null) {
        field.selectedValue!.addListener(_validate);
      }
    }
    _validate();
    widget.clearTrigger.addListener(_clearForm);
  }

  @override
  void dispose() {
    for (var field in widget.fields) {
      if (field.controller != null) {
        field.controller!.removeListener(_validate);
      } else if (field.selectedValue != null) {
        field.selectedValue!.removeListener(_validate);
      }
    }
    widget.clearTrigger.removeListener(_clearForm);
    super.dispose();
  }

  void _clearForm() {
    for (var field in widget.fields) {
      field.controller?.clear();

      if (field.selectedValue != null) {
        field.selectedValue!.value = null;
      }
    }

    widget.formKey?.currentState?.reset();
    _validate();
  }

  void _validate() {
    final allRequiredFilled = widget.fields.every((f) {
      if (!f.isRequired) return true;
      if (f.controller != null) {
        return f.controller!.text.trim().isNotEmpty;
      } else if (f.selectedValue != null) {
        final value = f.selectedValue!.value;
        if (value == null) return false;

        // Nếu value là String thì check trim
        if (value is String) {
          return value.trim().isNotEmpty;
        }

        // Nếu value là số, enum, object... thì chỉ cần != null
        return true;
      }
      return false;
    });

    if (_isValid != allRequiredFilled) {
      setState(() {
        _isValid = allRequiredFilled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey ?? GlobalKey<FormState>(),
      child: widget.builder(_isValid),
    );
  }
}
