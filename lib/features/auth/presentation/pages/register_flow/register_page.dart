import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
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
  bool _obscureConfirmPassword = true; // State for confirm password visibility

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
            avatar: '',
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

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Ensure background matches theme
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(painter: WavePainter()),
            ),
          ),

          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.goNamed(AppRouteNames.home);
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ), // Added vertical padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Increased top padding for better visual balance
                        const SizedBox(height: 48),

                        Image.asset(
                          'lib/assets/images/Logo_no_background.png', // Use the new logo path
                          width: 180, // Reduced logo size
                          height: 180, // Reduced logo size
                        ),
                        const SizedBox(height: 48), // Spacing after logo

                        registerForm(intl, state, theme, context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Form registerForm(
    AppLocalizations intl,
    AuthState state,
    ThemeData theme,
    BuildContext context,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //Name
          CustomTextInput(
            label: 'Name', // Use label for better accessibility
            hintText: intl.nameLabel,
            controller: nameController,
            keyboardType: TextInputType.name, // Suggest name keyboard
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Colors.grey,
            ), // Add name icon
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 10), // Slightly more spacing
          //Phone Number
          CustomTextInput(
            label: intl.phoneLabel, // Use label for better accessibility
            hintText: intl.phoneLabel,
            controller: numberController,
            keyboardType: TextInputType.phone, // Suggest phone keyboard
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: Colors.grey,
            ), // Add phone icon
            validator: (value) {
              return CustomValidator().validatePhoneNumber(value, intl);
            },
          ),
          const SizedBox(height: 10), // Slightly more spacing

          //Email
          CustomTextInput(
            label: 'Email',
            hintText: intl.emailLabel,
            controller: emailController,
            keyboardType: TextInputType.emailAddress, // Suggest email keyboard
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Colors.grey,
            ), // Add email icon
            validator: (value) {
              return CustomValidator().validateEmail(value, intl);
            },
          ),
          const SizedBox(height: 10), // Slightly more spacing
          //Password
          CustomTextInput(
            label: intl.passwordLabel,
            hintText: intl.passwordInputDescription,
            controller: passwordController,
            obscureText: _obscurePassword,
            maxLines: 1,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Colors.grey,
            ), // Add lock icon
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
          ),
          const SizedBox(height: 10), // Spacing between password fields
          //Confirm Password
          CustomTextInput(
            label: intl.confirmPasswordLabel,
            hintText: intl.confirmPasswordInputDescription,
            controller: confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            maxLines: 1,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Colors.grey,
            ), // Add lock icon
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
            validator: (value) => CustomValidator().validateConfirmPassword(value, intl, passwordController),
          ),
          const SizedBox(height: 24), // More spacing before register button
          //Register Button

          // Show CircularProgressIndicator when loading
          state is AuthLoading
              ? const CircularProgressIndicator()
              : CustomButton(
                  buttonText: intl.register,
                  onPressed: state is AuthLoading
                      ? () {}
                      : () => _submitRegister(), // Disable button when loading
                ),
          const SizedBox(height: 24),
          //Or
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              const SizedBox(width: 8),
              Text(
                intl.or,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey, // Match divider color
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
            ],
          ),
          const SizedBox(height: 24), // Spacing after "Or"
          // Already have an account? Login
          TestButtonWithDes(
            description: intl.registerPageToLogin, // "Already have an account?"
            label: intl.login, // "Login"
            onPressed: () {
              context.goNamed(AppRouteNames.login);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
