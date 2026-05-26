import 'package:Dividex/features/image/data/models/image_model.dart';

class ExpenseApprovalModel {
  final int? totalMembers;
  final int? acceptedCount;
  final int? declinedCount;
  final int? pendingCount;
  final int? threshold;

  final DateTime? expiresAt;
  final String? actionType;

  final List<ApprovalUserModel>? acceptedUsers;
  final List<ApprovalUserModel>? declinedUsers;
  final List<ApprovalUserModel>? pendingUsers;

  ExpenseApprovalModel({
    this.totalMembers,
    this.acceptedCount,
    this.declinedCount,
    this.pendingCount,
    this.threshold,
    this.expiresAt,
    this.actionType,
    this.acceptedUsers,
    this.declinedUsers,
    this.pendingUsers,
  });

  factory ExpenseApprovalModel.fromJson(Map<String, dynamic> json) {
    return ExpenseApprovalModel(
      totalMembers: json["total_members"],
      acceptedCount: json["accepted_count"],
      declinedCount: json["declined_count"],
      pendingCount: json["pending_count"],
      threshold: json["threshold"],

      expiresAt: json["expires_at"] != null
          ? DateTime.parse(json["expires_at"])
          : null,

      actionType: json["action_type"],

      acceptedUsers: (json["accepted_users"] as List?)
          ?.map((e) => ApprovalUserModel.fromJson(e))
          .toList(),

      declinedUsers: (json["declined_users"] as List?)
          ?.map((e) => ApprovalUserModel.fromJson(e))
          .toList(),

      pendingUsers: (json["pending_users"] as List?)
          ?.map((e) => ApprovalUserModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_members": totalMembers,
      "accepted_count": acceptedCount,
      "declined_count": declinedCount,
      "pending_count": pendingCount,
      "threshold": threshold,
      "expires_at": expiresAt?.toIso8601String(),
      "action_type": actionType,

      "accepted_users": acceptedUsers?.map((e) => e.toJson()).toList(),

      "declined_users": declinedUsers?.map((e) => e.toJson()).toList(),

      "pending_users": pendingUsers?.map((e) => e.toJson()).toList(),
    };
  }
}

class ApprovalUserModel {
  final String? uid;
  final String? fullName;
  final ImageModel? avatar;
  final DateTime? votedAt;

  ApprovalUserModel({this.uid, this.fullName, this.avatar, this.votedAt});

  factory ApprovalUserModel.fromJson(Map<String, dynamic> json) {
    return ApprovalUserModel(
      uid: json["uid"],
      fullName: json["full_name"],

      avatar: json["avatar_url"] != null
          ? ImageModel.fromJson(json["avatar_url"])
          : null,

      votedAt: json["voted_at"] != null
          ? DateTime.parse(json["voted_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "full_name": fullName,
      "avatar_url": avatar?.toJson(),
      "voted_at": votedAt?.toIso8601String(),
    };
  }
}
