class FriendRequestModel {
  final String friendUid;
  final String fullName;
  final String avatarUrl; 
  final String friendshipUid;
  final String messageRequest;

  FriendRequestModel({
    required this.friendUid,
    required this.fullName,
    required this.avatarUrl,
    required this.friendshipUid,
    required this.messageRequest,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      friendUid: json['friend_uid'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      friendshipUid: json['friendship_uid'],
      messageRequest: json['message_request'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_uid': friendUid,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'friendship_uid': friendshipUid,
      'message_request': messageRequest,
    };
  }
}
