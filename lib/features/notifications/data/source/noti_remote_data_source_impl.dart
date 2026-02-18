import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/data/source/noti_remote_data_source.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotiRemoteDataSource)
class NotiRemoteDatasourceImpl implements NotiRemoteDataSource {
  final DioClient dio;

  NotiRemoteDatasourceImpl(this.dio);

  @override
  Future<PagingModel<List<NotificationModel>>> getNotifications(
    int page,
    int pageSize,
  ) async {
    return apiCallWrapper(
      () async {
        final response = await dio.get(
          '/notifications',
          queryParameters: {
            'page': page,
            'page_size': pageSize,
          },
        );
        
        return PagingModel.fromJson(
        response.data,
        (jsonList) => (jsonList['content'] as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList(),
      );
      },
    );
  }
}
