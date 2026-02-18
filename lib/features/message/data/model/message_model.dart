import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/get_time_ago.dart';

class Message {
  final UserModel? user;
  final String? id;         // Socket dùng id
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? content;
  final String? status;
  final List<String>? attachment;
  final String? groupId;    // chỉ có trong socket
  final String? type;       // socket gửi type = "message"

  Message({
    this.user,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.content,
    this.status,
    this.attachment,
    this.groupId,
    this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      id: json["id"] ?? json["uid"],                       // Socket
      createdAt: json["created_at"] != null
          ? parseUTCToVN(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? parseUTCToVN(json["updated_at"])
          : null,
      content: json["content"],
      status: json["status"],
      attachment: json["attachment"] != null
          ? List<String>.from(json["attachment"])
          : null,
      groupId: json["group_id"],            // Socket
      type: json["type"],                   // Socket ("message")
    );
  }

  Message copyWith({
    UserModel? user,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? content,
    String? status,
    List<String>? attachment,
    String? groupId,
    String? type,
  }) {
    return Message(
      user: user ?? this.user,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      status: status ?? this.status,
      attachment: attachment ?? this.attachment,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
    );
  }
}
