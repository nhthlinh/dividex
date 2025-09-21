import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedGroupsBloc extends Bloc<LoadGroupsEvent, LoadedGroupsState> {
  LoadedGroupsBloc() : super((const LoadedGroupsState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreGroupsEvent>(_onLoadMoreGroups);
    on<RefreshGroupsEvent>(_onRefreshGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<EditGroupEvent>(_onEditGroup);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();

      final groups = await useCase.getUserGroups(event.userId ?? '', 1, 5);

      emit(
        state.copyWith(
          page: groups.page,
          totalPage: groups.totalPage,
          groups: groups.data,
          totalItems: groups.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreGroups(LoadMoreGroupsEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      final groups = await useCase.getUserGroups(event.userId ?? '', state.page + 1, 5);

      emit(
        state.copyWith(
          page: groups.page,
          totalPage: groups.totalPage,
          totalItems: groups.totalItems,
          groups: [...state.groups, ...groups.data],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshGroups(RefreshGroupsEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<GroupUseCase>();
      final groups = await useCase.getUserGroups(event.userId ?? '', 1, 5);

      emit(
        state.copyWith(
          page: groups.page,
          totalPage: groups.totalPage,
          groups: groups.data,
          totalItems: groups.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onCreateGroup(CreateGroupEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      await useCase.createGroup(name: event.name, avatarPath: event.avatarPath, memberIds: event.memberIds);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onEditGroup(EditGroupEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      await useCase.editGroup(
        groupId: event.groupId,
        name: event.name,
        avatarPath: event.avatarPath,
        memberIds: event.memberIds,
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}