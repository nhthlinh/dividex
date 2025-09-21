import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EventRemoteDataSource)
class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final DioClient dio;

  EventRemoteDataSourceImpl(this.dio);

  @override
  Future<PagingModel<List<EventModel>>> getEvents(int groupId, int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 1));
    if (page > 1) {
      return PagingModel(page: page, totalPage: 1, data: [], totalItems: 2);
    }
    return PagingModel(page: page, totalPage: 1, data: [
      EventModel(id: '1', name: 'Event 1'),
      EventModel(id: '2', name: 'Event 2'),
    ], totalItems: 2);
  }

}
