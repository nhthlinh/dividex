// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
// import 'package:Dividex/shared/services/local/hive_service.dart';
// import 'package:Dividex/shared/utils/validation_input.dart';
// import 'package:Dividex/shared/widgets/custom_button.dart';
// import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
// import 'package:Dividex/shared/widgets/message_widget.dart';
// import 'package:Dividex/shared/widgets/wave_painter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class ResetPassPage extends StatefulWidget {
//   final String token; // Required token for password reset
//   const ResetPassPage({super.key, required this.token});

//   @override
//   State<ResetPassPage> createState() => _ResetPassPageState();
// }

// class _ResetPassPageState extends State<ResetPassPage> {
//   final _formKey = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true; // State for password visibility
//   bool _obscureConfirmPassword = true; // State for confirm password visibility

//   @override
//   void dispose() {
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitPass() async {
//     final intl = AppLocalizations.of(context)!; // Get the localization instance
//     if (_formKey.currentState!.validate()) {
//       final password = passwordController.text.trim();
//       final userData = HiveService.getUser();

//       // Ensure email is not null before dispatching
//       if (userData.email!.isEmpty) {
//         showCustomToast(intl.otpInputError1, type: ToastType.error);
//         return;
//       }

//       // Dispatch ResetPasswordRequested event
//       context.read<AuthBloc>().add(
//         AuthResetPasswordRequested(
//           email: userData.email!,
//           newPassword: password,
//           token: widget.token,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context); // Get current theme
//     final intl = AppLocalizations.of(context)!; // Get the localization instance

//     return Scaffold(
//       backgroundColor:
//           theme.scaffoldBackgroundColor, // Consistent background color
//       appBar: AppBar(
//         backgroundColor: theme.scaffoldBackgroundColor,
//         elevation: 0,
//         leading: BackButton(
//           color:
//               theme.appBarTheme.iconTheme?.color ?? theme.colorScheme.onSurface,
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SizedBox(
//               height: 200,
//               width: double.infinity,
//               child: CustomPaint(painter: WavePainter()),
//             ),
//           ),
//           BlocBuilder<AuthBloc, AuthState>(
//             // Use BlocConsumer
//             builder: (context, state) {
//               return SafeArea(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     // For responsiveness
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24.0,
//                       vertical: 16.0,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment:
//                           CrossAxisAlignment.center, // Center content
//                       children: [
//                         const SizedBox(height: 24),

//                         //Optional: Add your Forgot Password image here for visual context
//                         Image.asset(
//                           'lib/assets/svgs/Forgot-password.png', // Ensure this path is correct
//                           height: MediaQuery.of(context).size.height * 0.2,
//                           width: MediaQuery.of(context).size.width * 0.5,
//                           fit: BoxFit.contain,
//                         ),
//                         const SizedBox(height: 32),

//                         // Title: Reset Password
//                         Text(
//                           intl.resetPassPageTitle, // "Đặt lại mật khẩu"
//                           style: theme.textTheme.headlineMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: theme.colorScheme.onSurface,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 12),

//                         // Description
//                         Text(
//                           intl.resetPassPageDescription, // "Vui lòng nhập mật khẩu mới của bạn bên dưới."
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: Colors.grey, // Lighter color for description
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 32),

//                         resetPassForm(intl, state, theme),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Form resetPassForm(AppLocalizations intl, AuthState state, ThemeData theme) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           // New Password
//           CustomTextInput(
//             label: intl.newPasswordLabel, // "Mật khẩu mới"
//             hintText: intl.resetPassNewPassHint, // "Nhập mật khẩu mới"
//             controller: passwordController,
//             obscureText: _obscurePassword,
//             maxLines: 1,
//             prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             ),
//             validator: (value) =>
//                 CustomValidator().validatePassword(value, intl), // Use validation function
//           ),
//           const SizedBox(height: 20), // Spacing between password fields
//           // Confirm New Password
//           CustomTextInput(
//             label: intl.confirmPasswordLabel, // "Xác nhận mật khẩu mới"
//             hintText: intl.resetPassConfirmPassHint, // "Xác nhận mật khẩu mới"
//             controller: confirmPasswordController,
//             obscureText: _obscureConfirmPassword,
//             maxLines: 1,
//             prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _obscureConfirmPassword
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 color: Colors.grey,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscureConfirmPassword = !_obscureConfirmPassword;
//                 });
//               },
//             ),
//             validator: (value) => CustomValidator().validateConfirmPassword(
//               value,
//               intl,
//               passwordController,
//             ), // Pass intl and passwordController
//           ),
//           const SizedBox(height: 32), // Spacing before button
//           // Save Button
//           state is AuthLoading
//               ? CircularProgressIndicator(color: theme.colorScheme.primary)
//               : CustomButton(
//                   buttonText: intl.save,
//                   onPressed: () {
//                     if (state is! AuthLoading) {
//                       _submitPass(); // Call submit function
//                     }
//                   },
//                 ),
//           const SizedBox(height: 24), // Bottom padding
//         ],
//       ),
//     );
//   }
// }
