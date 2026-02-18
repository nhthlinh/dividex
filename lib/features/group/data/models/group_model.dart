import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/get_time_ago.dart';
import 'package:json_annotation/json_annotation.dart';

class GroupModel {
  final String? id;
  final String? name;
  final UserModel? leader;
  final StatusEnum? status;
  final ImageModel? avatarUrl;
  final DateTime? createdAt;
  final List<GroupMemberModel>? members;
  final List<EventModel>? events;

  // Additional fields for detailed view
  final String? eventAttended;
  final String? sharedExpenses;
  final double? totalAmount;
  final double? userSpent;
  final List<RestructuredDebtModel>? restructuredDebt;

  // Additional fields for report view can be added here
  final int? eventsTotal;
  final int? membersTotal;
  final int? sharedExpensesTotal;

  GroupModel({
    this.id,
    this.name,
    this.avatarUrl,
    this.createdAt,
    this.members,
    this.leader,
    this.status,
    this.events,
    this.eventAttended,
    this.sharedExpenses,
    this.totalAmount,
    this.userSpent,
    this.restructuredDebt,
    this.eventsTotal,
    this.membersTotal,
    this.sharedExpensesTotal,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['uid'] as String?,
      name: json['name'] as String? ?? json['group_name'] as String?,
      avatarUrl: json['avatar_url'] != null
          ? ImageModel.fromJson(json['avatar_url'] as Map<String, dynamic>)
          : (json['group_avatar_url'] != null
                ? ImageModel.fromJson( json['group_avatar_url'])
                : null),
      createdAt: json['createdAt'] == null
          ? null
          : parseUTCToVN(json['createdAt'] as String),
      members: (json['group_members'] as List<dynamic>?)
          ?.map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      //leader: json['leader'] == null ? null : json['leader'] as String,
      leader: json['leader'] == null
          ? null
          : UserModel.fromJson(json['leader'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$StatusEnumEnumMap, json['status']),
      events:
          (json['events'] as List<dynamic>? ??
                  json['list_event'] as List<dynamic>?)
              ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  factory GroupModel.fromDetailJson(Map<String, dynamic> json) {
    final groupJson = json['group'] as Map<String, dynamic>?;

    return GroupModel(
      id: groupJson?['uid'] as String?,
      name: groupJson?['name'] as String?,
      avatarUrl: groupJson?['avatar_url'] != null
          ? ImageModel.fromJson(
              groupJson?['avatar_url'] as Map<String, dynamic>,
            )
          : null,
      leader: groupJson?['leader'] != null
          ? UserModel.fromJson(groupJson!['leader'] as Map<String, dynamic>)
          : null,
      eventAttended: json['event_attended'] as String?,
      sharedExpenses: json['shared_expenses'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      userSpent: (json['user_spent'] as num?)?.toDouble(),
      restructuredDebt: (json['restructured_debt'] as List<dynamic>?)
          ?.map(
            (e) => RestructuredDebtModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  factory GroupModel.fromReportJson(Map<String, dynamic> json) {
    final groupJson = json['group'] as Map<String, dynamic>?;

    return GroupModel(
      id: groupJson?['uid'] as String?,
      name: groupJson?['name'] as String?,
      avatarUrl: groupJson?['avatar_url'] != null
          ? ImageModel.fromJson(
              groupJson?['avatar_url'] as Map<String, dynamic>,
            )
          : null,
      leader: groupJson?['leader'] != null
          ? UserModel.fromJson(groupJson!['leader'] as Map<String, dynamic>)
          : null,
      eventsTotal: json['events'] as int?,
      sharedExpensesTotal: json['shared_expenses'] as int?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(), 
      membersTotal: json['members'] as int?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': id,
    'name': name,
    'leader': leader,
    'status': _$StatusEnumEnumMap[status],
    'avatar_url': avatarUrl,
    'createdAt': createdAt?.toIso8601String(),
    'members': members,
    'events': events,
  };
}

const _$StatusEnumEnumMap = {
  StatusEnum.active: 'active',
  StatusEnum.deleted: 'deleted',
};

class RestructuredDebtModel {
  final UserModel? debtor;
  final UserModel? creditor;
  final double? value;

  RestructuredDebtModel({this.debtor, this.creditor, this.value});

  factory RestructuredDebtModel.fromJson(Map<String, dynamic> json) {
    return RestructuredDebtModel(
      debtor: json['debtor'] != null
          ? UserModel.fromJson(json['debtor'] as Map<String, dynamic>)
          : null,
      creditor: json['creditor'] != null
          ? UserModel.fromJson(json['creditor'] as Map<String, dynamic>)
          : null,
      value: (json['value'] as num?)?.toDouble(),
    );
  }
}
