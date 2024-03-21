import 'package:intl/intl.dart';

String formatDateStringForLastOnline(String originalDateString) {
  DateTime originalDate =
      DateFormat('yyyy-MM-dd HH:mm').parse(originalDateString);
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  bool isToday = originalDate.year == today.year &&
      originalDate.month == today.month &&
      originalDate.day == today.day;

  bool isYesterday = originalDate.year == today.year &&
      originalDate.month == today.month &&
      originalDate.day == today.day - 1;

  if (isToday) {
    return 'Today ${DateFormat('HH:mm').format(originalDate)}';
  } else if (isYesterday) {
    return 'Yesterday ${DateFormat('HH:mm').format(originalDate)}';
  } else {
    return DateFormat('dd MMM yy HH:mm').format(originalDate);
  }
}

String formatDateStringForDateOfBirth(String originalDateString) {
  DateTime originalDate = DateFormat('dd/MM/yyyy').parse(originalDateString);
  return DateFormat('dd MMM yy').format(originalDate);
}
