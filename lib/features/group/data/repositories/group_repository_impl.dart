import 'package:Dividex/features/event_expense/data/models/event_model.dart';
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
  Future<String> createGroup({
    required String name,
    required List<String> memberIds,
  }) {
    return remoteDataSource.createGroup(
      name: name,
      memberIds: memberIds,
    ); 
  }

  @override
  Future<PagingModel<List<GroupModel>>> listGroups(
    int page,
    int pageSize,
    String searchQuery,
  ) {
    return remoteDataSource.listGroups(
      page,
      pageSize,
      searchQuery,
    );
  }

  @override
  Future<GroupModel?> getGroupDetail(String groupId) {
    return remoteDataSource.getGroupDetail(groupId);
  }

  @override
  Future<void> deleteGroup(String groupId) {
    return remoteDataSource.deleteGroup(groupId);
  }

  @override
  Future<void> leaveGroup(String groupId) { 
    return remoteDataSource.leaveGroup(groupId);
  }

  @override
  Future<PagingModel<List<EventModel>>> listEvents(
    int page,
    int pageSize,
    String groupId,
    String searchQuery,
  ) {
    return remoteDataSource.listEvents(
      page,
      pageSize,
      groupId,
      searchQuery,
    );
  }

}
