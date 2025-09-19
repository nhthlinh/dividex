import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true; // State to toggle password visibility

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final intl = AppLocalizations.of(context)!; // Get the localization instance

    return Layout(
      title: intl.login,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home page on successful authentication
            context.goNamed(AppRouteNames.home);
          } 
        },
        child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.welcomeBackMessage,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      intl.signInAccountPrompt,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Spacing before logo

              Image.asset(
                'lib/assets/images/login_image.png',
                width: 220,
                height: 170,
              ),
              const SizedBox(height: 8), // Spacing after logo

              loginForm(intl, context, theme),
            ],
          ),
      ),
    );
  }

  CustomFormWrapper loginForm(
    AppLocalizations intl,
    BuildContext context,
    ThemeData theme,
  ) {
    return CustomFormWrapper(
      fields: [
        FormFieldConfig(controller: emailController, isRequired: true),
        FormFieldConfig(controller: passwordController, isRequired: true),
      ],
      formKey: _formKey,
      builder: (isValid) {
        return Column(
          children: [
            //Email
            CustomTextInputWidget(
              label: intl.emailLabel,
              isRequired: true,
              hintText: intl.emailLabel,
              controller: emailController,
              keyboardType: TextInputType
                  .emailAddress, // Suggest email keyboard// Add email icon
              validator: (value) {
                return CustomValidator().validateEmail(value, intl);
              },
              size: TextInputSize.large,
              isReadOnly: false,
            ),
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
            
            const SizedBox(height: 12), // Spacing between password fields
            // forgot password
            Align(
              // Use Align to push to right
              alignment: Alignment.centerRight,
              child: CustomTextButton(
                label: intl.forgotPassword,
                onPressed: () {
                  context.pushNamed(AppRouteNames.requestEmail);
                },
              ),
            ),

            const SizedBox(height: 12), // More spacing before login button
            //Login Button
            CustomButton(
              text: intl.login,
              onPressed: (!isValid)
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed with login
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        // Trigger the login event in AuthBloc
                        context.read<AuthBloc>().add(
                          AuthLoginRequested(email: email, password: password),
                        );
                      }
                    },
            ),

            const SizedBox(height: 16),

            // Don't have account? Register
            CustomTextButton(
              description: intl.loginPageToRegister, // "Don't have account?"
              label: intl.register, // "Register"
              onPressed: () {
                context.pushNamed(AppRouteNames.register);
              },
            ),
            const SizedBox(height: 16), // Add bottom padding
          ],
        );
      },
    );
  }
}
