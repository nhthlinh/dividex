import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';

import 'package:Dividex/features/group/data/source/group_remote_datasource.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDatasourceImpl implements GroupRemoteDataSource {
  final DioClient dio;

  GroupRemoteDatasourceImpl(this.dio);

    @override
  Future<PagingModel<List<GroupModel>>> getUserGroups(
    String userId,
    int page,
    int pageSize,
  ) async {
    if (page == 3) return PagingModel(data: [], totalPage: 3, page: page);
    await Future.delayed(Duration(seconds: 2));
    return PagingModel(
      totalPage: 2,
      page: page,
      data: [
        GroupModel(
          id: '1',
          name: 'Group 1',
          avatarUrl: 'https://example.com/group1.png',
          createdAt: DateTime.fromMicrosecondsSinceEpoch(1622548800000),
          members: [
            GroupMemberModel(
              id: '1',
              user: UserModel(
                id: '1',
                email: 'john@example.com',
                fullName: 'John Doe',
                phoneNumber: '1234567890',
                hasDebt: false,
                amount: 23000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: false,
              amount: 23000,
            ),
            GroupMemberModel(
              id: '1',
              user: UserModel(
                id: '2',
                email: 'john@example.com',
                fullName: 'jnfik',
                phoneNumber: '1234567890',
                hasDebt: false,
                amount: 40000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: false,
              amount: 40000,
            ),
            GroupMemberModel(
              id: '3',
              user: UserModel(
                id: '3',
                email: 'john@example.com',
                fullName: 'jnfik',
                phoneNumber: '1234567890',
                hasDebt: true,
                amount: 40000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: true,
              amount: 40000,
            ),
          ],
          leader: UserModel(
            id: '1',
            email: 'john@example.com',
            fullName: 'John Doe',
            phoneNumber: '1234567890',
            hasDebt: false,
            amount: 23000,
            avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
          ),
          status: StatusEnum.active,
          events: [
            EventModel(
              id: '1',
              name: 'Event 1',
              description: 'Description 1',
              groupId: '1'
            ),
            EventModel(
              id: '2',
              name: 'Event 2',
              description: 'Description 2',
              groupId: '1'
            ),
          ],
        ),
        GroupModel(
          id: '2',
          name: 'Group 2',
          avatarUrl: 'https://example.com/group2.png',
          createdAt: DateTime.fromMicrosecondsSinceEpoch(1622548800000),
          members: [
            GroupMemberModel(
              id: '1',
              user: UserModel(
                id: '1',
                email: 'john@example.com',
                fullName: 'John Doe',
                phoneNumber: '1234567890',
                hasDebt: false,
                amount: 23000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: false,
              amount: 23000,
            ),
            GroupMemberModel(
              id: '1',
              user: UserModel(
                id: '2',
                email: 'john@example.com',
                fullName: 'jnfik',
                phoneNumber: '1234567890',
                hasDebt: false,
                amount: 40000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: false,
              amount: 40000,
            ),
            GroupMemberModel(
              id: '3',
              user: UserModel(
                id: '3',
                email: 'john@example.com',
                fullName: 'jnfik',
                phoneNumber: '1234567890',
                hasDebt: true,
                amount: 40000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: true,
              amount: 40000,
            ),
          ],
          leader: UserModel(
            id: '2',
            email: 'jane@example.com',
            fullName: 'Jane Doe',
            phoneNumber: '0987654321',
            hasDebt: false,
            amount: 43000,
            avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
          ),
          status: StatusEnum.active,
          events: [
            EventModel(
              id: '3',
              name: 'Event 3',
              description: 'Description 3',
              groupId: '2',
            ),
          ],
        ),
        GroupModel(
          id: '3',
          name: 'Group 3',
          avatarUrl: 'https://example.com/group3.png',
          createdAt: DateTime.fromMicrosecondsSinceEpoch(1622548800000),
          members: [
            GroupMemberModel(
              id: '1',
              user: UserModel(
                id: '1',
                email: 'john@example.com',
                fullName: 'John Doe',
                phoneNumber: '1234567890',
                hasDebt: false,
                amount: 23000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: false,
              amount: 23000,
            ),
            GroupMemberModel(
              id: '1',
              user: UserModel(
                id: '2',
                email: 'john@example.com',
                fullName: 'jnfik',
                phoneNumber: '1234567890',
                hasDebt: false,
                amount: 40000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: false,
              amount: 40000,
            ),
            GroupMemberModel(
              id: '3',
              user: UserModel(
                id: '3',
                email: 'john@example.com',
                fullName: 'jnfik',
                phoneNumber: '1234567890',
                hasDebt: true,
                amount: 40000,
                avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
              ),
              hasDebt: true,
              amount: 40000,
            ),
          ],
          leader: UserModel(
            id: '3',
            email: 'alice@example.com',
            fullName: 'Alice Smith',
            phoneNumber: '1122334455',
            hasDebt: false,
            amount: 2000,
            avatar: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
          ),
          status: StatusEnum.active,
          events: [
            EventModel(
              id: '4',
              name: 'Event 4',
              description: 'Description 4',
              groupId: '3',
            ),
          ],
        )
      ],
    );
  }

}
