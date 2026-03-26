import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGroupUseCase extends Mock implements GroupUseCase {}

void main() {
  late GroupUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockGroupUseCase();
    getIt.registerSingletonAsync<GroupUseCase>(() async => useCase);
    await getIt.isReady<GroupUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('LoadedGroupsBloc InitialEvent loads first page groups', () async {
    when(
      () => useCase.listGroups(1, 1000, 'trip'),
    ).thenAnswer(
      (_) async => PagingModel<List<GroupModel>>(
        data: <GroupModel>[GroupModel(id: 'g-1', name: 'Trip')],
        page: 1,
        totalPage: 2,
        totalItems: 3,
      ),
    );

    final bloc = LoadedGroupsBloc();
    final completer = Completer<void>();
    late LoadedGroupsState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const InitialEvent('trip', false));
    await completer.future;

    expect(emitted.isLoading, false);
    expect(emitted.groups.first.id, 'g-1');
    verify(() => useCase.listGroups(1, 1000, 'trip')).called(1);

    await sub.cancel();
    await bloc.close();
  });
}
