import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart';
import 'package:Dividex/features/event_expense/domain/event_repository.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

}
