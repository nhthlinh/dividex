import 'package:equatable/equatable.dart';

enum LoadUsersAction {
  getFriends,
  getGroupMembers,
  getEventParticipants,
}

abstract class LoadUserEvent extends Equatable {
  const LoadUserEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadUserEvent {
  final String? id;
  final LoadUsersAction action;
  const InitialEvent(this.id, this.action);
}

class LoadMoreUsersEvent extends LoadUserEvent {
  final String? id;
  final LoadUsersAction action;
  const LoadMoreUsersEvent(this.id, this.action);
}

class RefreshUsersEvent extends LoadUserEvent {
  final String? id;
  final LoadUsersAction action;
  const RefreshUsersEvent(this.id, this.action);
}
