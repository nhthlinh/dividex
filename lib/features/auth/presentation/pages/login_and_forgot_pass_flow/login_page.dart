import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/auth/data/source/firebase_login.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
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
    loadAccount();
  }

  Future<void> loadAccount() async {
    // final account = await HiveService.getAccount();
    // if (account != null) {
    //   emailController.text = account;
    // }
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

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Ensure background matches theme
      body: Stack(
        children: [
          Positioned(
            bottom: 0, // Hoặc top: 0 nếu muốn ở đầu
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200, // Chiều cao gợn sóng
              child: CustomPaint(painter: WavePainter()),
            ),
          ),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(AppRouteNames.home);
                });
              }

              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Increased top padding for better visual balance
                        const SizedBox(height: 30),

                        Image.asset(
                          'lib/assets/images/Logo_no_background.png',
                          width: 180, // Reduced logo size
                          height: 180, // Reduced logo size
                        ),
                        const SizedBox(height: 23), // Spacing after logo

                        loginForm(intl, context, state, theme),
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

  Form loginForm(
    AppLocalizations intl,
    BuildContext context,
    AuthState state,
    ThemeData theme,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //Email
          CustomTextInput(
            label: 'Email', // Add label for email
            hintText: intl.emailLabel,
            controller: emailController,
            keyboardType: TextInputType.emailAddress, // Suggest email keyboard
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Colors.grey,
            ), // Add email icon
            validator: (value) {
              return validateEmail(value, intl);
            },
          ),
          const SizedBox(height: 20), // Slightly more spacing
          //Password
          CustomTextInput(
            label: intl.passwordLabel, // Add label for password
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
              return passwordValidator(value, intl);
            },
          ),
          const SizedBox(height: 10),

          // forgot password
          Align(
            // Use Align to push to right
            alignment: Alignment.centerRight,
            child: TestButtonWithDes(
              label: intl.forgotPassword,
              onPressed: () {
                context.pushNamed(AppRouteNames.requestEmail);
              },
            ),
          ),

          const SizedBox(height: 32), // More spacing before login button
          //Login Button
          CustomButton(
            buttonText: intl.login,
            onPressed: () {
              if (state is AuthLoading) return;
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<AuthBloc>(context).add(
                  AuthLoginRequested(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 32), // More spacing
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
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
            ],
          ),

          const SizedBox(height: 16), // Spacing after "Or"
          //Login with google Button
          CustomButton(
            buttonText: intl.loginWithGoogle,
            onPressed: () async {
              if (state is AuthLoading) return;
              // final userCredential = await signInWithGoogle();
              // if (userCredential != null) {
              //   context.goNamed(AppRouteNames.home);
              // } else {
              //   showCustomToast(
              //     intl.setUp1PageError4,
              //     type: ToastType.error,
              //   );
              // }
            },
          ),

          const SizedBox(height: 10), // Spacing after "Or"
          // Don't have account? Register
          TestButtonWithDes(
            description: intl.loginPageToRegister, // "Don't have account?"
            label: intl.register, // "Register"
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(AppRouteNames.register);
              });
            },
          ),
          const SizedBox(height: 16), // Add bottom padding
        ],
      ),
    );
  }
}
