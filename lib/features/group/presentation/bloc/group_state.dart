import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:equatable/equatable.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class LoadedGroupsState extends Equatable {
  const LoadedGroupsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.groups = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final List<GroupModel> groups;

  bool get hasMore => page < totalPage;

  @override
  List<Object?> get props => [isLoading, page, totalPage, groups];

  LoadedGroupsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    List<GroupModel>? groups,
  }) {
    return LoadedGroupsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      groups: groups ?? this.groups,
    );
  }
}
