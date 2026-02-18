import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:equatable/equatable.dart';

class EventState {}

class EventChartDataState extends EventState {
  final EventModel? eventData;
  final List<ChartData> chartData;
  final List<CustomBarChartData> barChartData;

  EventChartDataState({required this.eventData, required this.chartData, required this.barChartData});
}

class EventLoadedState extends EventState {
  final EventModel event;

  EventLoadedState({required this.event});
}

class EventDataState extends Equatable {
  const EventDataState({
    this.isLoading = true,
    this.page = 1,
    this.totalPage = 0,
    this.totalItems = 0,
    this.groups = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<GroupModel> groups;

  @override
  List<Object?> get props => [isLoading, page, totalPage, totalItems, groups];

  EventDataState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<GroupModel>? groups,
  }) {
    return EventDataState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalItems: totalItems ?? this.totalItems,
      groups: groups ?? this.groups,
    );
  }
}
