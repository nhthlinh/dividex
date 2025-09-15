enum FriendRequestStatus {
  none,
  accepted,
}

class FriendRequestModel {
  final String friendUid;
  final String fullName;
  final String avatarUrl; 
  final String? friendshipUid;
  final String? messageRequest;
  final bool? hasDebt;
  final double? amount;
  final FriendRequestStatus? status;

  FriendRequestModel({
    required this.friendUid,
    required this.fullName,
    required this.avatarUrl,
    this.friendshipUid,
    this.messageRequest,
    this.hasDebt,
    this.amount,
    this.status,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      friendUid: json['friend_uid'] ?? json['uid'],
      fullName: json['full_name'], 
      avatarUrl: json['avatar_url'] ?? '',
      friendshipUid: json['friendship_uid'] as String?,
      messageRequest: json['message_request'] as String?,
      hasDebt: json['has_debt'] as bool?,
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'] == 'ACCEPTED'
          ? FriendRequestStatus.accepted
          : FriendRequestStatus.none,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_uid': friendUid,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'friendship_uid': friendshipUid,
      'message_request': messageRequest,
      'has_debt': hasDebt,
      'amount': amount,
      'status': status == FriendRequestStatus.accepted ? 'ACCEPTED' : 'NONE',
    };
  }
}
