import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFriendUseCase extends Mock implements FriendUseCase {}

void main() {
  late FriendUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockFriendUseCase();
    getIt.registerSingletonAsync<FriendUseCase>(() async => useCase);
    await getIt.isReady<FriendUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('LoadedFriendsBloc', () {
    test('loads first page on InitialEvent', () async {
      when(
        () => useCase.getFriends('ali', 1, 5),
      ).thenAnswer(
        (_) async => PagingModel<List<FriendModel>>(
          data: <FriendModel>[
            FriendModel(friendUid: 'f-1', fullName: 'Alice'),
          ],
          page: 1,
          totalPage: 3,
          totalItems: 11,
        ),
      );

      final bloc = LoadedFriendsBloc();
      final completer = Completer<void>();
      final emitted = <LoadedFriendsState>[];
      final sub = bloc.stream.listen((state) {
        emitted.add(state);
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      bloc.add(const InitialEvent('u-1', searchQuery: 'ali'));
      await completer.future;

      expect(emitted.last.isLoading, false);
      expect(emitted.last.requests.length, 1);
      expect(emitted.last.requests.first.friendUid, 'f-1');
      verify(() => useCase.getFriends('ali', 1, 5)).called(1);

      await sub.cancel();
      await bloc.close();
    });
  });

  group('FriendBloc', () {
    test('emits loading then loaded overview on GetFriendOverviewEvent', () async {
      final friend = FriendOverviewModel(
        friend: UserModel(id: 'u-2', fullName: 'Bob'),
        mutualGroups: 1,
        sharedEvents: 2,
        sharedExpenses: 3,
        totalDebt: 15.0,
      );
      when(() => useCase.getFriendOverview('u-2')).thenAnswer((_) async => friend);

      final bloc = FriendBloc();

      bloc.add(GetFriendOverviewEvent('u-2'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(bloc.state, isA<FriendOverviewState>());
      final state = bloc.state as FriendOverviewState;
      expect(state.isLoading, false);
      expect(state.overview?.friend.id, 'u-2');
      verify(() => useCase.getFriendOverview('u-2')).called(1);

      await bloc.close();
    });
  });
}
