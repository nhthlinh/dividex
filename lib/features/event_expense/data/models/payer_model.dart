import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

class PayerModel {
  final UserModel user;
  final double amount;

  PayerModel({required this.user, required this.amount});

  factory PayerModel.fromJson(Map<String, dynamic> json) {
    return PayerModel(
      user: UserModel(
        id: json['uid'] as String?,
        fullName: json['full_name'] as String?,
        avatar: json['avatar_url'] != null
            ? ImageModel.fromJson(json['avatar_url'] as Map<String, dynamic>)
            : null,
      ),
      amount: json['amount'] == null
          ? 0
          : double.tryParse(json['amount'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'amount': amount};
  }
}
