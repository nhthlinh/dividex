import 'package:Dividex/features/notifications/presentation/bloc/notification_event.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) {
      // Simulate loading notifications and getting unread count
      final int unreadCount = 5; // Replace with actual logic to fetch unread count
      emit(NotificationLoaded(unreadCount));
    });
  }
}
