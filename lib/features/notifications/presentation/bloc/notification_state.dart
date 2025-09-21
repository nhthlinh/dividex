class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final int unreadCount;

  NotificationLoaded(this.unreadCount);
}