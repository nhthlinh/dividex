// import 'dart:async';

// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
// import 'package:Dividex/shared/services/local/hive_service.dart';
// import 'package:Dividex/shared/widgets/custom_button.dart';
// import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
// import 'package:Dividex/shared/widgets/text_button.dart';
// import 'package:Dividex/shared/widgets/wave_painter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class OTPInputPage extends StatefulWidget {
//   final String nextRoute;

//   const OTPInputPage({super.key, required this.nextRoute});

//   static OTPInputPage fromState(GoRouterState state) {
//     final extra = state.extra as Map<String, dynamic>?;

//     return OTPInputPage(
//       nextRoute: extra?['nextRoute'] ?? AppRouteNames.resetPass, // fallback
//     );
//   }

//   @override
//   State<OTPInputPage> createState() => _OTPInputPageState();
// }

// class _OTPInputPageState extends State<OTPInputPage> {
//   Timer? _timer;
//   int _remainingSeconds = 300; // 5 minutes
//   String _otpCode = '';

//   // Store the email from Hive service, needed for resend OTP
//   String? _userEmail;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserEmailAndStartTimer();
//   }

//   Future<void> _loadUserEmailAndStartTimer() async {
//     final userData = HiveService.getUser();
//     setState(() {
//       _userEmail = userData.email;
//     });
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _startTimer() {
//     _timer?.cancel(); // Cancel any existing timer
//     _remainingSeconds = 30; // Reset to 5 minutes
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           _remainingSeconds--;
//         });
//       }
//     });
//   }

//   Future<void> _resendOtp() async {
//     final intl = AppLocalizations.of(context)!; // Get the localization instance
//     if (_userEmail == null || _userEmail!.isEmpty) {
//       showCustomToast(intl.otpInputError1, type: ToastType.error);
//       return;
//     }

//     context.read<AuthBloc>().add(AuthEmailRequested(email: _userEmail!));
//   }

//   String _formatDuration(int totalSeconds) {
//     final minutes = totalSeconds ~/ 60;
//     final seconds = totalSeconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
//           BlocConsumer<AuthBloc, AuthState>(
//             listener: (context, state) {
//               if (state is AuthEmailSent) {
//                 // Hiển thị thông báo đã gửi OTP
//                 showCustomToast(intl.otpSentSuccess, type: ToastType.success);
//                 _startTimer(); // Bắt đầu lại bộ đếm thời gian khi gửi lại Email
//               } 
//             },
//             builder: (context, state) {
//               return SafeArea(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24.0,
//                       vertical: 16.0,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment:
//                           CrossAxisAlignment.center, // Căn giữa nội dung
//                       children: [
//                         const SizedBox(height: 24), // Khoảng cách từ trên xuống
//                         // Logo (sử dụng intl cho alt text nếu có, hoặc chỉ là hình ảnh tĩnh)
//                         Image.asset(
//                           'lib/assets/images/Logo_no_background.png',
//                           width: 150, // Giảm kích thước logo
//                           height: 150,
//                         ),
//                         const SizedBox(height: 32), // Khoảng cách sau logo
//                         // Tiêu đề: "Xác minh Email của bạn"
//                         Text(
//                           intl.otpInputPageTitle,
//                           style: theme.textTheme.headlineMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: theme.colorScheme.onSurface,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 12),

//                         // Mô tả: "Chúng tôi đã gửi mã xác minh đến email của bạn"
//                         // Bằng đoạn code này:
//                         Text.rich(
//                           TextSpan(
//                             text: intl.otpInputPageDescription, // Phần mô tả
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: Colors.grey,
//                             ),
//                             children: <TextSpan>[
//                               // Thêm khoảng trắng hoặc ký tự phân cách nếu muốn
//                               const TextSpan(
//                                 text: ' ',
//                               ), // Thêm một khoảng trắng nhỏ giữa mô tả và email
//                               TextSpan(
//                                 text: _userEmail ?? '', // Phần email người dùng
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   color: theme.colorScheme.onSurface,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               // Bạn có thể thêm các TextSpan khác nếu muốn
//                             ],
//                           ),
//                           textAlign:
//                               TextAlign.center, // Căn giữa toàn bộ Text.rich
//                         ),

//                         const SizedBox(height: 32),

//                         // Phần Gửi lại mail
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             // "Không nhận được mã?"
//                             Text(
//                               intl.otpInputPageDidntReceiveCode,
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 color: Colors.grey, // Màu xám cho văn bản này
//                               ),
//                             ),
//                             // Nút "Gửi lại" hoặc bộ đếm thời gian
//                             CustomTextButton(
//                               // Sử dụng CustomTextButton
//                               buttonText: _remainingSeconds > 0
//                                   ? _formatDuration(
//                                       _remainingSeconds,
//                                     ) // Hiển thị thời gian đếm ngược
//                                   : intl.otpInputPageResend, // "Gửi lại"
//                               onPressed:
//                                   _remainingSeconds == 0 &&
//                                       state is! AuthLoading
//                                   ? _resendOtp // Chỉ kích hoạt khi hết giờ và không đang loading
//                                   : null, // Vô hiệu hóa nút
//                               textColor:
//                                   _remainingSeconds == 0 &&
//                                       state is! AuthLoading
//                                   ? theme
//                                         .colorScheme
//                                         .primary // Màu chính khi có thể gửi lại
//                                   : Colors.grey, // Màu xám khi vô hiệu hóa
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 32),
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
// }
