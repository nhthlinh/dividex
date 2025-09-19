enum FriendStatus { none, accepted }

class FriendModel {
  final String friendUid;
  final String fullName;
  final String avatarUrl;
  final String? friendshipUid;
  final String? messageRequest;
  final FriendStatus? status;
  final String? info;

  FriendModel({
    required this.friendUid,
    required this.fullName,
    required this.avatarUrl,
    this.friendshipUid,
    this.messageRequest,
    this.status,
    this.info,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      friendUid: json['friend_uid'] ?? json['uid'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'] ?? '',
      friendshipUid: json['friendship_uid'] as String?,
      messageRequest: json['message_request'] as String?,
      status: json['status'] == 'ACCEPTED'
          ? FriendStatus.accepted
          : FriendStatus.none,
      info: json['info'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_uid': friendUid,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'friendship_uid': friendshipUid,
      'message_request': messageRequest,
      'status': status == FriendStatus.accepted ? 'ACCEPTED' : 'NONE',
      'info': info,
    };
  }
}
