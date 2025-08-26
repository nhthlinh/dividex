import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/domain/group_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GroupUseCase {
  final GroupRepository repository;

  GroupUseCase(this.repository);

  Future<PagingModel<List<GroupModel>>> getUserGroups(String userId, int page, int pageSize) {
    return repository.getUserGroups(userId, page, pageSize);
  }
}