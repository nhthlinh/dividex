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

  const CustomFormWrapper({
    super.key,
    required this.fields,
    required this.builder,
    this.formKey,
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
    super.dispose();
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
