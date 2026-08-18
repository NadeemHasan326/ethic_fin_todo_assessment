import 'package:ethic_fin_todo_assessment/exports.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormatFull).format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.isNegative) {
      if (diff.inDays.abs() == 0) return AppStrings.today;
      if (diff.inDays.abs() == 1) return AppStrings.yesterday;
      return AppStrings.daysAgo(diff.inDays.abs());
    }

    if (diff.inDays == 0) return AppStrings.today;
    if (diff.inDays == 1) return AppStrings.tomorrow;
    if (diff.inDays < 7) return AppStrings.inDays(diff.inDays);
    return DateFormat(AppConstants.dateFormatShort).format(date);
  }

  static bool isOverdue(DateTime date) {
    return date.isBefore(DateTime.now()) &&
        !AppDateUtils.isSameDay(date, DateTime.now());
  }
}

class AppDateUtils {
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
