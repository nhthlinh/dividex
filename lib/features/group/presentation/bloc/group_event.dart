import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class LoadGroupsEvent extends Equatable {
  const LoadGroupsEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadGroupsEvent {
  final String? searchQuery;
  final bool isDetail;
  const InitialEvent(this.searchQuery, this.isDetail);
}

class LoadMoreGroupsEvent extends LoadGroupsEvent {
  final String? searchQuery;
  final bool isDetail;
  const LoadMoreGroupsEvent(this.searchQuery, this.isDetail);
}

class RefreshGroupsEvent extends LoadGroupsEvent {
  final String? searchQuery;
  final bool isDetail;

  const RefreshGroupsEvent(this.searchQuery, this.isDetail);
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

  const CreateGroupEvent({
    required this.name,
    required this.memberIds,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, memberIds];
}

class UpdateGroupEvent extends GroupsEvent {
  final String groupId;
  final String name;
  final List<String> memberIdsAdd;
  final List<String> memberIdsRemove;
  final Uint8List? avatar;
  final String? deletedAvatarUid;

  const UpdateGroupEvent({
    required this.groupId,
    required this.name,
    required this.memberIdsAdd,
    required this.memberIdsRemove,
    this.avatar,
    this.deletedAvatarUid
  });

  @override
  List<Object?> get props => [name, memberIdsAdd, memberIdsRemove, avatar, deletedAvatarUid];
}

class UpdateGroupLeaderEvent extends GroupsEvent {
  final String groupId;
  final String newLeaderId;

  const UpdateGroupLeaderEvent({
    required this.groupId,
    required this.newLeaderId,
  });

  @override
  List<Object?> get props => [groupId, newLeaderId];
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
  final int year;

  const GetGroupDetailEvent(this.groupId, this.year);

  @override
  List<Object?> get props => [groupId, year];
}

class GetGroupReportEvent extends GroupsEvent {
  final String groupId;

  const GetGroupReportEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class GetSimpleDetailGroupEvent extends GroupsEvent {
  final String groupId;

  const GetSimpleDetailGroupEvent(this.groupId);

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
