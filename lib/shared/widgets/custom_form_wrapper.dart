import 'package:flutter/material.dart';

class FormFieldConfig {
  final TextEditingController controller;
  final bool isRequired;

  FormFieldConfig({
    required this.controller,
    this.isRequired = false,
  });
}

class CustomFormWrapper extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final Widget Function(bool isValid) builder; // callback: truyền trạng thái hợp lệ
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
      field.controller.addListener(_validate);
    }
    _validate();
  }

  @override
  void dispose() {
    for (var field in widget.fields) {
      field.controller.removeListener(_validate);
    }
    super.dispose();
  }

  void _validate() {
    final allRequiredFilled = widget.fields.every((f) {
      if (!f.isRequired) return true;
      return f.controller.text.trim().isNotEmpty;
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
