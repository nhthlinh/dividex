import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:equatable/equatable.dart';

class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupDetailState extends GroupState {
  final GroupModel? groupDetail;

  const GroupDetailState({this.groupDetail});

  @override
  List<Object?> get props => [groupDetail];

  GroupDetailState copyWith({
    GroupModel? groupDetail,
  }) {
    return GroupDetailState(
      groupDetail: groupDetail ?? this.groupDetail,
    );
  }
}


class LoadedGroupsState extends Equatable {
  const LoadedGroupsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.totalItems = 0,
    this.groups = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<GroupModel> groups;

  bool get hasMore => page < totalPage;

  @override
  List<Object?> get props => [isLoading, page, totalPage, groups, totalItems];

  LoadedGroupsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<GroupModel>? groups,
  }) {
    return LoadedGroupsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      groups: groups ?? this.groups,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}


class LoadedGroupsEventsState extends Equatable {
  const LoadedGroupsEventsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.totalItems = 0,
    this.events = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<EventModel> events;

  bool get hasMore => page < totalPage;

  @override
  List<Object?> get props => [isLoading, page, totalPage, events, totalItems];

  LoadedGroupsEventsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<EventModel>? events,
  }) {
    return LoadedGroupsEventsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      events: events ?? this.events,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

