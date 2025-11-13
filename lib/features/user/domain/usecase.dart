import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/domain/user_repository.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserUseCase {
  final UserRepository repository;

  UserUseCase(this.repository);

  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(
    String userId,
    int page,
    int pageSize,
    String? searchQuery,
  ) {
    return repository.getUserForCreateGroup(
      userId,
      page,
      pageSize,
      searchQuery,
    );
  }

  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(
    String groupId,
    int page,
    int pageSize,
    String? searchQuery,
  ) {
    return repository.getUserForCreateEvent(
      groupId,
      page,
      pageSize,
      searchQuery,
    );
  }

  // List event members
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(
    String eventId,
    int page,
    int pageSize,
    String? searchQuery, {
    String orderBy = "full_name",
    String sortType = "asc",
  }) {
    return repository.getUserForCreateExpense(
      eventId,
      page,
      pageSize,
      searchQuery,
      orderBy: orderBy,
      sortType: sortType,
    );
  }

  Future<UserModel> getMe() {
    return repository.getMe();
  }

  Future<void> updateMe(String name, CurrencyEnum currency) {
    return repository.updateMe(name, currency);
  }

  Future<void> createPin(String pin) {
    return repository.createPin(pin);
  }

  Future<void> updatePin(String oldPin, String newPin) {
    return repository.updatePin(oldPin, newPin);
  }
}
