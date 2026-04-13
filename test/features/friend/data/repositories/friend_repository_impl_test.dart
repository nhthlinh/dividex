import 'package:Dividex/features/friend/data/models/friend_dept.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/data/repositories/friend_repository_impl.dart';
import 'package:Dividex/features/friend/data/source/friend_remote_datasource.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFriendRemoteDataSource extends Mock
    implements FriendRemoteDataSource {}

void main() {
  late FriendRemoteDataSource remoteDataSource;
  late FriendRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockFriendRemoteDataSource();
    repository = FriendRepositoryImpl(remoteDataSource);
  });

  group('FriendRepositoryImpl.sendFriendRequest', () {
    test('delegates to remote datasource', () async {
      when(
        () => remoteDataSource.sendFriendRequest(
          'user_1',
          'Hello, would you like to be my friend?',
        ),
      ).thenAnswer((_) async {});

      await repository.sendFriendRequest(
        'user_1',
        'Hello, would you like to be my friend?',
      );

      verify(
        () => remoteDataSource.sendFriendRequest(
          'user_1',
          'Hello, would you like to be my friend?',
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows when remote throws', () async {
      when(
        () => remoteDataSource.sendFriendRequest(
          'user_2',
          'Hello, would you like to be my friend?',
        ),
      ).thenThrow(Exception('send failed'));

      expect(
        () => repository.sendFriendRequest(
          'user_2',
          'Hello, would you like to be my friend?',
        ),
        throwsA(isA<Exception>()),
      );

      verify(
        () => remoteDataSource.sendFriendRequest(
          'user_2',
          'Hello, would you like to be my friend?',
        ),
      ).called(1);
    });
  });

  group('FriendRepositoryImpl.acceptFriendRequest', () {
    test('delegates to remote datasource', () async {
      when(
        () => remoteDataSource.acceptFriendRequest('request_1'),
      ).thenAnswer((_) async {});

      await repository.acceptFriendRequest('request_1');

      verify(() => remoteDataSource.acceptFriendRequest('request_1')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('rethrows remote errors', () async {
      when(
        () => remoteDataSource.acceptFriendRequest('request_2'),
      ).thenThrow(StateError('accept failed'));

      expect(
        () => repository.acceptFriendRequest('request_2'),
        throwsA(isA<StateError>()),
      );

      verify(() => remoteDataSource.acceptFriendRequest('request_2')).called(1);
    });
  });

  group('FriendRepositoryImpl.rejectFriendRequest', () {
    test('delegates to remote datasource', () async {
      when(
        () => remoteDataSource.declineFriendRequest('request_3'),
      ).thenAnswer((_) async {});

      await repository.declineFriendRequest('request_3');

      verify(
        () => remoteDataSource.declineFriendRequest('request_3'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('FriendRepositoryImpl.getFriends', () {
    test('returns paged friends', () async {
      final page = PagingModel<List<FriendModel>>(
        data: [FriendModel(friendUid: '', fullName: '')],
        totalItems: 1,
        totalPage: 1,
        page: 1,
      );

      when(
        () => remoteDataSource.getFriends('', 1, 20),
      ).thenAnswer((_) async => page);

      final result = await repository.getFriends('', 1, 20);

      expect(result.totalItems, 1);
      expect(result.data.first.friendUid, '');
      verify(() => remoteDataSource.getFriends('', 1, 20)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('returns empty page when remote returns empty', () async {
      final page = PagingModel<List<FriendModel>>(
        data: [],
        totalItems: 0,
        totalPage: 0,
        page: 1,
      );

      when(
        () => remoteDataSource.getFriends('', 1, 10),
      ).thenAnswer((_) async => page);

      final result = await repository.getFriends('', 1, 10);

      expect(result.data, isEmpty);
      expect(result.totalItems, 0);
      verify(() => remoteDataSource.getFriends('', 1, 10)).called(1);
    });
  });

  group('FriendRepositoryImpl.getFriendRequests', () {
    test('returns incoming friend requests', () async {
      final page = PagingModel<List<FriendModel>>(
        data: [FriendModel(friendUid: 'rq1', fullName: '')],
        totalItems: 1,
        totalPage: 1,
        page: 1,
      );

      when(
        () => remoteDataSource.getFriendRequests(
          FriendRequestType.received,
          '',
          1,
          10,
        ),
      ).thenAnswer((_) async => page);

      final result = await repository.getFriendRequests(
        FriendRequestType.received,
        '',
        1,
        10,
      );

      expect(result.data.length, 1);
      expect(result.data.first.friendUid, 'rq1');
      verify(
        () => remoteDataSource.getFriendRequests(
          FriendRequestType.received,
          '',
          1,
          10,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('FriendRepositoryImpl.getSentRequests', () {
    test('returns outgoing friend requests', () async {
      final page = PagingModel<List<FriendModel>>(
        data: [FriendModel(friendUid: 'sr1', fullName: 'Carol')],
        totalItems: 1,
        totalPage: 1,
        page: 1,
      );

      when(
        () => remoteDataSource.getFriendRequests(
          FriendRequestType.sent,
          '',
          1,
          10,
        ),
      ).thenAnswer((_) async => page);

      final result = await repository.getFriendRequests(
        FriendRequestType.sent,
        '',
        1,
        10,
      );

      expect(result.data.first.friendUid, 'sr1');
      verify(
        () => remoteDataSource.getFriendRequests(
          FriendRequestType.sent,
          '',
          1,
          10,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('FriendRepositoryImpl.getFriendDebt', () {
    test('returns friend debt data', () async {
      final debts = [
        FriendDept(
          value: 120.5,
          group: GroupModel(id: 'g1', name: 'Trip to Bali'),
          creditor: UserModel(id: 'u20', fullName: 'Alice'),
          debtor: UserModel(id: 'u30', fullName: 'David'),
        ),
      ];

      when(() => remoteDataSource.getFriendDepts('u30', 1, 10)).thenAnswer(
        (_) async => PagingModel<List<FriendDept>>(
          data: debts,
          totalItems: 1,
          totalPage: 1,
          page: 1,
        ),
      );

      final result = await repository.getFriendDepts('u30', 1, 10);

      expect(result.data.length, 1);
      expect(result.data.first.debtor.id, 'u30');
      expect(result.data.first.value, 120.5);
      verify(() => remoteDataSource.getFriendDepts('u30', 1, 10)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('returns empty list when remote returns empty', () async {
      when(() => remoteDataSource.getFriendDepts('u30', 1, 10)).thenAnswer((_) async => PagingModel(data: [], totalItems: 0, totalPage: 0, page: 1));

      final result = await repository.getFriendDepts('u30', 1, 10);

      expect(result.data, isEmpty);
      verify(() => remoteDataSource.getFriendDepts('u30', 1, 10)).called(1);
    });
  });
}
