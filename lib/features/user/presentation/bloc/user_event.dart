import 'package:equatable/equatable.dart';

abstract class LoadUserEvent extends Equatable {
  const LoadUserEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadUserEvent {
  final String? userId;
  final String? groupId;
  const InitialEvent(this.userId, this.groupId);
}

class LoadMoreUsersEvent extends LoadUserEvent {
  final String? userId;
  final String? groupId;
  const LoadMoreUsersEvent(this.userId, this.groupId);
}

class RefreshUsersEvent extends LoadUserEvent {
  final String? userId;
  final String? groupId;
  const RefreshUsersEvent(this.userId, this.groupId);
}
