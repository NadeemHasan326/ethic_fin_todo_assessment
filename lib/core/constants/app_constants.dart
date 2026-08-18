class AppConstants {
  AppConstants._();

  static const String appName = 'Task Manager';
  static const String brandName = 'EthicFin';

  static const String hiveTaskBox = 'tasks';
  static const String hiveSettingsBox = 'settings';
  static const String hivePendingDeletesBox = 'pending_deletes';
  static const String hiveThemeKey = 'is_dark';

  static const String firestoreTasksCollection = 'tasks';

  static const String dateFormatFull = 'MMM dd, yyyy';
  static const String dateFormatShort = 'MMM dd';
  static const String dateFormatWeekday = 'EEEE, MMM dd, yyyy';

  static const int titleMinLength = 3;
  static const int descriptionMaxLength = 500;

  static String taskTitleHero(String id) => 'task-title-$id';
}
