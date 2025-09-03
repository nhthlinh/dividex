import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:Dividex/features/friend/data/source/friend_remote_datasource.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FriendRemoteDataSource)
class FriendRemoteDatasourceImpl implements FriendRemoteDataSource {
  final DioClient dio;

  FriendRemoteDatasourceImpl(this.dio);

  @override
  Future<void> sendFriendRequest(String receiverUid, String? message) {
    try {
      return dio.post(
        '/friends/request',
        data: {
          'receiver_uid': receiverUid,
          'message': message,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptFriendRequest(String friendshipUid) {
    return dio.post(
      '/friends/requests/$friendshipUid/accept',
    );
  }

  @override
  Future<void> declineFriendRequest(String friendshipUid) {
    try {
      return dio.delete(
        '/friends/$friendshipUid',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PagingModel<List<FriendRequestModel>>> getFriendRequests(
      FriendRequestType type, String? search, int page, int pageSize) async {
    try {
      final response = await dio.get(
        '/friends/requests',
        queryParameters: {
          'type': type == FriendRequestType.received ? 'Received' : 'Sent',
          'search': search,
          'order_by': 'updated_at',
          'page': page,
          'page_size': pageSize,
        },
      );
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => FriendRequestModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load friend requests');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PagingModel<List<FriendRequestModel>>> getFriends(
      String? search, int page, int pageSize) async {
    try {
      final response = await dio.get(
        '/friends',
        queryParameters: {
          'search': search,
          'order_by': 'updated_at',
          'page': page,
          'page_size': pageSize,
        },
      );
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => FriendRequestModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (e) {
      rethrow;
    }
  } 
}