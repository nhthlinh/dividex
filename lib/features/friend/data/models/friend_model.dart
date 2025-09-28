import 'package:Dividex/features/image/data/models/image_model.dart';

enum FriendStatus { none, response, pending, accepted }

class FriendModel {
  final String friendUid;
  final String fullName;
  final ImageModel? avatarUrl;
  final String? friendshipUid;
  final String? messageRequest;
  final FriendStatus? status;
  final String? info;

  FriendModel({
    required this.friendUid,
    required this.fullName,
    this.avatarUrl,
    this.friendshipUid,
    this.messageRequest,
    this.status,
    this.info,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      friendUid: json['friend_uid'] ?? json['uid'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'] != null
          ? ImageModel.fromJson(json['avatar_url'] as Map<String, dynamic>)
          : null,
      friendshipUid: json['friendship_uid'] as String?,
      messageRequest: json['message_request'] as String?,
      status: json['status'] == 'ACCEPTED'
          ? FriendStatus.accepted
          : json['status'] == 'PENDING'
            ? FriendStatus.pending
            : json['status'] == 'RESPONSE'
              ? FriendStatus.response
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
      'status': status == FriendStatus.accepted
          ? 'ACCEPTED'
          : status == FriendStatus.pending
            ? 'PENDING'
            : status == FriendStatus.response
              ? 'RESPONSE'
              : 'NONE',
      'info': info,
    };
  }
}
