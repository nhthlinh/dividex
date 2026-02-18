import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmailInputPage extends StatefulWidget {
  const EmailInputPage({super.key});

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final clearFormTrigger = ValueNotifier(false);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();

      context.read<AuthBloc>().add(AuthEmailRequested(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final intl = AppLocalizations.of(context)!; // Get the localization instance

    return SimpleLayout(
      onRefresh: () async {
        clearFormTrigger.value = !clearFormTrigger.value; // Trigger form reset
        return Future.value();
      },
      title: intl.forgotPassword,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthEmailSent) {
            // Dữ liệu hợp lệ, chuyển sang trang OTP
            showCustomToast(
              // Optional: Show success message
              intl.otpSentSuccess,
              type: ToastType.success,
            );
            context.pushNamed(
              AppRouteNames.otp,
              extra: {'nextRoute': AppRouteNames.resetPass},
            );
          }
        },
        builder: (context, state) {
          return emailForm(context, intl, theme, state);
        },
      ),
    );
  }

  CustomFormWrapper emailForm(
    BuildContext context,
    AppLocalizations intl,
    ThemeData theme,
    AuthState state,
  ) {
    return CustomFormWrapper(
      clearTrigger: clearFormTrigger,
      formKey: _formKey,
      fields: [FormFieldConfig(controller: emailController, isRequired: true)],
      builder: (isValid) {
        return ContentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextInputWidget(
                isRequired: true,
                label: intl.emailLabel,
                hintText: 'example@gmail.com',
                size: TextInputSize.large,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                isReadOnly: false,
                validator: (value) {
                  return CustomValidator().validateEmail(value, intl);
                },
              ),
              Text(
                intl.emailVerificationMessage,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),

              CustomButton(
                text: intl.send,
                onPressed: isValid
                    ? () {
                        _submitEmail();
                        clearFormTrigger.value =
                            !clearFormTrigger.value; // Trigger form reset
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
