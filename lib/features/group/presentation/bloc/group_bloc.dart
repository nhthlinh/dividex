import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedGroupsBloc extends Bloc<LoadGroupsEvent, LoadedGroupsState> {
  LoadedGroupsBloc() : super((const LoadedGroupsState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreGroupsEvent>(_onLoadMoreGroups);
    on<RefreshGroupsEvent>(_onRefreshGroups);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();

      final groups = event.isDetail
          ? await useCase.listGroupsWithDetail(1, 3, event.searchQuery ?? '')
          : await useCase.listGroups(1, 1000, event.searchQuery ?? '');

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
      final groups = event.isDetail
          ? await useCase.listGroupsWithDetail(
              state.page + 1,
              3,
              event.searchQuery ?? '',
            )
          : await useCase.listGroups(
              state.page + 1,
              1000,
              event.searchQuery ?? '',
            );

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
      final groups = event.isDetail
          ? await useCase.listGroupsWithDetail(1, 3, event.searchQuery ?? '')
          : await useCase.listGroups(1, 1000, event.searchQuery ?? '');

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
}

class GroupBloc extends Bloc<GroupsEvent, GroupState> {
  GroupBloc() : super((const GroupState())) {
    on<CreateGroupEvent>(_onCreateGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<LeaveGroupEvent>(_onLeaveGroup);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<GetGroupDetailEvent>(_onGetGroupDetail);
    on<UpdateGroupLeaderEvent>(_onUpdateGroupLeader);
    on<GetGroupReportEvent>(_onGetGroupReport);
  }

  Future _onCreateGroup(CreateGroupEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      final groupId = await useCase.createGroup(
        name: event.name,
        memberIds: event.memberIds,
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);

      if (event.avatar != null) {
        uploadImage(groupId, [event.avatar!], AttachmentType.group);
      }
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.userNotFound)) {
        showCustomToast(intl.userNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onUpdateGroup(UpdateGroupEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      final groupId = await useCase.updateGroup(
        groupId: event.groupId,
        name: event.name,
        addMemberIds: event.memberIdsAdd,
        deleteMemberIds: event.memberIdsRemove,
      );

      if (event.avatar != null && event.deletedAvatarUid != null) {
        updateImage(
          groupId,
          [event.avatar!],
          AttachmentType.group,
          [event.deletedAvatarUid!],
        );
      } else if (event.avatar == null && event.deletedAvatarUid != null) {
        deleteImage([event.deletedAvatarUid!]);
      } else if (event.avatar != null && event.deletedAvatarUid == null) {
        uploadImage(
          groupId,
          [event.avatar!],
          AttachmentType.group,
        );
      }

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.userNotFound)) {
        showCustomToast(intl.userNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onUpdateGroupLeader(
    UpdateGroupLeaderEvent event,
    Emitter emit,
  ) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      await useCase.updateGroupLeader(event.groupId, event.newLeaderId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.userNotFound)) {
        showCustomToast(intl.userNotFound, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onDeleteGroup(DeleteGroupEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      await useCase.deleteGroup(event.groupId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.deleteIsDenied)) {
        showCustomToast(intl.deleteIsDenied, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onLeaveGroup(LeaveGroupEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      await useCase.leaveGroup(event.groupId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.leaveIsDenied)) {
        showCustomToast(intl.leaveIsDenied, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onGetGroupDetail(GetGroupDetailEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      final results = await Future.wait([
        useCase.getGroupDetail(event.groupId),
        useCase.getBarChartData(event.groupId, event.year),
      ]);

      emit(GroupDetailState(groupDetail: results[0] as GroupModel?, barChartData: results[1] as List<CustomBarChartData>?));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onGetGroupReport(GetGroupReportEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      final results = await Future.wait([
        useCase.getGroupReport(event.groupId),
        useCase.getChartData(event.groupId),
      ]);
      final group = await useCase.getGroupDetail(event.groupId);
      emit( 
        GroupReportState(
          groupReport: results[0] as GroupModel?,
          groupDetail: group,
          chartData: results[1] as List<ChartData>?,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  // Future _onGetChartData(GetChartDataEvent event, Emitter emit) async {
  //   try {
  //     final useCase = await getIt.getAsync<GroupUseCase>();
  //     final chartData = await useCase.getChartData(event.groupId);

  //     if (state is GroupReportState) {
  //       emit((state as GroupReportState).copyWith(chartData: chartData));
  //     } else {
  //       emit(GroupReportState(chartData: chartData));
  //     }
  //   } catch (e) {
  //     final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
  //     if (e.toString().contains(MessageCode.groupNotFound)) {
  //       showCustomToast(intl.groupNotFound, type: ToastType.error);
  //     } else {
  //       showCustomToast(intl.error, type: ToastType.error);
  //     }
  //   }
  // }
}

class LoadedGroupsEventsBloc
    extends Bloc<LoadGroupEventsEvent, LoadedGroupsEventsState> {
  LoadedGroupsEventsBloc() : super((const LoadedGroupsEventsState())) {
    on<LoadGroupEventsEventInitial>(_onInitial);
    on<LoadMoreEventsEvent>(_onLoadMoreEvents);
    on<RefreshEventsEvent>(_onRefreshEvents);
  }

  Future _onInitial(LoadGroupEventsEventInitial event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();

      final events = await useCase.listEvents(
        event.page,
        event.pageSize,
        event.groupId,
        event.searchQuery ?? '',
      );

      emit(
        state.copyWith(
          page: events.page,
          totalPage: events.totalPage,
          events: events.data,
          totalItems: events.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreEvents(LoadMoreEventsEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<GroupUseCase>();
      final events = await useCase.listEvents(
        event.page,
        event.pageSize,
        event.groupId,
        event.searchQuery ?? '',
      );

      emit(
        state.copyWith(
          page: events.page,
          totalPage: events.totalPage,
          totalItems: events.totalItems,
          events: [...state.events, ...events.data],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshEvents(RefreshEventsEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<GroupUseCase>();
      final events = await useCase.listEvents(
        event.page,
        event.pageSize,
        event.groupId,
        event.searchQuery ?? '',
      );

      emit(
        state.copyWith(
          page: events.page,
          totalPage: events.totalPage,
          events: events.data,
          totalItems: events.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}
