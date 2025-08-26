import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class LoadedUsersState extends Equatable {
  const LoadedUsersState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.users = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final List<UserModel> users;

  bool get hasMore => page < totalPage;

  @override
  List<Object?> get props => [isLoading, page, totalPage, users];

  LoadedUsersState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    List<UserModel>? users,
  }) {
    return LoadedUsersState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      users: users ?? this.users,
    );
  }
}
