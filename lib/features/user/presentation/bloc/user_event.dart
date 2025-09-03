import 'package:equatable/equatable.dart';

enum LoadUsersAction {
  getFriends,
  getGroupMembers,
  getEventParticipants,
  getUsersBySearch,
}

abstract class LoadUserEvent extends Equatable {
  const LoadUserEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadUserEvent {
  final String? id;
  final LoadUsersAction action;
  final String? searchQuery;
  const InitialEvent(this.id, this.action, {this.searchQuery});
}

class LoadMoreUsersEvent extends LoadUserEvent {
  final String? id;
  final LoadUsersAction action;
  final String? searchQuery;
  const LoadMoreUsersEvent(this.id, this.action, {this.searchQuery});
}

class RefreshUsersEvent extends LoadUserEvent {
  final String? id;
  final LoadUsersAction action;
  final String? searchQuery;
  const RefreshUsersEvent(this.id, this.action, {this.searchQuery});
}
