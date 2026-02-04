import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/domain/usecase.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedUsersBloc extends Bloc<LoadUserEvent, LoadedUsersState> {
  LoadedUsersBloc() : super((const LoadedUsersState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future<PagingModel<List<UserModel>>> getData(
    LoadType type,
    String? id,
    String? searchQuery,
    int page,
  ) async {
    final useCase = await getIt.getAsync<UserUseCase>();
    final friendUseCase = await getIt.getAsync<FriendUseCase>();
    switch (type) {
      case LoadType.friends:
        return await useCase.getUserForCreateGroup(id ?? '', page, 5, searchQuery);
      case LoadType.groupMembers:
        return await useCase.getUserForCreateEvent(id ?? '', page, 5, searchQuery);
      case LoadType.eventParticipants:
        return await useCase.getUserForCreateExpense(
          id ?? '',
          page,
          5,
          searchQuery,
        );
      case LoadType.mutualFriends:
        return await friendUseCase.listMutualFriends(id ?? '', page, 5);
    }
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final users = await getData(event.action, event.id, event.searchQuery, 1);

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
          users: users.data,
          totalItems: users.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreUsers(LoadMoreUsersEvent event, Emitter emit) async {
    try {
      final users = await getData(event.action, event.id, event.searchQuery, event.page);

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
          totalItems: users.totalItems,
          users: [...state.users, ...users.data],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshUsers(RefreshUsersEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final users = await getData(event.action, event.id, event.searchQuery, 1);

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
          users: users.data,
          totalItems: users.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<GetMeEvent>(_onGetMe);
    on<UpdateMeEvent>(_onUpdateMe);
    on<CreatePinEvent>(_onCreatePin);
    on<UpdatePinEvent>(_onUpdatePin);
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
}
