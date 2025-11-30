import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/domain/usecase.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_event.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedNotiBloc extends Bloc<LoadNotiEvent, LoadedNotiState> {
  LoadedNotiBloc() : super((const LoadedNotiState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreNotiEvent>(_onLoadMoreNoti);
    on<RefreshNotiEvent>(_onRefreshNoti);
  }

  Future<PagingModel<List<NotificationModel>>> getData(
    int page,
  ) async {
    final useCase = await getIt.getAsync<NotiUseCase>();
    return await useCase.getNotifications(page, 20);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final notis = await getData(1);

      emit(
        state.copyWith(
          page: notis.page,
          totalPage: notis.totalPage,
          notis: notis.data,
          totalItems: notis.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreNoti(LoadMoreNotiEvent event, Emitter emit) async {
    try {
      final notis = await getData(event.page);

      emit(
        state.copyWith(
          page: notis.page,
          totalPage: notis.totalPage,
          totalItems: notis.totalItems,
          notis: [...state.notis, ...notis.data],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshNoti(RefreshNotiEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final notis = await getData(1);

      emit(
        state.copyWith(
          page: notis.page,
          totalPage: notis.totalPage,
          notis: notis.data,
          totalItems: notis.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}