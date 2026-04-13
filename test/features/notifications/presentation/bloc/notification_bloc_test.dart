import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/domain/usecase.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_event.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotiUseCase extends Mock implements NotiUseCase {}

void main() {
  late NotiUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockNotiUseCase();
    getIt.registerSingletonAsync<NotiUseCase>(() async => useCase);
    await getIt.isReady<NotiUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('InitialEvent emits loaded notification state', () async {
    when(() => useCase.getNotifications(1, 20)).thenAnswer(
      (_) async => PagingModel<List<NotificationModel>>(
        data: <NotificationModel>[],
        page: 1,
        totalPage: 1,
        totalItems: 0,
      ),
    );

    final bloc = LoadedNotiBloc();
    final completer = Completer<void>();
    late LoadedNotiState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (!state.isLoading && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const InitialEvent());
    await completer.future;

    expect(emitted.isLoading, false);
    expect(emitted.page, 1);
    verify(() => useCase.getNotifications(1, 20)).called(1);

    await sub.cancel();
    await bloc.close();
  });
}
