import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/auth/domain/usecase.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:Dividex/shared/services/notification/fcm.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    //Done
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);

    //Not done
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthOtpRequested>(_onAuthOtpRequested);
    on<AuthOtpCheckRequested>(_onAuthOtpChecked);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthChangePasswordRequested>(_onAuthChangePasswordRequested);
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final registerUseCase = await getIt.getAsync<RegisterUseCase>();
      final authResponse = await registerUseCase.call(
        event.userData,
        event.password,
      );
      await HiveService.saveToken(
        TokenLocalModel(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        ),
      );

      // Gửi FCM token sau khi đăng ký thành công
      //await sendFcmTokenToBackend(true);

      emit(const AuthAuthenticated());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      emit(AuthUnauthenticated());

      if (e.toString().contains(MessageCode.emailAlreadyExists)) {
        showCustomToast(intl.emailAlreadyExists, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.phoneNumberAlreadyExists)) {
        showCustomToast(intl.phoneNumberAlreadyExists, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final loginUseCase = await getIt.getAsync<LoginUseCase>();
      final authResponse = await loginUseCase.call(event.email, event.password);

      await HiveService.saveToken(
        TokenLocalModel(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        ),
      );

      // Gửi FCM token sau khi đăng nhập thành công
      //await sendFcmTokenToBackend(true);

      emit(const AuthAuthenticated());
    } catch (e, stackTrace) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      print('Error during login: $e\n$stackTrace');

      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Logic đăng xuất
    emit(AuthLoading());
    try {
      // Xóa token, dữ liệu người dùng, v.v.
      emit(AuthUnauthenticated());
      // await sendFcmTokenToBackend(false);
      await HiveService.clearToken(); // Xóa token khỏi local storage
      await HiveService.clearUser(); // Xóa dữ liệu người dùng khỏi local storage
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Kiểm tra trạng thái xác thực khi app khởi động
    emit(AuthLoading());
    try {
      final token = HiveService.getToken();

      if (token.accessToken != null) {
        emit(const AuthAuthenticated());
        // // Gửi FCM token sau khi mở app
        // await sendFcmTokenToBackend(true);

        // final settings = HiveService.getSettings();
        // await sendLanguageToBackend(settings.localeCode);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onAuthOtpRequested(
    AuthOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // final otpUseCase = await getIt.getAsync<OtpUseCase>();
      //await otpUseCase.requestOtp(event.email);

      emit(AuthOtpSent(email: event.email));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onAuthOtpChecked(
    AuthOtpCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthOtpChecked(email: event.email, otp: event.otp));

      // final otpUseCase = await getIt.getAsync<OtpUseCase>();
      // await otpUseCase.checkOtp(event.email, event.otp);
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);

      emit(AuthOtpSuccess(email: event.email));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // final resetPasswordUseCase = await getIt.getAsync<ResetPasswordUseCase>();
      // await resetPasswordUseCase.resetPassword(event.email, event.newPassword);
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onAuthChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // final changePasswordUseCase = await getIt.getAsync<ResetPasswordUseCase>();
      // await changePasswordUseCase.changePassword(event.email, event.newPassword, event.oldPassword);
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}
