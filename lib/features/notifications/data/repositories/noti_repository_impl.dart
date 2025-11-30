import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/data/source/noti_remote_data_source.dart';
import 'package:Dividex/features/notifications/domain/noti_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotiRepository)
class NotiRepositoryImpl implements NotiRepository {
  final NotiRemoteDataSource remoteDataSource;

  NotiRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagingModel<List<NotificationModel>>> getNotifications(
    int page,
    int pageSize,
  ) {
    return remoteDataSource.getNotifications(page, pageSize);
  }
}
