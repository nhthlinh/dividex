import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/data/source/user_remote_datasource.dart';
import 'package:Dividex/features/user/domain/user_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(String userId, int page, int pageSize) {
    return remoteDataSource.getUserForCreateGroup(userId, page, pageSize);
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(String groupId, int page, int pageSize) {
    return remoteDataSource.getUserForCreateEvent(groupId, page, pageSize);
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(String eventId, int page, int pageSize) {
    return remoteDataSource.getUserForCreateExpense(eventId, page, pageSize);
  }
}
