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
      final useCase = await getIt.getAsync<UserUseCase>();

      final users = event.action == LoadUsersAction.getFriends
          ? await useCase.getUserForCreateGroup(event.id ?? '', 1, 5, event.searchQuery)
          : event.action == LoadUsersAction.getGroupMembers
              ? await useCase.getUserForCreateEvent(event.id ?? '', 1, 5, event.searchQuery)
              : await useCase.getUserForCreateExpense(event.id ?? '', 1, 5, event.searchQuery);

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
      final useCase = await getIt.getAsync<UserUseCase>();
      final users = event.action == LoadUsersAction.getFriends
          ? await useCase.getUserForCreateGroup(event.id ?? '', state.page + 1, 5, event.searchQuery)
          : event.action == LoadUsersAction.getGroupMembers
              ? await useCase.getUserForCreateEvent(event.id ?? '', state.page + 1, 5, event.searchQuery)
              : await useCase.getUserForCreateExpense(event.id ?? '', state.page + 1, 5, event.searchQuery);

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

      final useCase = await getIt.getAsync<UserUseCase>();
      final users = event.action == LoadUsersAction.getFriends
          ? await useCase.getUserForCreateGroup(event.id ?? '', 1, 5, event.searchQuery)
          : event.action == LoadUsersAction.getGroupMembers
              ? await useCase.getUserForCreateEvent(event.id ?? '', 1, 5, event.searchQuery)
              : await useCase.getUserForCreateExpense(event.id ?? '', 1, 5, event.searchQuery);

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
