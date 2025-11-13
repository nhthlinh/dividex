import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class UserRepository {
  Future<PagingModel<List<UserModel>>> getUserForCreateGroup(
    String userId,
    int page,
    int pageSize,
    String? searchQuery,
  );
  Future<PagingModel<List<UserModel>>> getUserForCreateEvent(
    String groupId,
    int page,
    int pageSize,
    String? searchQuery,
  );
  Future<PagingModel<List<UserModel>>> getUserForCreateExpense(
    String eventId,
    int page,
    int pageSize,
    String? searchQuery, {
    String orderBy = "full_name",
    String sortType = "asc",
  });

  Future<UserModel> getMe();
  Future<void> updateMe(String name, CurrencyEnum currency);
  Future<void> createPin(String pin);
  Future<void> updatePin(String oldPin, String newPin);
}
