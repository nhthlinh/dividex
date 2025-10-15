
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/event_expense/domain/event_usecase.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super((EventState())) {
    on<CreateEventEvent>(_onCreateEvent);
    on<GetEventEvent>(_onGetEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
    on<JoinEvent>(_onJoinEvent);
    on<AddMembersToEvent>(_onAddMembersToEvent);
  }

  Future _onCreateEvent(CreateEventEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      await useCase.createEvent(
        event.name,
        event.groupId,
        event.eventStart,
        event.eventEnd,
        event.description,
        event.memberIds ?? [],
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.createIsDenied)) {
        showCustomToast(intl.createIsDenied, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onGetEvent(GetEventEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      final eventData = await useCase.getEvent(event.eventId);

      if (eventData != null) {
        emit(EventLoadedState(event: eventData));
      } else {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      }
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.eventNotFound)) {
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onUpdateEvent(UpdateEventEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      await useCase.updateEvent(
        event.eventId,
        event.name,
        event.eventStart,
        event.eventEnd,
        event.description,
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.updateIsDenied)) {
        showCustomToast(intl.updateIsDenied, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.eventNotFound)) {
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onDeleteEvent(DeleteEventEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      await useCase.deleteEvent(event.eventId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.deleteIsDenied)) {
        showCustomToast(intl.deleteIsDenied, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.eventNotFound)) {
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onJoinEvent(JoinEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      await useCase.joinEvent(event.eventId, event.userId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.eventNotFound)) {
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onAddMembersToEvent(AddMembersToEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      await useCase.addMembersToEvent(event.eventId, event.memberIds);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.eventNotFound)) {
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }
}

class EventDataBloc extends Bloc<EventEvent, EventDataState> {
  EventDataBloc() : super((EventDataState())) {
    on<InitialEvent>(_onInitialEvent);
    on<LoadMoreEventsGroups>(_onLoadMoreEventsGroups);
    on<RefreshEventsGroups>(_onRefreshEventsGroups);
  }
  
  Future _onInitialEvent(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      final groups = await useCase.listEventsGroups(event.page, event.pageSize, event.searchQuery, orderBy: event.orderBy, sortType: event.sortType);

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
  
  Future _onLoadMoreEventsGroups(LoadMoreEventsGroups event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<EventUseCase>();
      final groups = await useCase.listEventsGroups(event.page, event.pageSize, event.searchQuery, orderBy: event.orderBy, sortType: event.sortType);

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

  Future _onRefreshEventsGroups(RefreshEventsGroups event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<EventUseCase>();
      final groups = await useCase.listEventsGroups(event.page, event.pageSize, event.searchQuery, orderBy: event.orderBy, sortType: event.sortType);

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