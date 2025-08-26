import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EventRemoteDataSource)
class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final DioClient dio;

  EventRemoteDataSourceImpl(this.dio);

}
