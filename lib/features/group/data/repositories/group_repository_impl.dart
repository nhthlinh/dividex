import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/group_repository.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
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
    return remoteDataSource.createGroup(name: name, memberIds: memberIds);
  }

  @override
  Future<PagingModel<List<GroupModel>>> listGroups(
    int page,
    int pageSize,
    String searchQuery,
  ) {
    return remoteDataSource.listGroups(page, pageSize, searchQuery);
  }

  @override
  Future<PagingModel<List<GroupModel>>> listGroupsWithDetail(
    int page,
    int pageSize,
    String searchQuery,
  ) {
    return remoteDataSource.listGroupsWithDetail(page, pageSize, searchQuery);
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
    return remoteDataSource.listEvents(page, pageSize, groupId, searchQuery);
  }

  @override
  Future<String> updateGroup({
    required String groupId,
    required String name,
    required List<String> addMemberIds,
    required List<String> deleteMemberIds,
  }) {
    return remoteDataSource.updateGroup(
      groupId: groupId,
      name: name,
      addMemberIds: addMemberIds,
      deleteMemberIds: deleteMemberIds,
    );
  }

  @override
  Future<void> updateGroupLeader(String groupId, String newLeaderId) {
    return remoteDataSource.updateGroupLeader(groupId, newLeaderId);
  }

  @override
  Future<GroupModel?> getGroupReport(String groupId) {
    return remoteDataSource.getGroupReport(groupId);
  }

  @override
  Future<List<ChartData>> getChartData(String groupId) {
    return remoteDataSource.getChartData(groupId);
  }
}
