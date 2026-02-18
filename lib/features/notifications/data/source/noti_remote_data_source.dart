import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class NotiRemoteDataSource {
  Future<PagingModel<List<NotificationModel>>> getNotifications(
    int page,
    int pageSize,
  );
}
