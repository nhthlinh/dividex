import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoadFriendRequest extends Equatable {
  const LoadFriendRequest();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadFriendRequest {
  final String? id;
  final String? searchQuery;
  final FriendRequestType type;
  const InitialEvent(this.id, {this.searchQuery, required this.type});
}

class LoadMoreFriendsEvent extends LoadFriendRequest {
  final String? id;
  final String? searchQuery;
  final FriendRequestType type;
  const LoadMoreFriendsEvent(this.id, {this.searchQuery, required this.type});
}

class RefreshFriendsEvent extends LoadFriendRequest {
  final String? id;
  final FriendRequestType type;
  const RefreshFriendsEvent(this.id, {required this.type});
}

class FriendRequestBloc
    extends Bloc<LoadFriendRequest, LoadedFriendRequestsState> {
  FriendRequestBloc() : super((const LoadedFriendRequestsState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreFriendsEvent>(_onLoadMoreFriends);
    on<RefreshFriendsEvent>(_onRefreshFriends);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<FriendUseCase>();

      final friends = await useCase.getFriendRequests(event.type, event.searchQuery, 1, 5);

      emit(
        state.copyWith(
          page: friends.page,
          totalPage: friends.totalPage,
          received: event.type == FriendRequestType.received
              ? friends.data
              : state.received,
          sent: event.type == FriendRequestType.sent
              ? friends.data
              : state.sent,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreFriends(LoadMoreFriendsEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<FriendUseCase>();
      final friends = await useCase.getFriendRequests(
        event.type,
        event.searchQuery,
        state.page + 1,
        5,
      );
      emit(
        state.copyWith(
          page: friends.page,
          totalPage: friends.totalPage,
          received: event.type == FriendRequestType.received
              ? [...state.received, ...friends.data]
              : state.received,
          sent: event.type == FriendRequestType.sent
              ? [...state.sent, ...friends.data]
              : state.sent,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshFriends(RefreshFriendsEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<FriendUseCase>();
      final friends = await useCase.getFriendRequests(event.type, '', 1, 5);

      emit(
        state.copyWith(
          page: friends.page,
          totalPage: friends.totalPage,
          isLoading: false,
          received: event.type == FriendRequestType.received
              ? friends.data
              : state.received,
          sent: event.type == FriendRequestType.sent
              ? friends.data
              : state.sent,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}
