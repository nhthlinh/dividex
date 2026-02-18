import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/group_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GroupUseCase {
  final GroupRepository repository;

  GroupUseCase(this.repository);

  Future<String> createGroup({
    required String name,
    required List<String> memberIds,
  }) {
    return repository.createGroup(name: name, memberIds: memberIds);
  }

  Future<PagingModel<List<GroupModel>>> listGroups(
    int page,
    int pageSize,
    String searchQuery,
  ) {
    return repository.listGroups(page, pageSize, searchQuery);
  }

  Future<PagingModel<List<GroupModel>>> listGroupsWithDetail(
    int page,
    int pageSize,
    String searchQuery,
  ) {
    return repository.listGroupsWithDetail(page, pageSize, searchQuery);
  }

  Future<GroupModel?> getGroupDetail(String groupId) {
    return repository.getGroupDetail(groupId);
  }

  Future<void> deleteGroup(String groupId) {
    return repository.deleteGroup(groupId);
  }

  Future<void> leaveGroup(String groupId) {
    return repository.leaveGroup(groupId);
  }

  Future<PagingModel<List<EventModel>>> listEvents(
    int page,
    int pageSize,
    String groupId,
    String searchQuery,
  ) {
    return repository.listEvents(page, pageSize, groupId, searchQuery);
  }

  Future<String> updateGroup({
    required String groupId,
    required String name,
    required List<String> addMemberIds,
    required List<String> deleteMemberIds,
  }) {
    return repository.updateGroup(
      groupId: groupId,
      name: name,
      addMemberIds: addMemberIds,
      deleteMemberIds: deleteMemberIds,
    );
  }

  Future<void> updateGroupLeader(String groupId, String newLeaderId) {
    return repository.updateGroupLeader(groupId, newLeaderId);
  }

  Future<GroupModel?> getGroupReport(String groupId) {
    return repository.getGroupReport(groupId);
  }

  Future<List<ChartData>> getChartData(String groupId) async {
    return repository.getChartData(groupId);
  }

  Future<List<CustomBarChartData>> getBarChartData(String groupId, int year) async {
    return repository.getBarChartData(groupId, year);
  }
}

class ChartData {
  final String fullName;
  final double value;

  ChartData({required this.fullName, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      fullName: json['full_name'] as String,
      value:
          double.tryParse(
            (json['percent'] as String).replaceAll('%', '').trim(),
          )?.abs() ??
          0.0,
    );
  }
}

class CustomBarChartData {
  final int month;
  final double value;

  CustomBarChartData({required this.month, required this.value});

  factory CustomBarChartData.fromJson(Map<String, dynamic> json) {
    return CustomBarChartData(
      month: json['month'] as int,
      value: (json['total_amount'] as num).toDouble(),
    );
  }
}
