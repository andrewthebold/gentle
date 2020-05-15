import 'package:gentle/constants.dart';
import 'package:intl/intl.dart';

String getTimeString(DateTime date) {
  final creationDate = date;

  if (creationDate == null) {
    return '';
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final sixDaysAgo = DateTime(now.year, now.month, now.day - 6);

  final aDate =
      DateTime(creationDate.year, creationDate.month, creationDate.day);
  if (aDate == today) {
    return DateFormat.jm().format(creationDate);
  } else if (aDate == yesterday) {
    return UIStrings.yesterday;
  } else if (creationDate.isAfter(sixDaysAgo)) {
    return DateFormat.EEEE().format(creationDate);
  }

  return DateFormat.yMd().format(creationDate);
}
