import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPassPage extends StatefulWidget {
  final String token; // Required token for password reset
  const ResetPassPage({super.key, required this.token});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true; // State for password visibility
  bool _obscureConfirmPassword = true; // State for confirm password visibility

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitPass() async {
    if (_formKey.currentState!.validate()) {
      final password = passwordController.text.trim();

      // Dispatch ResetPasswordRequested event
      context.read<AuthBloc>().add(
        AuthResetPasswordRequested(
          newPassword: password,
          token: widget.token,
        ),
      );

      context.goNamed(AppRouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final intl = AppLocalizations.of(context)!; // Get the localization instance

    return SimpleLayout(
      title: intl.settingChangePass,
      child: BlocBuilder<AuthBloc, AuthState>(
        // Use BlocConsumer
        builder: (context, state) {
          return resetPassForm(intl, state, theme);
        },
      ),
    );
  }

  CustomFormWrapper resetPassForm(
    AppLocalizations intl,
    AuthState state,
    ThemeData theme,
  ) {
    return CustomFormWrapper(
      formKey: _formKey,
      fields: [
        FormFieldConfig(controller: passwordController, isRequired: true),
        FormFieldConfig(
          controller: confirmPasswordController,
          isRequired: true,
        ),
      ],
      builder: (isValid) {
        return ContentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Password
              CustomTextInputWidget(
                label: intl.passwordLabel,
                isRequired: true,
                hintText: intl.passwordLabel,
                controller: passwordController,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1, // Add lock icon
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) {
                  return CustomValidator().validatePassword(value, intl);
                },
                size: TextInputSize.large,
                isReadOnly: false,
              ),
              //Confirm Password
              CustomTextInputWidget(
                label: intl.confirmPasswordLabel,
                isRequired: true,
                hintText: intl.confirmPasswordLabel,
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1, // Add lock icon
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  return CustomValidator().validatePassword(value, intl);
                },
                size: TextInputSize.large,
                isReadOnly: false,
              ),
              const SizedBox(height: 16),

              CustomButton(
                text: intl.settingChangePass,
                onPressed: isValid
                    ? () {
                        _submitPass();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
