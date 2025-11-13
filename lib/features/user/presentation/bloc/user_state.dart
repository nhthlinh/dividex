import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class LoadedUsersState extends Equatable {
  const LoadedUsersState({
    this.isLoading = true,
    this.page = 1,
    this.totalPage = 0,
    this.totalItems = 0,
    this.users = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<UserModel> users;

  @override
  List<Object?> get props => [isLoading, page, totalPage, totalItems, users];

  LoadedUsersState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<UserModel>? users,
  }) {
    return LoadedUsersState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalItems: totalItems ?? this.totalItems,
      users: users ?? this.users,
    );
  }
}

class UserState {
  UserModel? user;

  UserState({this.user});
}
