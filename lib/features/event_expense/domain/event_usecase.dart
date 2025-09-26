import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/domain/event_repository.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class EventUseCase {
  final EventRepository repository;

  EventUseCase(this.repository);

  Future<String> createEvent(
    String name,
    String groupId,
    String eventStart,
    String? eventEnd,
    String? description,
    List<String>? memberIds,
  ) async {
    return await repository.createEvent(
      name: name,
      groupId: groupId,
      eventStart: eventStart,
      eventEnd: eventEnd,
      description: description,
      memberIds: memberIds,
    );
  }

  Future<EventModel?> getEvent(String eventId) async {
    return await repository.getEvent(eventId);
  }

  Future<void> updateEvent(
    String eventId,
    String? name,
    String? eventStart,
    String? eventEnd,
    String? description,
  ) async {
    await repository.updateEvent(
      eventId: eventId,
      name: name,
      eventStart: eventStart,
      eventEnd: eventEnd,
      description: description,
    );
  }

  Future<void> deleteEvent(String eventId) async {
    await repository.deleteEvent(eventId);
  }

  Future<void> joinEvent(String eventId, String userId) async {
    await repository.joinEvent(eventId, userId);
  } 

  Future<PagingModel<List<GroupModel>>> listEventsGroups(int page, int pageSize, String searchQuery, {String orderBy = "name", String sortType = "asc"}) async {
    return await repository.listEventsGroups(page, pageSize, searchQuery, orderBy: orderBy, sortType: sortType);
  }
}
