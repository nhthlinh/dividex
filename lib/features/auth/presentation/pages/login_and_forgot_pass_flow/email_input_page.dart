// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
// import 'package:Dividex/shared/utils/validation_input.dart';
// import 'package:Dividex/shared/widgets/custom_button.dart';
// import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
// import 'package:Dividex/shared/widgets/message_widget.dart';
// import 'package:Dividex/shared/widgets/wave_painter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class EmailInputPage extends StatefulWidget {
//   const EmailInputPage({super.key});

//   @override
//   State<EmailInputPage> createState() => _EmailInputPageState();
// }

// class _EmailInputPageState extends State<EmailInputPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();

//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitEmail() async {
//     if (_formKey.currentState!.validate()) {
//       String email = emailController.text.trim();

//       context.read<AuthBloc>().add(AuthEmailRequested(email: email));
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
//         backgroundColor: theme.scaffoldBackgroundColor, // Match background
//         elevation: 0, // No shadow for a cleaner look
//         leading: BackButton(
//           color:
//               theme.appBarTheme.iconTheme?.color ??
//               theme.colorScheme.onSurface, // Consistent back button color
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

//           SafeArea(
//             child: BlocConsumer<AuthBloc, AuthState>(
//               // Use BlocConsumer to handle both listener and builder
//               listener: (context, state) {
//                 if (state is AuthEmailSent) {
//                   // Dữ liệu hợp lệ, chuyển sang trang OTP
//                   showCustomToast(
//                     // Optional: Show success message
//                     intl.otpSentSuccess,
//                     type: ToastType.success,
//                   );
//                   context.pushNamed(
//                     AppRouteNames.otp,
//                     extra: {'nextRoute': AppRouteNames.resetPass},
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 return Center(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24.0,
//                         vertical: 16.0,
//                       ), // Adjusted vertical padding
//                       child: emailForm(context, intl, theme, state),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Form emailForm(
//     BuildContext context,
//     AppLocalizations intl,
//     ThemeData theme,
//     AuthState state,
//   ) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Added top spacing
//           const SizedBox(height: 24),
//           // Forgot password image
//           Image.asset(
//             'lib/assets/svgs/Forgot-password.png', // Path to your image file
//             height: MediaQuery.of(context).size.height * 0.3,
//             width: MediaQuery.of(context).size.width * 0.6,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 32), // Spacing after image
//           // Email
//           Text(
//             intl.emailInput, // "Enter your email" or similar
//             style: theme.textTheme.headlineSmall?.copyWith(
//               // Use a more prominent style for the title
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             intl.emailInputDescription, // Add a descriptive text like "We will send a verification code to your email."
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSurface,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),

//           //Email Input
//           CustomTextInput(
//             hintText: intl.emailLabel, // "Enter your email"
//             controller: emailController,
//             keyboardType: TextInputType.emailAddress,
//             prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
//             validator: (value) {
//               return CustomValidator().validateEmail(value, intl);
//             },
//           ),
//           const SizedBox(height: 32), // More spacing before button
//           //Next Button
//           // Show CircularProgressIndicator when loading
//           state is AuthLoading
//               ? const CircularProgressIndicator()
//               : CustomButton(buttonText: intl.next, onPressed: _submitEmail),
//           const SizedBox(height: 24), // Add bottom padding
//         ],
//       ),
//     );
//   }
// }
