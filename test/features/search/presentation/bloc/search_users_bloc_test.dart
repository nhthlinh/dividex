import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/search/presentation/bloc/search_users_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
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

  test('InitialEvent emits searched users state', () async {
    when(() => useCase.searchUsers('ali', 1, 5)).thenAnswer(
      (_) async => PagingModel<List<FriendModel>>(
        data: <FriendModel>[FriendModel(friendUid: 'u-1', fullName: 'Alice')],
        page: 1,
        totalPage: 1,
        totalItems: 1,
      ),
    );

    final bloc = SearchUsersBloc();
    final completer = Completer<void>();
    late LoadedFriendsState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (!state.isLoading && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const InitialEvent('me', searchQuery: 'ali'));
    await completer.future;

    expect(emitted.requests.length, 1);
    expect(emitted.requests.first.friendUid, 'u-1');
    verify(() => useCase.searchUsers('ali', 1, 5)).called(1);

    await sub.cancel();
    await bloc.close();
  });
}
