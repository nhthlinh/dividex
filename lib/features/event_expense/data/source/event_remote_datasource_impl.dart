import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@Injectable(as: EventRemoteDataSource)
class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final DioClient dio;

  EventRemoteDataSourceImpl(this.dio);

  @override
  Future<String> createEvent({
    required String name,
    required String groupId,
    required String eventStart,
    String? eventEnd,
    String? description,
    List<String>? memberIds,
  }) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/events',
        data: {
          'name': name,
          'group_id': groupId,
          'event_start': eventStart,
          if (eventEnd != null) 'event_end': eventEnd,
          if (description != null) 'description': description,
          if (memberIds != null) 'list_user_uid': memberIds,
        },
      );

      return response.data['data']['uid'] as String;
    });
  }

  // @override
  // Future<PagingModel<List<EventModel>>> getEvent(
  //   int groupId,
  //   int page,
  //   int pageSize,
  // ) async {
  //   final response = await dio.get(
  //     '/events',
  //     queryParameters: {
  //       'groupId': groupId,
  //       'page': page,
  //       'pageSize': pageSize,
  //     },
  //   );

  //   final data = response.data as Map<String, dynamic>;
  //   final events = (data['items'] as List)
  //       .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
  //       .toList();
  //   final totalItems = data['totalItems'] as int;
  //   final totalPages = data['totalPages'] as int;

  //   return PagingModel(
  //     data: events,
  //     totalItems: totalItems,
  //     totalPage: totalPages,
  //     page: page,
  //   );
  // }

  @override
  Future<EventModel?> getEvent(String eventId) {
    return apiCallWrapper(() async {
      final response = await dio.get('/events/$eventId');
      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return EventModel.fromJson(data);
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> updateEvent({
    required String eventId,
    String? name,
    String? eventStart,
    String? eventEnd,
    String? description,
  }) async {
    await dio.put(
      '/events/$eventId',
      data: {
        if (name != null) 'name': name,
        if (eventStart != null) 'event_start': eventStart,
        if (eventEnd != null) 'event_end': eventEnd,
        if (description != null) 'description': description,
      },
    );
  }

  @override
  Future<void> joinEvent(String eventId, String userId) async {
    return apiCallWrapper(() {
      return dio.post('/events/$eventId/join', data: {'userId': userId});
    });
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    return apiCallWrapper(() {
      return dio.delete('/events/$eventId');
    });
  }

  @override
  Future<PagingModel<List<GroupModel>>> listEventsGroups(
    int page,
    int pageSize,
    String searchQuery, {
    String orderBy = "name",
    String sortType = "asc",
  }) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/events-groups',
        queryParameters: {
          if (searchQuery.isNotEmpty) 'search': searchQuery,
          if (orderBy.isNotEmpty) 'orderBy': orderBy,
          if (sortType.isNotEmpty) 'sortType': sortType,
          if (page > 0) 'page': page,
          if (pageSize > 0) 'pageSize': pageSize,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final events = (data['data'] as List)
          .map((item) => GroupModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return PagingModel(
        data: events,
        totalItems: events.length,
        totalPage: 1,
        page: page,
      );
    });
  }

  @override
  Future<void> addMembersToEvent(String eventId, List<String> userIds) async {
    return apiCallWrapper(() async {
      await dio.post(
        '/events/$eventId/add',
        data: {
          'user_uids': userIds,
        },
      );
    });
  }
}
