import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

DateTime convertDateTimeByLocale(DateTime original, AppLocalizations intl) {
  final locale = intl.localeName;

  final isOriginalInUtc = original.isUtc;
  final originalInLocal = isOriginalInUtc ? original : original.toUtc();

  if (locale.startsWith('vi')) {
    // Chuyển sang giờ Việt Nam (+7)
    return originalInLocal.add(const Duration(hours: 7));
  } else if (locale.startsWith('en')) {
    // Chuyển sang UTC (0)
    return originalInLocal;
  } else {
    return original; // mặc định không đổi
  }
}


String getTimeAgo(DateTime dateTime, AppLocalizations intl) {

  final localizedDate = convertDateTimeByLocale(dateTime, intl);
  final Duration diff = convertDateTimeByLocale(DateTime.now(), intl).difference(localizedDate);

  if (diff.inDays > 365) {
    return DateFormat('MMM dd, yyyy').format(localizedDate);
  } else if (diff.inDays > 30) {
    return DateFormat('MMM dd').format(localizedDate);
  } else if (diff.inDays > 7) {
    return '${(diff.inDays / 7).floor()} ${intl.week} ${intl.ago}';
  } else if (diff.inDays > 0) {
    return '${diff.inDays} ${intl.day} ${intl.ago}';
  } else if (diff.inHours > 0) {
    return '${diff.inHours} ${intl.hour} ${intl.ago}';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes} ${intl.minute} ${intl.ago}';
  } else {
    return intl.justNow;
  }
}

DateTime parseUTCToVN(String raw) {
  final dt = DateTime.parse(raw); // parse ra UTC
  return dt.add(Duration(hours: 7)); // convert sang UTC+7
}
