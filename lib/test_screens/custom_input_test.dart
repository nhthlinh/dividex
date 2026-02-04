import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';

class InputTestScreen extends StatefulWidget {
  const InputTestScreen({super.key});

  @override
  State<InputTestScreen> createState() => _InputTestScreenState();
}

class _InputTestScreenState extends State<InputTestScreen> {
  final _formKey = GlobalKey<FormState>(); // <-- Form key

  // Controllers
  final TextEditingController textController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController multiLineController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    textController.dispose();
    numberController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateController.dispose();
    multiLineController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Test Screen")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // <-- gán Form key
          child: Column(
            children: [
              CustomTextInputWidget(
                size: TextInputSize.large,
                label: "Text Input",
                controller: textController,
                keyboardType: TextInputType.text,
                isReadOnly: false,
                hintText: "Enter text",
              ),
              const SizedBox(height: 16),
              CustomTextInputWidget(
                size: TextInputSize.large,
                label: "Number Input",
                controller: numberController,
                keyboardType: TextInputType.number,
                isReadOnly: false,
                hintText: "Enter number",
                isRequired: true,
                validator: (value) => CustomValidator().validateNumberInput(value, AppLocalizations.of(context)!),
              ),
              const SizedBox(height: 16),
              CustomTextInputWidget(
                size: TextInputSize.medium,
                label: "Password",
                controller: passwordController,
                keyboardType: TextInputType.text,
                isReadOnly: false,
                obscureText: obscurePassword,
                validator: (value) =>
                    CustomValidator().validatePassword(value, AppLocalizations.of(context)!),
                hintText: "Enter password",
                suffixIcon: IconButton(
                  icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
                isRequired: true,
              ),
              const SizedBox(height: 16),
              CustomTextInputWidget(
                size: TextInputSize.large,
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                isReadOnly: false,
                hintText: "Enter email",
                validator: (value) =>
                    CustomValidator().validateEmail(value, AppLocalizations.of(context)!),
              ),
              const SizedBox(height: 16),
              CustomTextInputWidget(
                size: TextInputSize.medium,
                label: "Phone",
                controller: phoneController,
                keyboardType: TextInputType.phone,
                isReadOnly: false,
                hintText: "Enter phone",
              ),
              const SizedBox(height: 16),
              CustomTextInputWidget(
                size: TextInputSize.medium,
                label: "Date",
                controller: dateController,
                keyboardType: TextInputType.datetime,
                isReadOnly: true,
                hintText: "Pick a date",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextInputWidget(
                size: TextInputSize.large,
                label: "Multi-line Text",
                controller: multiLineController,
                keyboardType: TextInputType.multiline,
                isReadOnly: false,
                hintText: "Enter multiple lines",
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Validate form
                  // if (_formKey.currentState!.validate()) {
                  //   print("All inputs are valid!");
                  //   print("Text: ${textController.text}");
                  //   print("Number: ${numberController.text}");
                  //   print("Password: ${passwordController.text}");
                  //   print("Email: ${emailController.text}");
                  //   print("Phone: ${phoneController.text}");
                  //   print("Date: ${dateController.text}");
                  //   print("Multi-line: ${multiLineController.text}");
                  // } else {
                  //   print("Some inputs are invalid!");
                  // }
                },
                child: const Text("Submit / Validate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
