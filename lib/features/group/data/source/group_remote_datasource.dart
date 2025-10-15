
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class GroupRemoteDataSource {
  Future<String> createGroup({ 
    required String name,
    required List<String> memberIds,
  });
  Future<GroupModel?> getGroupDetail(String groupId);
  Future<void> deleteGroup(String groupId);
  Future<void> leaveGroup(String groupId);
  Future<PagingModel<List<EventModel>>> listEvents(int page, int pageSize, String groupId, String searchQuery);
  Future<PagingModel<List<GroupModel>>> listGroups(int page, int pageSize, String searchQuery);
  Future<PagingModel<List<GroupModel>>> listGroupsWithDetail(int page, int pageSize, String searchQuery);

  Future<String> updateGroup({
    required String groupId,
    required String name,
    required List<String> addMemberIds,
    required List<String> deleteMemberIds,
  });

  Future<void> updateGroupLeader(String groupId, String newLeaderId);
  Future<GroupModel?> getGroupReport(String groupId);
  Future<List<ChartData>> getChartData(String groupId);
}

