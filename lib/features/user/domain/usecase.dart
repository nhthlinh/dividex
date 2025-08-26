import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/domain/user_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserUseCase {
  final UserRepository repository;

  UserUseCase(this.repository);

  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(String userId, int page, int pageSize) {
    return repository.getUserForCreateGroup(userId, page, pageSize);
  }

  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(String groupId, int page, int pageSize) {
    return repository.getUserForCreateEvent(groupId, page, pageSize);
  }
}