import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';

import 'package:Dividex/features/group/data/source/group_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDatasourceImpl implements GroupRemoteDataSource {
  final DioClient dio;

  GroupRemoteDatasourceImpl(this.dio);

  @override
  Future<PagingModel<List<GroupModel>>> getUserGroups(
    String userId,
    int page,
    int pageSize,
  ) async {
    try {
      final response = await dio.get(
        '/groups',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          // sai api
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final groups = (data['content'] as List)
          .map((e) => GroupModel.fromJson(e))
          .toList();

      return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => GroupModel.fromJson(item))
              .toList(),
        );

      // return PagingModel<List<GroupModel>>(
      //   data: groups,
      //   page: data['current_page'],
      //   totalPage: data['total_pages'],
      //   totalItems: data['total_items'],
      // );
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      rethrow;
    }
  }

  @override
  Future<void> createGroup({
    required String name,
    required String avatarPath,
    required List<String> memberIds,
  }) async {
    try {
      await dio.post(
        '/groups',
        data: {'name': name, 'list_user_uids': memberIds},
      );

      // Note: avatarPath is not sent to the server as per the original code
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editGroup({
    required String groupId,
    required String name,
    required String avatarPath,
    required List<String> memberIds,
  }) async {
    try {
      await dio.put(
        '/groups/$groupId',
        data: {
          'name': name,
          'avatar_url': avatarPath,
          'list_user_uid': memberIds,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
