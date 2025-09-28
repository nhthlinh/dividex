import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  bool _obscurePassword = true; // State for password visibility

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (_formKey.currentState!.validate()) {
      // Lấy dữ liệu hiện có hoặc tạo mới
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();
      String number = numberController.text.trim();

      // Gửi sự kiện đăng ký
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          userData: UserModel(
            email: email,
            fullName: name,
            phoneNumber: number,
            avatar: null,
          ),
          password: password,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final intl = AppLocalizations.of(context)!; // Get the localization instance

    return Layout(
      title: intl.register,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.goNamed(AppRouteNames.home);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.welcomeNewMessage,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      intl.createNewAccountPrompt,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Spacing before logo

              Image.asset(
                'lib/assets/images/signin_image.png',
                width: 220,
                height: 170,
              ),
              const SizedBox(height: 8), // Spacing after logo

              registerForm(intl, state, theme, context),
            ],
          );
        },
      ),
    );
  }

  CustomFormWrapper registerForm(
    AppLocalizations intl,
    AuthState state,
    ThemeData theme,
    BuildContext context,
  ) {
    return CustomFormWrapper(
      formKey: _formKey,
      fields: [
        FormFieldConfig(controller: nameController, isRequired: true),
        FormFieldConfig(controller: emailController, isRequired: true),
        FormFieldConfig(controller: numberController, isRequired: true),
        FormFieldConfig(controller: passwordController, isRequired: true),
      ],
      builder: (isValid) {
        return Column(
          children: [
            //Name
            CustomTextInputWidget(
              label: intl.nameLabel,
              isRequired: true,
              hintText: intl.nameLabel,
              controller: nameController,
              keyboardType:
                  TextInputType.name, // Suggest name keyboard// Add name icon
              validator: (value) {
                return CustomValidator().validateName(value, intl);
              },
              size: TextInputSize.large,
              isReadOnly: false,
            ),
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
            //Phone Number
            CustomTextInputWidget(
              label: intl.phoneLabel,
              isRequired: true,
              hintText: intl.phoneLabel,
              controller: numberController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                return CustomValidator().validatePhoneNumber(value, intl);
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
            const SizedBox(height: 12),

            // Button chỉ enable khi isValid == true
            CustomButton(
              text: intl.register,
              onPressed: (!isValid || state is AuthLoading)
                  ? null
                  : () => _submitRegister(),
            ),

            const SizedBox(height: 24),

          // Already have an account? Login
          CustomTextButton(
            description: intl.registerPageToLogin, // "Already have an account?"
            label: intl.login, // "Login"
            onPressed: () {
              context.pushNamed(AppRouteNames.login);
            },
          ),

          const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
