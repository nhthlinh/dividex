

import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class EventRepository {
  Future<PagingModel<List<EventModel>>> getEvents(int groupId, int page, int pageSize);
}
