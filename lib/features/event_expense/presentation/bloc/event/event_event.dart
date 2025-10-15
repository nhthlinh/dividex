class EventEvent {}

class CreateEventEvent extends EventEvent {
  final String name;
  final String groupId;
  final String eventStart;
  final String? eventEnd;
  final String? description;
  final List<String>? memberIds;

  CreateEventEvent({
    required this.name,
    required this.groupId,
    required this.eventStart,
    this.eventEnd,
    this.description,
    this.memberIds,
  });
}

class UpdateEventEvent extends EventEvent {
  final String eventId;
  final String name;
  final String eventStart;
  final String? eventEnd;
  final String? description;

  UpdateEventEvent({
    required this.eventId,
    required this.name,
    required this.eventStart,
    this.eventEnd,
    this.description,
  });
}

class GetEventEvent extends EventEvent {
  final String eventId;

  GetEventEvent({required this.eventId});
}

class DeleteEventEvent extends EventEvent {
  final String eventId;

  DeleteEventEvent({required this.eventId});
}

class JoinEvent extends EventEvent {
  final String eventId;
  final String userId;

  JoinEvent({required this.eventId, required this.userId});
}

class AddMembersToEvent extends EventEvent {
  final String eventId;
  final List<String> memberIds;

  AddMembersToEvent({required this.eventId, required this.memberIds});
}

class InitialEvent extends EventEvent {
  int page;
  int pageSize;
  String searchQuery;
  String orderBy;
  String sortType;

  InitialEvent({
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
  });
}

class LoadMoreEventsGroups extends EventEvent {
  int page;
  int pageSize;
  String searchQuery;
  String orderBy;
  String sortType;

  LoadMoreEventsGroups({
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
  });
}

class RefreshEventsGroups extends EventEvent {
  int page;
  int pageSize;
  String searchQuery;
  String orderBy;
  String sortType;

  RefreshEventsGroups({
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery = "",
    this.orderBy = "updated_at",
    this.sortType = "asc",
  });
}
