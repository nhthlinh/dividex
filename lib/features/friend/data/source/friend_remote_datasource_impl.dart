import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/friend/data/models/friend_dept.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/data/source/friend_remote_datasource.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FriendRemoteDataSource)
class FriendRemoteDatasourceImpl implements FriendRemoteDataSource {
  final DioClient dio;

  FriendRemoteDatasourceImpl(this.dio);

  @override
  Future<void> sendFriendRequest(String receiverUid, String? message) {
    return apiCallWrapper(() {
      return dio.post(
        '/friends/request',
        data: {'receiver_uid': receiverUid, 'message': message},
      );
    });
  }

  @override
  Future<void> acceptFriendRequest(String friendshipUid) {
    return apiCallWrapper(() {
      return dio.put('/friends/$friendshipUid/accept');
    });
  }

  @override
  Future<void> declineFriendRequest(String friendshipUid) {
    return apiCallWrapper(() {
      return dio.delete('/friends/$friendshipUid/remove');
    });
  }

  @override
  Future<PagingModel<List<FriendModel>>> getFriendRequests(
    FriendRequestType type,
    String? search,
    int page,
    int pageSize,
  ) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/friends/request',
        queryParameters: {
          'request_type': type == FriendRequestType.received
              ? 'Received'
              : 'Sent',
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
              .map((item) => FriendModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load friend requests');
      }
    });
  }

  @override
  Future<PagingModel<List<FriendModel>>> getFriends(
    String? search,
    int page,
    int pageSize,
  ) async {
    return apiCallWrapper(() async {
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
              .map((item) => FriendModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load friends');
      }
    });
  }

  @override
  Future<PagingModel<List<FriendModel>>> searchUsers(
    String? search,
    int page,
    int pageSize,
  ) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/users',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'search': search,
        },
      );
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => FriendModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load users');
      }
    });
  }

  @override
  Future<PagingModel<List<UserModel>>> listMutualFriends(String friendshipUid, int page, int pageSize) async {
    return apiCallWrapper(() async {
      final response = await dio.get('/friends/$friendshipUid/mutual', queryParameters: {
        'page': page,
        'page_size': pageSize,
      });
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => UserModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load mutual friends');
      }
    });
  }

  @override
  Future<FriendOverviewModel> getFriendOverview(String id) {
    return apiCallWrapper(() async {
      final response = await dio.get('/friends/{$id}');
      if (response.data != null) {
        return FriendOverviewModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load friend overview');
      }
    });
  }

  @override
  Future<PagingModel<List<FriendDept>>> getFriendDepts(String friendId, int page, int pageSize) async {
    return apiCallWrapper(() async {
      final response = await dio.get('/friends/$friendId/debt', queryParameters: {
        'page': page,
        'page_size': pageSize,
      });
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => FriendDept.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load friend depts');
      }
    });
  }
}
