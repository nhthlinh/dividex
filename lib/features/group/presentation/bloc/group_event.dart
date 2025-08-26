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
