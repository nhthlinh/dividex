import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:Dividex/features/friend/data/source/friend_remote_datasource.dart';
import 'package:Dividex/features/friend/domain/friend_repository.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FriendRepository)
class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDataSource remoteDataSource;

  FriendRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendFriendRequest(String receiverUid, String? message) {
    return remoteDataSource.sendFriendRequest(receiverUid, message);
  }

  @override
  Future<void> acceptFriendRequest(String friendshipUid) {
    return remoteDataSource.acceptFriendRequest(friendshipUid);
  }

  @override
  Future<void> declineFriendRequest(String friendshipUid) {
    return remoteDataSource.declineFriendRequest(friendshipUid);
  }

  @override
  Future<PagingModel<List<FriendRequestModel>>> getFriendRequests(FriendRequestType type, String? search, int page, int pageSize) {
    return remoteDataSource.getFriendRequests(type, search, page, pageSize);
  }

  @override
  Future<PagingModel<List<FriendRequestModel>>> getFriends(String? search, int page, int pageSize) {
    return remoteDataSource.getFriends(search, page, pageSize);
  }
}