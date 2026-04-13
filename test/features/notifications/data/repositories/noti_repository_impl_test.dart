import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/data/repositories/noti_repository_impl.dart';
import 'package:Dividex/features/notifications/data/source/noti_remote_data_source.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotiRemoteDataSource extends Mock implements NotiRemoteDataSource {}

void main() {
  late NotiRemoteDataSource remoteDataSource;
  late NotiRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockNotiRemoteDataSource();
    repository = NotiRepositoryImpl(remoteDataSource);
  });

  test('getNotifications delegates and returns paging model', () async {
    final page = PagingModel<List<NotificationModel>>(
      data: <NotificationModel>[],
      page: 1,
      totalPage: 1,
      totalItems: 0,
    );
    when(() => remoteDataSource.getNotifications(1, 20)).thenAnswer((_) async => page);

    final result = await repository.getNotifications(1, 20);

    expect(result.page, 1);
    expect(result.totalItems, 0);
    verify(() => remoteDataSource.getNotifications(1, 20)).called(1);
  });
}
