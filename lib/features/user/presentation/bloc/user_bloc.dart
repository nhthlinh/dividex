import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/domain/usecase.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/paging_model.dart';
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
  ) async {
    final useCase = await getIt.getAsync<UserUseCase>();
    switch (type) {
      case LoadType.friends:
        return await useCase.getUserForCreateGroup(id ?? '', 1, 5, searchQuery);
      case LoadType.groupMembers:
        return await useCase.getUserForCreateEvent(id ?? '', 1, 5, searchQuery);
      case LoadType.eventParticipants:
        return await useCase.getUserForCreateExpense(
          id ?? '',
          1,
          5,
          searchQuery,
        );
    }
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final users = await getData(event.action, event.id, event.searchQuery);

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
      final users = await getData(event.action, event.id, event.searchQuery);

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

      final users = await getData(event.action, event.id, event.searchQuery);

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
