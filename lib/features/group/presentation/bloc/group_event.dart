import 'package:equatable/equatable.dart';

abstract class LoadGroupsEvent extends Equatable {
  const LoadGroupsEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadGroupsEvent {
  final String? userId;
  const InitialEvent(this.userId);
}

class LoadMoreGroupsEvent extends LoadGroupsEvent {
  final String? userId;
  const LoadMoreGroupsEvent(this.userId);
}

class RefreshGroupsEvent extends LoadGroupsEvent {
  final String? userId;
  const RefreshGroupsEvent(this.userId);
}

class CreateGroupEvent extends LoadGroupsEvent {
  final String name;
  final String avatarPath;
  final List<String> memberIds;

  const CreateGroupEvent({
    required this.name,
    required this.avatarPath,
    required this.memberIds,
  });
  
  @override
  List<Object?> get props => [name, avatarPath, memberIds];
}

class EditGroupEvent extends LoadGroupsEvent {
  final String groupId;
  final String name;
  final String avatarPath;
  final List<String> memberIds;

  const EditGroupEvent({
    required this.groupId,
    required this.name,
    required this.avatarPath,
    required this.memberIds,
  });

  @override
  List<Object?> get props => [groupId, name, avatarPath, memberIds];
}
