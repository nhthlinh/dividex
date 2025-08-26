
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class UserRepository {
  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(String userId, int page, int pageSize);
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(String groupId, int page, int pageSize);
}
