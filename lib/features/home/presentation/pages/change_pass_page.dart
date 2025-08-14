// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class ChangePassPage extends StatefulWidget {
//   const ChangePassPage({super.key});

//   @override
//   State<ChangePassPage> createState() => _ChangePassPageState();
// }

// class _ChangePassPageState extends State<ChangePassPage> {
//   final _formKey = GlobalKey<FormState>();
//   final oldPasswordController = TextEditingController();
//   final newPasswordController = TextEditingController();
//   final newPasswordConfirmController = TextEditingController();


//   bool _obscureOldPassword = true; // State for old password visibility
//   bool _obscureNewPassword = true; // State for new password visibility
//   bool _obscureConfirmPassword = true; // State for confirm password visibility

//   @override
//   void dispose() {
//     oldPasswordController.dispose();
//     newPasswordController.dispose();
//     newPasswordConfirmController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitPass() async {
//     if (_formKey.currentState!.validate()) {
//       final oldPassword = oldPasswordController.text.trim();
//       final newPassword = newPasswordController.text.trim();

//       // Ensure email is not null before dispatching
//       final email = await HiveService.getAccount() ?? '';
//       if (email.isEmpty) {
//         showCustomToast(
//           AppLocalizations.of(context)!.resetPassErrorNoEmail,
//           type: ToastType.error,
//         );
//         return;
//       }

//       // Dispatch ResetPasswordRequested event
//       context.read<AuthBloc>().add(AuthChangePasswordRequested(email: email, newPassword: newPassword, oldPassword: oldPassword),);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final intl = AppLocalizations.of(context)!;
//     final theme = Theme.of(context); // Get current theme

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor, // Consistent background color
//       appBar: AppBar(
//         backgroundColor: theme.scaffoldBackgroundColor,
//         elevation: 0,
//         leading: BackButton(
//           color: theme.appBarTheme.iconTheme?.color ?? theme.colorScheme.onSurface,
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>( // Use BlocConsumer
//         listener: (context, state) {
//           if (state is AuthChangePasswordSuccess) {
//             showCustomToast(
//               intl.resetPassSuccess, 
//               type: ToastType.success, // Use success type for toast
//             );
//           } else if (state is AuthError) {
//             showCustomToast(
//               intl.resetPassError,
//               type: ToastType.error, // Use error type for toast
//             );
//           }
//         },
//         builder: (context, state) {
//           return SafeArea(
//             child: SingleChildScrollView( // For responsiveness
//               padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center, // Center content
//                 children: [
//                   const SizedBox(height: 24),

//                   // Title: Reset Password
//                   Text(
//                     intl.resetPassPageTitle, // "Đặt lại mật khẩu"
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),

//                   // Description
//                   Text(
//                     intl.resetPassPageDescription, // "Vui lòng nhập mật khẩu mới của bạn bên dưới."
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: Colors.grey, // Lighter color for description
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 32),

//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         //Old password Input
//                         CustomTextInput(
//                           label: intl.resetPassOldPass, // "Mật khẩu cũ"
//                           hintText: intl.resetPassOldPass,
//                           controller: oldPasswordController,
//                           obscureText: _obscureOldPassword,
//                           keyboardType: TextInputType.visiblePassword,
//                           maxLines: 1,
//                           prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscureOldPassword = !_obscureOldPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             return passwordValidator(value, intl); // Validate old password
//                           },
//                         ),
//                         const SizedBox(height: 20), // More spacing before button

//                         // New Password
//                         CustomTextInput(
//                           label: intl.password, // "Mật khẩu mới"
//                           hintText: intl.resetPassNewPassHint, // "Nhập mật khẩu mới"
//                           controller: newPasswordController,
//                           obscureText: _obscureNewPassword,
//                           maxLines: 1,
//                           prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscureNewPassword = !_obscureNewPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             return passwordValidator(value, intl); // Validate password
//                           },
//                         ),
//                         const SizedBox(height: 20), // Spacing between password fields

//                         // Confirm New Password
//                         CustomTextInput(
//                           label: intl.passwordAgain, // "Xác nhận mật khẩu mới"
//                           hintText: intl.resetPassConfirmPassHint, // "Xác nhận mật khẩu mới"
//                           controller: newPasswordConfirmController,
//                           obscureText: _obscureConfirmPassword,
//                           maxLines: 1,
//                           prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscureConfirmPassword = !_obscureConfirmPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             return confirmPasswordValidator(value, intl, newPasswordController);
//                           },
//                         ),
//                         const SizedBox(height: 32), // Spacing before button

//                         // Save Button
//                         state is AuthLoading
//                             ? CircularProgressIndicator(color: theme.colorScheme.primary)
//                             : CustomButton(
//                                 buttonText: intl.save,
//                                 onPressed: () {
//                                   if (state is! AuthLoading) {
//                                     _submitPass(); // Call submit function
//                                   }
//                                 }, 
//                               ),
//                         const SizedBox(height: 24), // Bottom padding
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }