import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';

import 'package:Dividex/features/group/data/source/group_remote_datasource.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDatasourceImpl implements GroupRemoteDataSource {
  final DioClient dio;

  GroupRemoteDatasourceImpl(this.dio);

  @override
  Future<String> createGroup({
    required String name,
    required List<String> memberIds,
  }) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/groups',
        data: {'name': name, 'list_user_uids': memberIds},
      );
      return response.data['data']['uid'] as String;
    });
  }

  @override
  Future<String> updateGroup({
    required String groupId,
    required String name,
    required List<String> addMemberIds,
    required List<String> deleteMemberIds,
  }) {
    return apiCallWrapper(() async {
      final response = await dio.put(
        '/groups/$groupId',
        data: {'name': name, 'list_add_uids': addMemberIds, 'list_delete_uids': deleteMemberIds},
      );
      return response.data['data']['uid'] as String;
    });
  }

  @override
  Future<GroupModel?> getGroupDetail(String groupId) async {
    return apiCallWrapper(() async {
      final response = await dio.get('/groups/$groupId');
      if (response.data['data'] == null) {
        return null;
      }
      return GroupModel.fromDetailJson(response.data['data']);
    });
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    return apiCallWrapper(() async {
      await dio.delete('/groups/$groupId');
    });
  }

  @override
  Future<void> leaveGroup(String groupId) async {
    return apiCallWrapper(() async {
      await dio.put('/groups/$groupId/leave');
    });
  }

  @override
  Future<PagingModel<List<EventModel>>> listEvents(
    int page,
    int pageSize,
    String groupId,
    String searchQuery,
  ) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/groups/$groupId/events',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      return PagingModel.fromJson(
        response.data,
        (jsonList) => (jsonList['content'] as List)
            .map((item) => EventModel.fromJson(item))
            .toList(),
      );
    });
  }

  @override
  Future<PagingModel<List<GroupModel>>> listGroups(
    int page,
    int pageSize,
    String searchQuery,
  ) {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/groups',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      return PagingModel.fromJson(
        response.data,
        (jsonList) => (jsonList['content'] as List)
            .map((item) => GroupModel.fromJson(item))
            .toList(),
      );
    });
  }
  
  @override
  Future<void> updateGroupLeader(String groupId, String newLeaderId) async {
    return apiCallWrapper(() async {
      await dio.put(
        '/groups/$groupId/leader',
        data: {'new_leader': newLeaderId},
      );
    });
  }

  @override
  Future<PagingModel<List<GroupModel>>> listGroupsWithDetail(
    int page,
    int pageSize,
    String searchQuery,
  ) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/groups/balance-members', 
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'order_by': 'updated_at',
          'sort_type': 'desc',
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      return PagingModel.fromJson(
        response.data,
        (jsonList) => (jsonList['content'] as List)
            .map((item) => GroupModel.fromJson(item))
            .toList(),
      );
    });
  }

  @override
  Future<GroupModel?> getGroupReport(String groupId) async {
    return apiCallWrapper(() async {
      final response = await dio.get('/groups/$groupId/report');
      if (response.data['data'] == null) {
        return null;
      }
      return GroupModel.fromReportJson(response.data['data']);
    });
  }

  @override
  Future<List<ChartData>> getChartData(String groupId) async {
    return apiCallWrapper(() async {
      final response = await dio.get('/groups/$groupId/members-report');
      if (response.data['data'] == null) {
        return [];
      }
      return (response.data['data'] as List)
          .map((item) => ChartData.fromJson(item))
          .toList();
    });
  }
}
