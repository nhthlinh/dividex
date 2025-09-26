import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class EventRemoteDataSource {
  Future<String> createEvent({
    required String name,
    required String groupId,
    required String eventStart,
    String? eventEnd,
    String? description,
    List<String>? memberIds,
  });

  Future<EventModel?> getEvent(String eventId);

  Future<void> updateEvent({
    required String eventId,
    String? name,
    String? eventStart,
    String? eventEnd,
    String? description,
  });

  Future<void> joinEvent(String eventId, String userId);
  Future<void> deleteEvent(String eventId);

  Future<PagingModel<List<GroupModel>>> listEventsGroups(
    int page,
    int pageSize,
    String searchQuery, {
    String orderBy = "name",
    String sortType = "asc",
  });
}
