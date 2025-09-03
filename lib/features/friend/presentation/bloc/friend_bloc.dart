import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedFriendsBloc extends Bloc<LoadFriendEvent, LoadedFriendsState> {
  LoadedFriendsBloc() : super((const LoadedFriendsState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreFriendsEvent>(_onLoadMoreFriends);
    on<RefreshFriendsEvent>(_onRefreshFriends);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<FriendUseCase>();

      final friends = await useCase.getFriends(event.searchQuery, 1, 5);

      emit(
        state.copyWith(
          page: friends.page,
          totalPage: friends.totalPage,
          requests: friends.data,
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
      final friends = await useCase.getFriends(event.searchQuery, state.page + 1, 5);
      emit(
        state.copyWith(
          page: friends.page,
          totalPage: friends.totalPage,
          requests: [...state.requests, ...friends.data],
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
      final friends = await useCase.getFriends('', 1, 5);

      emit(
        state.copyWith(
          page: friends.page,
          totalPage: friends.totalPage,
          requests: friends.data,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}


class FriendBloc extends Bloc<FriendEvent, FriendState> {
  FriendBloc() : super(FriendState()) {
    on<SendFriendRequestEvent>(_onSendFriendRequest);
    on<AcceptFriendRequestEvent>(_onAcceptFriendRequest);
    on<DeclineFriendRequestEvent>(_onDeclineFriendRequest);
  }

  Future _onSendFriendRequest(SendFriendRequestEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<FriendUseCase>();
      await useCase.sendFriendRequest(event.friendId, event.message);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onAcceptFriendRequest(AcceptFriendRequestEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<FriendUseCase>();
      await useCase.acceptFriendRequest(event.friendId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onDeclineFriendRequest(DeclineFriendRequestEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<FriendUseCase>();
      await useCase.declineFriendRequest(event.friendId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

}
