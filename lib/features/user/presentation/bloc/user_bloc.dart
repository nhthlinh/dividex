import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/user/domain/usecase.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedUsersBloc extends Bloc<LoadUserEvent, LoadedUsersState> {
  LoadedUsersBloc() : super((const LoadedUsersState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      bool isForGroup = event.userId != null;
      final useCase = await getIt.getAsync<UserUseCase>();

      final users = isForGroup
          ? await useCase.getUserForCreateGroup(event.groupId ?? '', 1, 5)
          : await useCase.getUserForCreateEvent(event.userId ?? '', 1, 5);

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
          users: users.data,
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
      bool isForGroup = event.userId != null;
      print('Load more');
      print(event.groupId);
      print(event.userId);
      print(isForGroup);
      final useCase = await getIt.getAsync<UserUseCase>();
      final users = isForGroup
          ? await useCase.getUserForCreateGroup(
              event.groupId ?? '',
              state.page + 1,
              5,
            )
          : await useCase.getUserForCreateEvent(
              event.userId ?? '',
              state.page + 1,
              5,
            );

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
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

      bool isForGroup = event.userId != null;
      final useCase = await getIt.getAsync<UserUseCase>();
      final users = isForGroup
          ? await useCase.getUserForCreateGroup(event.groupId ?? '', 1, 5)
          : await useCase.getUserForCreateEvent(event.userId ?? '', 1, 5);

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
          users: users.data,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}
