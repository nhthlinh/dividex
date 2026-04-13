import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/data/repositories/group_repository_impl.dart';
import 'package:Dividex/features/group/data/source/group_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGroupRemoteDataSource extends Mock implements GroupRemoteDataSource {}

void main() {
  late GroupRemoteDataSource remoteDataSource;
  late GroupRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockGroupRemoteDataSource();
    repository = GroupRepositoryImpl(remoteDataSource);
  });

  test('createGroup delegates and returns created group id', () async {
    when(
      () => remoteDataSource.createGroup(name: 'Trip', memberIds: <String>['u1', 'u2']),
    ).thenAnswer((_) async => 'g-1');

    final id = await repository.createGroup(name: 'Trip', memberIds: <String>['u1', 'u2']);

    expect(id, 'g-1');
    verify(() => remoteDataSource.createGroup(name: 'Trip', memberIds: <String>['u1', 'u2'])).called(1);
  });

  test('listGroups delegates and returns paging groups', () async {
    final page = PagingModel<List<GroupModel>>(
      data: <GroupModel>[GroupModel(id: 'g-1', name: 'Trip')],
      page: 1,
      totalPage: 1,
      totalItems: 1,
    );
    when(() => remoteDataSource.listGroups(1, 10, 'trip')).thenAnswer((_) async => page);

    final result = await repository.listGroups(1, 10, 'trip');

    expect(result.data.first.id, 'g-1');
    verify(() => remoteDataSource.listGroups(1, 10, 'trip')).called(1);
  });
}
