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
  Future<PagingModel<List<GroupModel>>> getUserGroups(String userId, int page, int pageSize) {
    return remoteDataSource.getUserGroups(userId, page, pageSize);
  }

}
