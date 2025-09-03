import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:Dividex/features/friend/domain/friend_repository.dart';
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

  Future<PagingModel<List<FriendRequestModel>>> getFriendRequests(FriendRequestType type, String? search, int page, int pageSize) async {
    return await repository.getFriendRequests(type, search, page, pageSize);
  }

  Future<PagingModel<List<FriendRequestModel>>> getFriends(String? search, int page, int pageSize) async {
    return await repository.getFriends(search, page, pageSize);
  }
}