import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/get_time_ago.dart';

enum FriendStatus { none, response, pending, accepted }

class FriendModel {
  final String friendUid;
  final String fullName;
  final ImageModel? avatarUrl;
  final String? friendshipUid;
  final String? messageRequest;
  final FriendStatus? status;
  final DateTime? startedAt;
  final String? info;

  FriendModel({
    required this.friendUid,
    required this.fullName,
    this.avatarUrl,
    this.friendshipUid,
    this.messageRequest,
    this.status,
    this.info,
    this.startedAt,
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
      startedAt: json['start'] == null
          ? json['date_joined'] == null
              ? null
              : parseUTCToVN(json['date_joined'] as String)
          : parseUTCToVN(json['start'] as String),
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

class FriendOverviewModel {
  final UserModel friend;
  final String? message;
  final String? status;
  final String? friendshipUid;
  final int mutualGroups;
  final int sharedEvents;
  final int sharedExpenses;
  final double totalDebt;

  FriendOverviewModel({
    required this.friend,
    this.message,
    this.status,
    this.friendshipUid,
    required this.mutualGroups,
    required this.sharedEvents,
    required this.sharedExpenses,
    required this.totalDebt,
  });

  factory FriendOverviewModel.fromJson(Map<String, dynamic> json) {
    return FriendOverviewModel(
      friend: UserModel.fromJson(json['friend'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: json['status'] as String?,
      friendshipUid: json['friendship_uid'] as String?,
      mutualGroups: json['mutual_groups'] ?? 0,
      sharedEvents: json['shared_events'] ?? 0,
      sharedExpenses: json['shared_expenses'] ?? 0,
      totalDebt: (json['total_debt'] != null)
          ? double.tryParse(json['total_debt'].toString()) ?? 0.0
          : 0.0,
    );
  }
}
