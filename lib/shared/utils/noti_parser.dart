import 'package:Dividex/config/l10n/app_localizations.dart';

class NotificationParser {
  final AppLocalizations intl;

  NotificationParser(this.intl);

  String parse(String message) {
    // Tất cả pattern backend gửi về
    final patterns = <RegExp, String Function(RegExpMatch)>{
      RegExp(r"(.+) have updated an event (.+)") : (m) =>
        intl.eventUpdated(m[1]!, m[2]!),

      RegExp(r"(.+) have created an event (.+)") : (m) =>
        intl.eventCreated(m[1]!, m[2]!),

      RegExp(r"(.+) have deleted an event (.+)") : (m) =>
        intl.eventDeleted(m[1]!, m[2]!),

      RegExp(r"(.+) have restored an expense (.+)") : (m) =>
        intl.expenseRestored(m[1]!, m[2]!),

      RegExp(r"(.+) have deleted an expense (.+)") : (m) =>
        intl.expenseDeleted(m[1]!, m[2]!),

      RegExp(r"(.+) have updated an expense (.+)") : (m) =>
        intl.expenseUpdated(m[1]!, m[2]!),

      RegExp(r"(.+) have created an expense (.+)") : (m) =>
        intl.expenseCreated(m[1]!, m[2]!),

      RegExp(r"(.+) accepted your friend request") : (m) =>
        intl.friendAccepted(m[1]!),

      RegExp(r"(.+) has sent you a friend request\. message: (.+)") : (m) =>
        intl.friendRequestNoti(m[1]!, m[2]!),

      RegExp(r"You have received a friend request from (.+)") : (m) =>
        intl.friendRequestToMe(m[1]!),

      RegExp(r"(.+) is new leader of group (.+)") : (m) =>
        intl.leaderChanged(m[1]!, m[2]!),

      RegExp(r"(.+) have updated a group (.+)") : (m) =>
        intl.groupUpdated(m[1]!, m[2]!),

      RegExp(r"You have deposited (.+) (.+)") : (m) =>
        intl.deposit(m[1]!, m[2]!),
    };

    for (final entry in patterns.entries) {
      final match = entry.key.firstMatch(message);
      if (match != null) {
        return entry.value(match);
      }
    }

    // Không match được → trả nguyên bản
    return message;
  }
}
