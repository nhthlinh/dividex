import 'package:Dividex/core/network/dio_client.dart';

import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/data/source/user_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRemoteDataSource)
class UserRemoteDatasourceImpl implements UserRemoteDataSource {
  final DioClient dio;

  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(
    String userId,
    int page,
    int pageSize,
  ) async {
    if (page == 4) return PagingModel(data: [], totalPage: 4, page: page);
    await Future.delayed(Duration(seconds: 2));
    return PagingModel(
      totalPage: 4,
      page: page,
      data: [
        UserModel(
          id: '1',
          email: 'john@example.com',
          fullName: 'John Doe',
          phoneNumber: '1234567890',
          avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
        ),
        UserModel(
          id: '2',
          email: 'jane@example.com',
          fullName: 'Jane Smith',
          phoneNumber: '0987654321',
          avatar: 'https://example.com/avatar2.png',
        ),
        UserModel(
          id: '3',
          email: 'bob@example.com',
          fullName: 'Bob Johnson',
          phoneNumber: '5555555555',
          avatar: 'https://example.com/avatar3.png',
        ),
        UserModel(
          id: '4',
          email: 'alice@example.com',
          fullName: 'Alice Williams',
          phoneNumber: '4444444444',
          avatar: 'https://example.com/avatar4.png',
        ),
        UserModel(
          id: '5',
          email: 'charlie@example.com',
          fullName: 'Charlie Brown',
          phoneNumber: '3333333333',
          avatar: 'https://example.com/avatar5.png',
        ),
      ],
    );
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(
    String groupId,
    int page,
    int pageSize,
  ) async {
    if (page == 2) return PagingModel(data: [], totalPage: 2, page: page);
    await Future.delayed(Duration(seconds: 2));
    return PagingModel(
      totalPage: 4,
      page: page,
      data: [
        UserModel(
          id: '1',
          email: 'john@example.com',
          fullName: 'John Doe',
          phoneNumber: '1234567890',
          avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
        ),
        UserModel(
          id: '2',
          email: 'jane@example.com',
          fullName: 'Jane Smith',
          phoneNumber: '0987654321',
          avatar: 'https://example.com/avatar2.png',
        ),
        UserModel(
          id: '3',
          email: 'bob@example.com',
          fullName: 'Bob Johnson',
          phoneNumber: '5555555555',
          avatar: 'https://example.com/avatar3.png',
        ),
        UserModel(
          id: '4',
          email: 'alice@example.com',
          fullName: 'Alice Williams',
          phoneNumber: '4444444444',
          avatar: 'https://example.com/avatar4.png',
        ),
        UserModel(
          id: '5',
          email: 'charlie@example.com',
          fullName: 'Charlie Brown',
          phoneNumber: '3333333333',
          avatar: 'https://example.com/avatar5.png',
        ),
      ],
    );
  }

    @override
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(
    String eventId,
    int page,
    int pageSize,
  ) async {
    if (page == 2) return PagingModel(data: [], totalPage: 2, page: page);
    await Future.delayed(Duration(seconds: 2));
    return PagingModel(
      totalPage: 2,
      page: page,
      data: [
        UserModel(
          id: '1',
          email: 'john@example.com',
          fullName: 'John Doe',
          phoneNumber: '1234567890',
          avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
        ),
        UserModel(
          id: '2',
          email: 'jane@example.com',
          fullName: 'Jane Smith',
          phoneNumber: '0987654321',
          avatar: 'https://example.com/avatar2.png',
        ),
        UserModel(
          id: '3',
          email: 'bob@example.com',
          fullName: 'Bob Johnson',
          phoneNumber: '5555555555',
          avatar: 'https://example.com/avatar3.png',
        ),
        UserModel(
          id: '4',
          email: 'alice@example.com',
          fullName: 'Alice Williams',
          phoneNumber: '4444444444',
          avatar: 'https://example.com/avatar4.png',
        ),
        UserModel(
          id: '5',
          email: 'charlie@example.com',
          fullName: 'Charlie Brown',
          phoneNumber: '3333333333',
          avatar: 'https://example.com/avatar5.png',
        ),
      ],
    );
  }

}
