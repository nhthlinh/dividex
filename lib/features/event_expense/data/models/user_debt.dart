import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

class UserDebt {
  String userId;
  double amount;

  UserDebt({required this.userId, required this.amount});

  Map<String, dynamic> toJson() {
    return {'user_uid': userId, 'amount': amount};
  }

  factory UserDebt.fromJson(Map<String, dynamic> json) {
    return UserDebt(
      userId: json['user_uid'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class UserDeptInfo {
  UserModel user;
  double amount;

  UserDeptInfo({required this.user, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      "full_name": user.fullName,
      "avatar_url": user.avatar?.toJson(),
      "uid": user.id,
      "amount": amount,
    };
  }

  factory UserDeptInfo.fromJson(Map<String, dynamic> json) {
    return UserDeptInfo(
      user: UserModel(
        fullName: json['full_name'] as String?,
        avatar: json['avatar_url'] != null
            ? ImageModel.fromJson(json['avatar_url'] as Map<String, dynamic>)
            : null,
        id: json['uid'] as String?,
      ),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
