class UserDebt {
  String userId;
  double amount;

  UserDebt({
    required this.userId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_uid': userId,
      'amount': amount,
    };
  }

  factory UserDebt.fromJson(Map<String, dynamic> json) {
    return UserDebt(
      userId: json['user_uid'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
