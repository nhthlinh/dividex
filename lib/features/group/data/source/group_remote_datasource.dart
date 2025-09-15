
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class GroupRemoteDataSource {
  Future<PagingModel<List<GroupModel>>> getUserGroups(String userId, int page, int pageSize);
  Future<void> createGroup({
    required String name,
    required String avatarPath,
    required List<String> memberIds,
  });
  Future<void> editGroup({
    required String groupId,
    required String name,
    required String avatarPath,
    required List<String> memberIds,
  });
}
