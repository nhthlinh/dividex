
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class FriendRemoteDataSource {
  Future<void> sendFriendRequest(String receiverUid, String? message);
  Future<void> acceptFriendRequest(String friendshipUid);
  Future<void> declineFriendRequest(String friendshipUid);
  Future<PagingModel<List<FriendModel>>> getFriendRequests(FriendRequestType type, String? search, int page, int pageSize);
  Future<PagingModel<List<FriendModel>>> getFriends(String? search, int page, int pageSize);
  Future<PagingModel<List<FriendModel>>> searchUsers(String? search, int page, int pageSize);
}
