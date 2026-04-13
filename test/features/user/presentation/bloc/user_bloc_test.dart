import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/domain/usecase.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserUseCase extends Mock implements UserUseCase {}

class _MockFriendUseCase extends Mock implements FriendUseCase {}

void main() {
  late UserUseCase userUseCase;
  late FriendUseCase friendUseCase;

  setUp(() async {
    await getIt.reset();
    userUseCase = _MockUserUseCase();
    friendUseCase = _MockFriendUseCase();
    getIt.registerSingletonAsync<UserUseCase>(() async => userUseCase);
    getIt.registerSingletonAsync<FriendUseCase>(() async => friendUseCase);
    await getIt.allReady();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('LoadedUsersBloc', () {
    test('loads friend candidates for group', () async {
      when(
        () => userUseCase.getUserForCreateGroup('me', 1, 5, 'ali'),
      ).thenAnswer(
        (_) async => PagingModel<List<UserModel>>(
          data: <UserModel>[UserModel(id: 'u-1', fullName: 'Alice')],
          page: 1,
          totalPage: 1,
          totalItems: 1,
        ),
      );

      final bloc = LoadedUsersBloc();
      final completer = Completer<void>();
      late LoadedUsersState state;
      final sub = bloc.stream.listen((s) {
        state = s;
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      bloc.add(const InitialEvent('me', LoadType.friends, searchQuery: 'ali'));
      await completer.future;

      expect(state.isLoading, false);
      expect(state.users.first.id, 'u-1');
      verify(() => userUseCase.getUserForCreateGroup('me', 1, 5, 'ali')).called(1);
      verifyNever(() => friendUseCase.listMutualFriends(any(), any(), any()));

      await sub.cancel();
      await bloc.close();
    });
  });

  group('UserBloc', () {
    test('updates state on GetMeEvent', () async {
      when(
        () => userUseCase.getMe(),
      ).thenAnswer((_) async => UserModel(id: 'me-1', fullName: 'Current User'));

      final bloc = UserBloc();
      bloc.add(GetMeEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(bloc.state.user?.id, 'me-1');
      expect(bloc.state.user?.fullName, 'Current User');
      verify(() => userUseCase.getMe()).called(1);

      await bloc.close();
    });
  });
}
