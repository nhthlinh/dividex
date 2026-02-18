import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmController = TextEditingController();

  bool _obscureOldPassword = true; // State for old password visibility
  bool _obscureNewPassword = true; // State for new password visibility
  bool _obscureConfirmPassword = true; // State for confirm password visibility

  final clearFormTrigger = ValueNotifier(false);

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmController.dispose();
    clearFormTrigger.dispose();
    super.dispose();
  }

  Future<void> _submitPass() async {
    if (_formKey.currentState!.validate()) {
      final oldPassword = oldPasswordController.text.trim();
      final newPassword = newPasswordController.text.trim();

      // Dispatch ResetPasswordRequested event
      context.read<AuthBloc>().add(
        AuthChangePasswordRequested(
          newPassword: newPassword,
          oldPassword: oldPassword,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 3,
      child: SimpleLayout(
        onRefresh: () async {
          clearFormTrigger.value = !clearFormTrigger.value; // Trigger form reset
          return Future.value();
        },
        title: intl.settingChangePass,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomFormWrapper(
              clearTrigger: clearFormTrigger,
              formKey: _formKey,
              fields: [
                FormFieldConfig(
                  controller: oldPasswordController,
                  isRequired: true,
                ),
                FormFieldConfig(
                  controller: newPasswordController,
                  isRequired: true,
                ),
                FormFieldConfig(
                  controller: newPasswordConfirmController,
                  isRequired: true,
                ),
              ],
              builder: (isValid) => ContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Password
                    CustomTextInputWidget(
                      label: intl.passwordLabel,
                      isRequired: true,
                      hintText: intl.passwordLabel,
                      controller: oldPasswordController,
                      obscureText: _obscureOldPassword,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1, // Add lock icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureOldPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureOldPassword = !_obscureOldPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        return CustomValidator().validatePassword(value, intl);
                      },
                      size: TextInputSize.large,
                      isReadOnly: false,
                    ),
                    //New Password
                    CustomTextInputWidget(
                      label: intl.newPasswordLabel,
                      isRequired: true,
                      hintText: intl.newPasswordLabel,
                      controller: newPasswordController,
                      obscureText: _obscureNewPassword,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1, // Add lock icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        return CustomValidator().validatePassword(value, intl);
                      },
                      size: TextInputSize.large,
                      isReadOnly: false,
                    ),
                    //Confirm New Password
                    CustomTextInputWidget(
                      label: intl.confirmPasswordLabel,
                      isRequired: true,
                      hintText: intl.confirmPasswordLabel,
                      controller: newPasswordConfirmController,
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
                        return CustomValidator().validateConfirmPassword(
                          value,
                          intl,
                          newPasswordController,
                        );
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
                              clearFormTrigger.value =
                                  !clearFormTrigger.value; // Trigger form reset
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
