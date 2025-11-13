import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OTPInputPage extends StatefulWidget {
  final String nextRoute;

  const OTPInputPage({super.key, required this.nextRoute});

  static OTPInputPage fromState(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;

    return OTPInputPage(
      nextRoute: extra?['nextRoute'] ?? AppRouteNames.resetPass, // fallback
    );
  }

  @override
  State<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends State<OTPInputPage> {
  final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes

  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmailAndStartTimer();
  }

  Future<void> _loadUserEmailAndStartTimer() async {
    final userData = HiveService.getUser();
    setState(() {
      _userEmail = userData.email;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _remainingSeconds = 30; // Reset to 5 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _resendOtp() async {
    final intl = AppLocalizations.of(context)!; // Get the localization instance
    if (_userEmail == null || _userEmail!.isEmpty) {
      showCustomToast(intl.otpInputError1, type: ToastType.error);
      return;
    }

    context.read<AuthBloc>().add(AuthEmailRequested(email: _userEmail!));
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> submitOTP(AppLocalizations intl) async {
    if (_formKey.currentState!.validate()) {
      String otp = otpController.text.trim();

      context.read<AuthBloc>().add(AuthOtpSubmitted(otp: otp, email: _userEmail!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final intl = AppLocalizations.of(context)!; // Get the localization instance

    return SimpleLayout(
      title: intl.forgotPassword,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthEmailSent) {
            // Hiển thị thông báo đã gửi OTP
            showCustomToast(intl.otpSentSuccess, type: ToastType.success);
            _startTimer(); // Bắt đầu lại bộ đếm thời gian khi gửi lại Email
          } else if (state is AuthEmailChecked) {
            context.pushNamed(
              widget.nextRoute,
              pathParameters: {'token': state.token},
            );
          }
        },
        builder: (context, state) {
          return otpForm(intl, theme);
        },
      ),
    );
  }

  CustomFormWrapper otpForm(AppLocalizations intl, ThemeData theme) {
    return CustomFormWrapper(
      formKey: _formKey,
      fields: [FormFieldConfig(controller: otpController, isRequired: true)],
      builder: (isValid) {
        return ContentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextInputWidget(
                    isRequired: true,
                    label: intl.otpLabel,
                    size: TextInputSize.medium,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    isReadOnly: false,
                    validator: (value) {
                      return CustomValidator().validateOtp(value, intl);
                    },
                  ),
                  CustomButton(
                    size: ButtonSize.medium,
                    text: intl.otpInputPageResend,
                    onPressed: _remainingSeconds > 0 ? null : _resendOtp,
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  text: intl.emailVerificationCodeSent,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppThemes.borderColor,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: _userEmail ?? '', // Phần email người dùng
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppThemes.primary3Color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left, // Căn giữa toàn bộ Text.rich
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: intl.codeExpirationNotice,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppThemes.borderColor,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: _remainingSeconds > 0
                          ? _formatDuration(
                              _remainingSeconds,
                            ) // Hiển thị thời gian đếm ngược
                          : intl.otpInputPageResend, // "Gửi lại"
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppThemes.primary3Color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left, // Căn giữa toàn bộ Text.rich
              ),

              const SizedBox(height: 12),
              CustomButton(
                text: intl.settingChangePass,
                onPressed: isValid
                    ? () {
                        submitOTP(intl);
                      }
                    : null,
              ),

              const SizedBox(height: 16), // Add bottom padding
              CustomTextButton(
                label: intl.otpInputPageChangeEmail, // "Thay đổi email"
                onPressed: () {
                  context.pop(); // Quay lại trang trước (trang nhập email)
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
