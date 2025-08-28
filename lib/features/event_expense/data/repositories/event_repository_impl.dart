import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart';
import 'package:Dividex/features/event_expense/domain/event_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagingModel<List<EventModel>>> getEvents(int groupId, int page, int pageSize) async {
    return await remoteDataSource.getEvents(groupId, page, pageSize);
  }

}
