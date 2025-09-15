import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/group_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';
import 'package:Dividex/features/group/data/source/group_remote_datasource.dart';

@Injectable(as: GroupRepository)
class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagingModel<List<GroupModel>>> getUserGroups(String userId, int page, int pageSize) {
    return remoteDataSource.getUserGroups(userId, page, pageSize);
  }

  @override
  Future<void> createGroup({
    required String name,
    required String avatarPath,
    required List<String> memberIds,
  }) {
    return remoteDataSource.createGroup(
      name: name,
      avatarPath: avatarPath,
      memberIds: memberIds,
    );
  }

  @override
  Future<void> editGroup({  
    required String groupId,
    required String name,
    required String avatarPath,
    required List<String> memberIds,
  }) {
    return remoteDataSource.editGroup(
      groupId: groupId,
      name: name,
      avatarPath: avatarPath,
      memberIds: memberIds,
    );
  }

}
