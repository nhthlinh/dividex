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
    return repository.createGroup(
      name: name,
      memberIds: memberIds,
    );
  }

  Future<PagingModel<List<GroupModel>>> listGroups(int page, int pageSize, String searchQuery) {
    return repository.listGroups(page, pageSize, searchQuery);
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

  Future<PagingModel<List<EventModel>>> listEvents(int page, int pageSize, String groupId, String searchQuery) {
    return repository.listEvents(page, pageSize, groupId, searchQuery);
  }
}