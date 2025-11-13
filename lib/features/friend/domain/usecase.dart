import 'package:Dividex/features/friend/data/models/friend_dept.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/domain/friend_repository.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

enum FriendRequestStatus { pending, accepted, declined }
enum FriendRequestType { received, sent }

@injectable
class FriendUseCase {
  final FriendRepository repository;

  FriendUseCase(this.repository);

  Future<void> sendFriendRequest(String receiverUid, String? message) async {
    await repository.sendFriendRequest(receiverUid, message);
  }

  Future<void> acceptFriendRequest(String friendshipUid) async {
    await repository.acceptFriendRequest(friendshipUid);
  }

  Future<void> declineFriendRequest(String friendshipUid) async {
    await repository.declineFriendRequest(friendshipUid);
  }

  Future<PagingModel<List<FriendModel>>> getFriendRequests(FriendRequestType type, String? search, int page, int pageSize) async {
    return await repository.getFriendRequests(type, search, page, pageSize);
  }

  Future<PagingModel<List<FriendModel>>> getFriends(String? search, int page, int pageSize) async {
    return await repository.getFriends(search, page, pageSize);
  }

  Future<PagingModel<List<FriendModel>>> searchUsers(String? search, int page, int pageSize) async {
    return await repository.searchUsers(search, page, pageSize);
  }
  Future<PagingModel<List<UserModel>>> listMutualFriends(String friendshipUid, int page, int pageSize) async {
    return await repository.listMutualFriends(friendshipUid, page, pageSize);
  }

  Future<FriendOverviewModel> getFriendOverview(String id) async {
    return await repository.getFriendOverview(id);
  }

  Future<PagingModel<List<FriendDept>>> getFriendDepts(String friendId, int page, int pageSize) async {
    return await repository.getFriendDepts(friendId, page, pageSize);
  }


}