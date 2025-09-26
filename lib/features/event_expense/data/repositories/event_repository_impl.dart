import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart';
import 'package:Dividex/features/event_expense/domain/event_repository.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createEvent({
    required String name,
    required String groupId,
    required String eventStart,
    String? eventEnd,
    String? description,
    List<String>? memberIds,
  }) async {
    return await remoteDataSource.createEvent(
      name: name,
      groupId: groupId,
      eventStart: eventStart,
      eventEnd: eventEnd,
      description: description,
      memberIds: memberIds,
    );
  }
  
  @override
  Future<EventModel?> getEvent(String eventId) async {
    return await remoteDataSource.getEvent(eventId);
  }

  @override
  Future<void> updateEvent({
    required String eventId,
    String? name,
    String? eventStart,
    String? eventEnd,
    String? description,
  }) async {
    return await remoteDataSource.updateEvent(
      eventId: eventId,
      name: name,
      eventStart: eventStart,
      eventEnd: eventEnd,
      description: description,
    );
  }

  @override
  Future<void> joinEvent(String eventId, String userId) async {
    return await remoteDataSource.joinEvent(eventId, userId);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    return await remoteDataSource.deleteEvent(eventId);
  }

  @override
  Future<PagingModel<List<GroupModel>>> listEventsGroups(
    int page,
    int pageSize,
    String searchQuery, {
    String orderBy = "name",
    String sortType = "asc",
  }) async {
    return await remoteDataSource.listEventsGroups(
      page,
      pageSize,
      searchQuery,
      orderBy: orderBy,
      sortType: sortType,
    );
  }
}
