import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/data/repositories/user_repository_impl.dart';
import 'package:Dividex/features/user/data/source/user_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRemoteDataSource remoteDataSource;
  late UserRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource);
  });

  group('UserRepositoryImpl.getUserForCreateGroup', () {
    test('delegates and returns paging users', () async {
      final page = PagingModel<List<UserModel>>(
        data: <UserModel>[UserModel(id: 'u-1', fullName: 'Alice')],
        page: 1,
        totalPage: 1,
        totalItems: 1,
      );

      when(
        () => remoteDataSource.getUserForCreateGroup('me', 1, 5, 'ali'),
      ).thenAnswer((_) async => page);

      final result = await repository.getUserForCreateGroup('me', 1, 5, 'ali');

      expect(result.data.first.id, 'u-1');
      verify(() => remoteDataSource.getUserForCreateGroup('me', 1, 5, 'ali')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('UserRepositoryImpl.getMe', () {
    test('returns current user from remote', () async {
      when(
        () => remoteDataSource.getMe(),
      ).thenAnswer((_) async => UserModel(id: 'me-1', fullName: 'Current User'));

      final result = await repository.getMe();

      expect(result.id, 'me-1');
      expect(result.fullName, 'Current User');
      verify(() => remoteDataSource.getMe()).called(1);
    });
  });
}
