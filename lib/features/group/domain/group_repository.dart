
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class GroupRepository {
  Future<PagingModel<List<GroupModel>>> getUserGroups(String userId, int page, int pageSize);
}
