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
    String? searchQuery,
  ) async {
    try {
      final response = await dio.get(
        '/friends',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'search': searchQuery,
          'order_by': 'updated_at',
        },
      );
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => UserModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(
    String groupId,
    int page,
    int pageSize,
    String? searchQuery,
  ) async {
    final response = await dio.get(
        '/groups/$groupId/members',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'search': searchQuery,
          'order_by': 'updated_at',
        },
      );
      if (response.data['content'] != []) {
        return PagingModel.fromJson(
          response.data,
          (jsonList) => (jsonList['content'] as List)
              .map((item) => UserModel.fromJson(item))
              .toList(),
        );
      } else {
        throw Exception('Failed to load users');
      }
    }

  @override
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(
    String eventId,
    int page,
    int pageSize,
    String? searchQuery,
  ) async {
    if (searchQuery == 'm') {
      return PagingModel(
        totalItems: 4,
        data: [
          UserModel(
            id: '1',
            email: 'john@example.com',
            fullName: 'John Doe',
            phoneNumber: '1234567890',
            hasDebt: true,
            amount: 20.000,
            avatar:
                'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
          ),
        ],
        totalPage: 1,
        page: page,
      );
    }
    if (page == 2) return PagingModel(data: [], totalPage: 2, page: page, totalItems: 5);
    await Future.delayed(Duration(seconds: 2));
    return PagingModel(
      totalItems: 10,
      totalPage: 2,
      page: page,
      data: [
        UserModel(
          id: '1',
          email: 'john@example.com',
          fullName: 'John Doe',
          phoneNumber: '1234567890',
          hasDebt: false,
          amount: 25000,
          avatar:
              'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTIT_-HE1YngzdgKr-c3OjckZg3pwZyInO-fGyyfDeTbP0wjryiJ95ABdIOzDJRDhxkMR1LI_-LzS_aYMdkisnol6ZbTZjdos8mGJVnV2-2',
        ),
        UserModel(
          id: '2',
          email: 'jane@example.com',
          fullName: 'Jane Smith',
          phoneNumber: '0987654321',
          hasDebt: false,
          amount: 25000,
          avatar: 'https://example.com/avatar2.png',
        ),
        UserModel(
          id: '3',
          email: 'bob@example.com',
          fullName: 'Bob Johnson',
          phoneNumber: '5555555555',
          hasDebt: false,
          amount: 25000,
          avatar: 'https://example.com/avatar3.png',
        ),
        UserModel(
          id: '4',
          email: 'alice@example.com',
          fullName: 'Alice Williams',
          phoneNumber: '4444444444',
          hasDebt: false,
          amount: 25000,
          avatar: 'https://example.com/avatar4.png',
        ),
        UserModel(
          id: '5',
          email: 'charlie@example.com',
          fullName: 'Charlie Brown',
          phoneNumber: '3333333333',
          hasDebt: false,
          amount: 25000,
          avatar: 'https://example.com/avatar5.png',
        ),
      ],
    );
  }
}
