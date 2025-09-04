import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:equatable/equatable.dart';

class LoadedFriendsState extends Equatable {
  const LoadedFriendsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.requests = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final List<FriendRequestModel> requests;

  @override
  List<Object?> get props => [isLoading, page, totalPage, requests];

  LoadedFriendsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    List<FriendRequestModel>? requests,
  }) {
    return LoadedFriendsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      requests: requests ?? this.requests,
    );
  }
}

class FriendState {}

class LoadedFriendRequestsState extends Equatable {
  const LoadedFriendRequestsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.received = const [],
    this.sent = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final List<FriendRequestModel> received;
  final List<FriendRequestModel> sent;

  @override
  List<Object?> get props => [isLoading, page, totalPage, received, sent];

  LoadedFriendRequestsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    List<FriendRequestModel>? received,
    List<FriendRequestModel>? sent,
  }) {
    return LoadedFriendRequestsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      received: received ?? this.received,
      sent: sent ?? this.sent,
    );
  }
}


