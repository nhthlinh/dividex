import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:equatable/equatable.dart';

class LoadedFriendsState extends Equatable {
  const LoadedFriendsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.totalItems = 0,
    this.requests = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<FriendModel> requests;

  @override
  List<Object?> get props => [isLoading, page, totalPage, totalItems, requests];

  LoadedFriendsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<FriendModel>? requests,
  }) {
    return LoadedFriendsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      requests: requests ?? this.requests,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class FriendState {}

class LoadedFriendRequestsState extends Equatable {
  const LoadedFriendRequestsState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.totalReceived = 0,
    this.totalSent = 0,
    this.received = const [],
    this.sent = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalReceived;
  final int totalSent;
  final List<FriendModel> received;
  final List<FriendModel> sent;

  @override
  List<Object?> get props => [isLoading, page, totalPage, received, sent];

  LoadedFriendRequestsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalReceived,
    int? totalSent,
    List<FriendModel>? received,
    List<FriendModel>? sent,
  }) {
    return LoadedFriendRequestsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalReceived: totalReceived ?? this.totalReceived,
      totalSent: totalSent ?? this.totalSent,
      received: received ?? this.received,
      sent: sent ?? this.sent,
    );
  }
}


