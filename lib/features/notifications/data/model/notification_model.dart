// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart'
    as event_event;
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/get_time_ago.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum NotiType {
  FRIEND_REQUEST("FRIEND_REQUEST", "Friend Request"),
  FRIEND_ACCEPTED("FRIEND_ACCEPTED", "Friend Accepted"),
  REMINDER("REMINDER", "Reminder"),

  TRANSFER("TRANSFER", "Transfer"),
  DEPOSIT("DEPOSIT", "Deposit"),
  WITHDRAW("WITHDRAW", "Withdraw"),
  GROUP_CREATED("GROUP_CREATED", "Group Created"),
  GROUP_UPDATED("GROUP_UPDATED", "Group Updated"),
  GROUP_LEFT("GROUP_LEFT", "Group Left"),

  EVENT_CREATED("EVENT_CREATED", "Event Created"),
  EVENT_UPDATED("EVENT_UPDATED", "Event Updated"),
  EVENT_DELETED("EVENT_DELETED", "Event Deleted"),
  EXPENSE_CREATED("EXPENSE_CREATED", "Expense Created"),
  EXPENSE_UPDATED("EXPENSE_UPDATED", "Expense Updated"),
  EXPENSE_RESTORED("EXPENSE_RESTORED", "Expense Restored"),
  EXPENSE_SOFT_DELETED("EXPENSE_SOFT_DELETED", "Expense Soft Deleted"),
  EXPENSE_HARD_DELETED("EXPENSE_HARD_DELETED", "Expense Hard Deleted");

  final String code;
  final String description;

  const NotiType(this.code, this.description);

  static NotiType fromString(String code) {
    return NotiType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw Exception('Invalid NotiType code: $code'),
    );
  }

  Future<void> goToRelatedPage(
    String relatedUid,
    BuildContext context,
    UserModel fromUser,
  ) async {
    final intl = AppLocalizations.of(context)!;

    switch (this) {
      case NotiType.FRIEND_REQUEST:
      case NotiType.FRIEND_ACCEPTED:
        context.pushNamed(
          AppRouteNames.friendProfile,
          pathParameters: {'id': fromUser.id ?? ''},
        );
        break;

      case NotiType.REMINDER:
        // Navigate to reminders page
        break;

      case NotiType.TRANSFER:
      case NotiType.DEPOSIT:
      case NotiType.WITHDRAW:
        context.pushNamed(AppRouteNames.walletReport);
        break;

      case NotiType.GROUP_CREATED:
      case NotiType.GROUP_UPDATED:
      case NotiType.GROUP_LEFT:
        {
          final bloc = context.read<GroupBloc>();
          final completer = Completer<GroupModel?>();
          late final StreamSubscription<GroupState> subscription;

          subscription = bloc.stream.listen((state) {
            if (state is GroupReportState) {
              completer.complete(state.groupReport);
              subscription.cancel(); // bây giờ hợp lệ
            }
          });

          bloc.add(GetSimpleDetailGroupEvent(relatedUid));

          final group = await completer.future;
          if (group != null) {
            context.pushNamed(
              AppRouteNames.groupDetail,
              pathParameters: {'groupId': relatedUid},
              extra: {
                'groupName': group.name ?? '',
                'groupAvatarUrl': group.avatarUrl?.publicUrl ?? '',
                'leaderId': group.leader?.id ?? '',
              },
            );
          } else {
            showCustomToast(intl.groupNotFound, type: ToastType.error);
          }
        }
        break;

      case NotiType.EVENT_CREATED:
      case NotiType.EVENT_UPDATED:
        {
          final bloc = context.read<EventBloc>();
          final completer = Completer<EventModel?>();
          late final StreamSubscription<EventState> subscription;

          subscription = bloc.stream.listen((state) {
            if (state is EventLoadedState) {
              completer.complete(state.event);
              subscription.cancel();
            }
          });

          bloc.add(event_event.GetEventEvent(eventId: relatedUid));

          final event = await completer.future;
          if (event != null) {
            context.goNamed(
              AppRouteNames.eventReport,
              pathParameters: {
                'eventId': relatedUid,
                'groupId': event.group ?? '',
              },
              extra: {'eventName': event.name ?? ''},
            );
          } else {
            showCustomToast(intl.groupNotFound, type: ToastType.error);
          }
        }
        break;

      case NotiType.EVENT_DELETED:
        break;

      case NotiType.EXPENSE_CREATED:
      case NotiType.EXPENSE_UPDATED:
      case NotiType.EXPENSE_RESTORED:
      case NotiType.EXPENSE_SOFT_DELETED:
        context.pushNamed(
          AppRouteNames.expenseDetail,
          pathParameters: {"id": relatedUid},
        );
        break;

      case NotiType.EXPENSE_HARD_DELETED:
        break;
    }
  }
}

class NotificationModel {
  final UserModel fromUser;
  final String uid;
  final DateTime createdAt;
  final String content;
  final NotiType type;
  final String relatedUid;
  final List<String> toUsers;

  NotificationModel({
    required this.fromUser,
    required this.uid,
    required this.createdAt,
    required this.content,
    required this.type,
    required this.relatedUid,
    required this.toUsers,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      fromUser: UserModel.fromJson(json['from_user']),
      uid: json['uid'],
      createdAt: parseUTCToVN(json['created_at']),
      content: json['content'],
      type: NotiType.fromString(json['type']),
      relatedUid: json['related_uid'],
      toUsers: List<String>.from(json['to_users']),
    );
  }

  NotificationModel copyWith({
    UserModel? fromUser,
    String? uid,
    DateTime? createdAt,
    String? content,
    NotiType? type,
    String? relatedUid,
    List<String>? toUsers,
  }) {
    return NotificationModel(
      fromUser: fromUser ?? this.fromUser,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      type: type ?? this.type,
      relatedUid: relatedUid ?? this.relatedUid,
      toUsers: toUsers ?? this.toUsers,
    );
  }
}
