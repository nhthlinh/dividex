// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/core/di/injection.dart';
// import 'package:Dividex/features/event_expense/domain/usecase.dart';
// import 'package:Dividex/shared/widgets/message_widget.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoadedEventsBloc
//     extends Bloc<LoadEventsEvent, LoadedEventsState> {
//   LoadedEventsBloc() : super((const LoadedEventsState())) {
//     on<InitialEvent>(_onInitial);
//     on<LoadMoreEventsEvent>(_onLoadMoreEvents);
//     on<RefreshEventsEvent>(_onRefreshEvents);
//   }

//   Future _onInitial(InitialEvent event, Emitter emit) async {
//     try {
//       final useCase = await getIt.getAsync<ExpenseUseCase>();
//       final events = await useCase.getEvents(1, 5);

//       emit(
//         state.copyWith(
//           page: events.page,
//           totalPage: events.totalPage,
//           events: events.data,
//           isLoading: false,
//         ),
//       );
//     } catch (e) {
//       final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
//       showCustomToast(intl.error, type: ToastType.error);
//     }
//   }

//   Future _onLoadMoreEvents(
//     LoadMoreEventsEvent event,
//     Emitter emit,
//   ) async {
//     try {
//       final useCase = await getIt.getAsync<ExpenseUseCase>();
//       final Events = await useCase.getEvents(
//         state.page + 1,
//         5,
//       );

//       emit(
//         state.copyWith(
//           page: Events.page,
//           totalPage: Events.totalPage,
//           Events: [...state.Events, ...Events.data],
//         ),
//       );
//     } catch (e) {
//       final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
//       showCustomToast(intl.error, type: ToastType.error);
//     }
//   }

//   Future _onRefreshEvents(
//     RefreshEventsEvent event,
//     Emitter emit,
//   ) async {
//     if (state.isLoading) return;

//     try {
//       emit(state.copyWith(isLoading: true));

//       final useCase = await getIt.getAsync<ExpenseUseCase>();
//       final events = await useCase.getEvents(1, 5);

//       emit(
//         state.copyWith(
//           page: events.page,
//           totalPage: events.totalPage,
//           events: events.data,
//           isLoading: false,
//         ),
//       );
//     } catch (e) {
//       final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
//       showCustomToast(intl.error, type: ToastType.error);
//     }
//   }
// }

// abstract class LoadEventsEvent extends Equatable {
//   const LoadEventsEvent();

//   @override
//   List<Object?> get props => [];
// }

// class InitialEvent extends LoadEventsEvent {
//   const InitialEvent();
// }

// class LoadMoreEventsEvent extends LoadEventsEvent {
//   const LoadMoreEventsEvent();
// }

// class RefreshEventsEvent extends LoadEventsEvent {
//   const RefreshEventsEvent(param0);
// }

// class LoadedEventsState extends Equatable {
//   const LoadedEventsState({
//     this.isLoading = true,
//     this.page = 0,
//     this.totalPage = 0,
//     this.events = const [],
//   });

//   final bool isLoading;
//   final int page;
//   final int totalPage;
//   final List<String> events;

//   bool get hasMore => page < totalPage;

//   @override
//   List<Object?> get props => [isLoading, page, totalPage, events];

//   LoadedEventsState copyWith({
//     bool? isLoading,
//     int? page,
//     int? totalPage,
//     List<String>? events,
//   }) {
//     return LoadedEventsState(
//       isLoading: isLoading ?? this.isLoading,
//       page: page ?? this.page,
//       totalPage: totalPage ?? this.totalPage,
//       events: events ?? this.events,
//     );
//   }
// }
