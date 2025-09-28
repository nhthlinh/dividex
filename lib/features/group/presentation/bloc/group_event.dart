import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class LoadGroupsEvent extends Equatable {
  const LoadGroupsEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadGroupsEvent {
  final String? searchQuery;
  const InitialEvent(this.searchQuery);
}

class LoadMoreGroupsEvent extends LoadGroupsEvent {
  final String? searchQuery;
  const LoadMoreGroupsEvent(this.searchQuery);
}

class RefreshGroupsEvent extends LoadGroupsEvent {
  final String? searchQuery;
  const RefreshGroupsEvent(this.searchQuery);
}

class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object?> get props => [];
}

class CreateGroupEvent extends GroupsEvent {
  final String name;
  final List<String> memberIds;
  final Uint8List? avatar;

  const CreateGroupEvent({required this.name, required this.memberIds, this.avatar});

  @override
  List<Object?> get props => [name, memberIds];
}

class DeleteGroupEvent extends GroupsEvent {
  final String groupId;

  const DeleteGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class LeaveGroupEvent extends GroupsEvent {
  final String groupId;

  const LeaveGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class GetGroupDetailEvent extends GroupsEvent {
  final String groupId;

  const GetGroupDetailEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class LoadGroupEventsEvent extends Equatable {
  const LoadGroupEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupEventsEventInitial extends LoadGroupEventsEvent {
  final int page;
  final int pageSize;
  final String groupId;
  final String? searchQuery;

  const LoadGroupEventsEventInitial({
    required this.page,
    required this.pageSize,
    required this.groupId,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, pageSize, groupId, searchQuery];
}

class RefreshEventsEvent extends LoadGroupEventsEvent {
  final int page;
  final int pageSize;
  final String groupId;
  final String? searchQuery;

  const RefreshEventsEvent({
    required this.page,
    required this.pageSize,
    required this.groupId,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, pageSize, groupId, searchQuery];
}

class LoadMoreEventsEvent extends LoadGroupEventsEvent {
  final int page;
  final int pageSize;
  final String groupId;
  final String? searchQuery;

  const LoadMoreEventsEvent({
    required this.page,
    required this.pageSize,
    required this.groupId,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, pageSize, groupId, searchQuery];
}
