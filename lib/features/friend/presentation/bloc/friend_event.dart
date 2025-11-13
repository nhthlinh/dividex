import 'package:equatable/equatable.dart';

abstract class LoadFriendEvent extends Equatable {
  const LoadFriendEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadFriendEvent {
  final String? id;
  final String? searchQuery;
  const InitialEvent(this.id, {this.searchQuery});
}

class LoadMoreFriendsEvent extends LoadFriendEvent {
  final String? id;
  final String? searchQuery;
  const LoadMoreFriendsEvent(this.id, {this.searchQuery});
}

class RefreshFriendsEvent extends LoadFriendEvent {
  final String? id;
  final String? searchQuery;
  const RefreshFriendsEvent(this.id, {this.searchQuery});
}

class FriendEvent {}

class SendFriendRequestEvent extends FriendEvent {
  final String friendId;
  final String? message;
  SendFriendRequestEvent(this.friendId, {this.message});
}

class AcceptFriendRequestEvent extends FriendEvent {
  final String friendId;
  AcceptFriendRequestEvent(this.friendId);
}


class DeclineFriendRequestEvent extends FriendEvent {
  final String friendId;
  DeclineFriendRequestEvent(this.friendId);
}

class GetFriendOverviewEvent extends FriendEvent {
  final String friendId;
  GetFriendOverviewEvent(this.friendId);
}
