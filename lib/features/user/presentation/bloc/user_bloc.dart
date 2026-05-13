import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/features/user/domain/usecase.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<GetMeEvent>(_onGetMe);
    on<UpdateMeEvent>(_onUpdateMe);
    on<CreatePinEvent>(_onCreatePin);
    on<UpdatePinEvent>(_onUpdatePin);
    on<ReviewEvent>(_onReview);
  }

  Future _onGetMe(GetMeEvent event, Emitter<UserState> emit) async {
    try {
      final useCase = await getIt.getAsync<UserUseCase>();
      final user = await useCase.getMe();

      emit(UserState(user: user));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onUpdateMe(UpdateMeEvent event, Emitter<UserState> emit) async {
    try {
      final useCase = await getIt.getAsync<UserUseCase>();
      await useCase.updateMe(event.name, event.currency);

      final userId = HiveService.getUser().id;

      if (event.avatar != null && event.deletedAvatarUid != null) {
        updateImage(
          userId ?? '',
          [event.avatar!],
          AttachmentType.user,
          [event.deletedAvatarUid!],
        );
      } else if (event.avatar == null && event.deletedAvatarUid != null) {
        deleteImage([event.deletedAvatarUid!]);
      } else if (event.avatar != null && event.deletedAvatarUid == null) {
        uploadImage(userId ?? '', [event.avatar!], AttachmentType.user);
      }

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onCreatePin(CreatePinEvent event, Emitter<UserState> emit) async {
    try {
      final useCase = await getIt.getAsync<UserUseCase>();
      await useCase.createPin(event.pin);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onUpdatePin(UpdatePinEvent event, Emitter<UserState> emit) async {
    try {
      final useCase = await getIt.getAsync<UserUseCase>();
      await useCase.updatePin(event.oldPin, event.newPin);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onReview(ReviewEvent event, Emitter<UserState> emit) async {
    try {
      final useCase = await getIt.getAsync<UserUseCase>();
      await useCase.reviewApp(event.stars);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}