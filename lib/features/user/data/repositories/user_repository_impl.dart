import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/data/source/user_remote_datasource.dart';
import 'package:Dividex/features/user/domain/user_repository.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(String userId, int page, int pageSize, String? searchQuery) {
    return remoteDataSource.getUserForCreateGroup(userId, page, pageSize, searchQuery);
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(String groupId, int page, int pageSize, String? searchQuery) {
    return remoteDataSource.getUserForCreateEvent(groupId, page, pageSize, searchQuery);
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(String eventId, int page, int pageSize, String? searchQuery, {String orderBy = "full_name", String sortType = "asc"}) {
    return remoteDataSource.getUserForCreateExpense(eventId, page, pageSize, searchQuery, orderBy: orderBy, sortType: sortType);
  }

  @override
  Future<UserModel> getMe() {
    return remoteDataSource.getMe();
  }

  @override
  Future<void> updateMe(String name, CurrencyEnum currency) {
    return remoteDataSource.updateMe(name, currency);
  }

  @override
  Future<void> createPin(String pin) {
    return remoteDataSource.createPin(pin);
  }

  @override
  Future<void> updatePin(String oldPin, String newPin) {
    return remoteDataSource.updatePin(oldPin, newPin);
  }

  @override
  Future<void> reviewApp(int stars) {
    return remoteDataSource.reviewApp(stars);
  }
}
