import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:equatable/equatable.dart';

class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final int unreadCount;

  NotificationLoaded(this.unreadCount);
}

class LoadedNotiState extends Equatable {
  const LoadedNotiState({
    this.isLoading = true,
    this.page = 1,
    this.totalPage = 0,
    this.totalItems = 0,
    this.notis = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<NotificationModel> notis;

  @override
  List<Object?> get props => [isLoading, page, totalPage, totalItems, notis];

  LoadedNotiState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<NotificationModel>? notis,
  }) {
    return LoadedNotiState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalItems: totalItems ?? this.totalItems,
      notis: notis ?? this.notis,
    );
  }
}