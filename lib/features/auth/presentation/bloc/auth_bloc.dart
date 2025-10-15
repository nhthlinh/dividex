import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/auth/domain/usecase.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/token_local_model.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    //Done
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthEmailRequested>(_onAuthEmailRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthChangePasswordRequested>(_onAuthChangePasswordRequested);

    on<AuthOtpSubmitted>(_onAuthOtpSubmitted);
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

      await HiveService.saveUser(
        UserLocalModel(
          id: authResponse.user.id ?? '',
          email: authResponse.user.email ?? '',
          fullName: authResponse.user.fullName ?? '',
          avatarUrl: authResponse.user.avatar,
          password: event.password,
          phoneNumber: authResponse.user.phoneNumber ?? '',
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

      await HiveService.saveUser(
        UserLocalModel(
          id: authResponse.user.id ?? '',
          email: authResponse.user.email ?? '',
          fullName: authResponse.user.fullName ?? '',
          avatarUrl: authResponse.user.avatar,
          password: event.password,
          phoneNumber: authResponse.user.phoneNumber ?? '',
        ),
      );

      // Gửi FCM token sau khi đăng nhập thành công
      //await sendFcmTokenToBackend(true);

      emit(const AuthAuthenticated());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      emit(AuthUnauthenticated());

      if (e.toString().contains(MessageCode.emailOrPasswordIncorrect)) {
        showCustomToast(intl.emailOrPasswordIncorrect, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Logic đăng xuất
    emit(AuthLoading());
    try {
      final logoutUseCase = await getIt.getAsync<LogoutUseCase>();
      await logoutUseCase.call();

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

      if (token?.accessToken != null && token?.refreshToken != null) {
        emit(const AuthAuthenticated());
        // // Gửi FCM token sau khi mở app
        // await sendFcmTokenToBackend(true);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      emit(AuthUnauthenticated());
      showCustomToast(intl.refreshFail, type: ToastType.error);
    }
  }

  Future<void> _onAuthEmailRequested(
    AuthEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final emailUseCase = await getIt.getAsync<EmailUseCase>();
      await emailUseCase.requestEmail(event.email);

      emit(AuthEmailSent(email: event.email));
      HiveService.saveUser(
        UserLocalModel(id: '', email: event.email, fullName: '', avatarUrl: null),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());

      if (e.toString().contains(MessageCode.userNotFound)) {
        showCustomToast(intl.userNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future<void> _onAuthOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final emailUseCase = await getIt.getAsync<EmailUseCase>();
      final token = await emailUseCase.checkEmailExists(event.email, event.otp);

      emit(AuthEmailChecked(email: event.email, token: token, isValid: true));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());
      if (e.toString().contains(MessageCode.invalidOrExpiredOtp)) {
        showCustomToast(intl.invalidOrExpiredOtp, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final resetPasswordUseCase = await getIt.getAsync<ResetPasswordUseCase>();
      await resetPasswordUseCase.resetPassword(event.newPassword, event.token);
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
      emit(AuthUnauthenticated());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthUnauthenticated());
      if (e.toString().contains(MessageCode.invalidOrExpiredOtp)) {
        showCustomToast(intl.invalidOrExpiredOtp, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future<void> _onAuthChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final changePasswordUseCase = await getIt
          .getAsync<ResetPasswordUseCase>();
      await changePasswordUseCase.changePassword(
        event.newPassword,
        event.oldPassword,
      );
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);

      emit(AuthAuthenticated());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      emit(AuthAuthenticated());

      if (e.toString().contains(MessageCode.passwordIncorrect)) {
        showCustomToast(intl.passwordIncorrect, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }
}
