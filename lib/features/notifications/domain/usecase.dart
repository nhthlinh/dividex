import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/domain/noti_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotiUseCase {
  final NotiRepository repository;

  NotiUseCase(this.repository);

  Future<PagingModel<List<NotificationModel>>> getNotifications(
    int page,
    int pageSize,
  ) {
    return repository.getNotifications(page, pageSize);
  }
}
