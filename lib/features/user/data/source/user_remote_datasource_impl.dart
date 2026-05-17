import 'package:Dividex/core/network/dio_client.dart';

import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/data/source/user_remote_datasource.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/services/local/models/user_local_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRemoteDataSource)
class UserRemoteDatasourceImpl implements UserRemoteDataSource {
  final DioClient dio;

  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(
    String userId,
    int page,
    int pageSize,
    String? searchQuery,
  ) async {
    try {
      final response = await dio.get(
        '/friends',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'search': searchQuery,
          'order_by': 'updated_at',
        },
      );
      // if ((response.data['data']['content'] as List).isNotEmpty) {
      //   return PagingModel.fromJson(
      //     response.data,
      //     (jsonList) => (jsonList['content'] as List)
      //         .map((item) => UserModel.fromJson(item))
      //         .toList(),
      //   );
      // } else {
      //   throw Exception('Failed to load users');
      // }
      final content = (response.data['data']['content'] as List?) ?? [];

      return PagingModel.fromJson(
        response.data,
        (jsonList) => content.map((item) => UserModel.fromJson(item)).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(
    String groupId,
    int page,
    int pageSize,
    String? searchQuery,
  ) async {
    final response = await dio.get(
      '/groups/$groupId/members',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        'search': searchQuery,
        'order_by': 'updated_at',
      },
    );
    // if ((response.data['data']['content'] as List).isNotEmpty) {
    //   return PagingModel.fromJson(
    //     response.data,
    //     (jsonList) => (jsonList['content'] as List)
    //         .map((item) => UserModel.fromJson(item['user']))
    //         .toList(),
    //   );
    // } else {
    //   throw Exception('Failed to load users');
    // }
    final content = (response.data['data']['content'] as List?) ?? [];

    return PagingModel.fromJson(
      response.data,
      (jsonList) => content.map((item) => UserModel.fromJson(item['user'])).toList(),
    );
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(
    String eventId,
    int page,
    int pageSize,
    String? searchQuery, {
    String orderBy = "full_name",
    String sortType = "asc",
  }) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/events/$eventId/members',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'search': searchQuery,
          'order_by': orderBy,
          'sort_type': sortType,
        },
      );
      // if ((response.data['data']['content'] as List).isNotEmpty) {
      //   return PagingModel.fromJson(
      //     response.data,
      //     (jsonList) => (jsonList['content'] as List)
      //         .map((item) => UserModel.fromJson(item['user']))
      //         .toList(),
      //   );
      // } else {
      //   throw Exception('Failed to load users');
      // }

      final content = (response.data['data']['content'] as List?) ?? [];

      return PagingModel.fromJson(
        response.data,
        (jsonList) => content.map((item) => UserModel.fromJson(item['user'])).toList(),
      );
    });
  }

  @override
  Future<UserModel> getMe() async {
    return apiCallWrapper(() async {
      final response = await dio.get('/auth/me');
      final newUser = UserModel.fromJson(response.data['data']);

      await HiveService.saveUser(
        UserLocalModel(
          id: newUser.id ?? '',
          email: newUser.email ?? '',
          fullName: newUser.fullName ?? '',
          avatarUrl: newUser.avatar,
          phoneNumber: newUser.phoneNumber ?? '',
        ),
      );

      return newUser;
    });
  }

  @override
  Future<void> reviewApp(int stars) async {
    return apiCallWrapper(() async {
      await dio.put('/users/review', data: {'rate': stars});
    });
  }

  @override
  Future<void> updateMe(String name, CurrencyEnum currency) async {
    return apiCallWrapper(() async {
      final response = await dio.put('/auth/me', data: {'full_name': name});
      final newUser = UserModel.fromJson(response.data['data']);

      await HiveService.saveUser(
        UserLocalModel(
          id: newUser.id ?? '',
          email: newUser.email ?? '',
          fullName: newUser.fullName ?? '',
          avatarUrl: newUser.avatar,
          phoneNumber: newUser.phoneNumber ?? '',
        ),
      );
    });
  }

  @override
  Future<void> createPin(String pin) async {
    return apiCallWrapper(() async {
      await dio.post('/auth/pin', data: {'pin': pin});
    });
  }

  @override
  Future<void> updatePin(String oldPin, String newPin) async {
    return apiCallWrapper(() async {
      await dio.put('/auth/pin', data: {'old_pin': oldPin, 'new_pin': newPin});
    });
  }
}
