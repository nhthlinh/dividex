

import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class FriendRepository {
  Future<void> sendFriendRequest(String receiverUid, String? message);
  Future<void> acceptFriendRequest(String friendshipUid);
  Future<void> declineFriendRequest(String friendshipUid);
  Future<PagingModel<List<FriendRequestModel>>> getFriendRequests(FriendRequestType type, String? search, int page, int pageSize);
  Future<PagingModel<List<FriendRequestModel>>> getFriends(String? search, int page, int pageSize);
}
