import 'package:ethic_fin_todo_assessment/exports.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._box) : super(_read(_box));

  final Box _box;

  static ThemeMode _read(Box box) {
    final isDark = box.get(AppConstants.hiveThemeKey, defaultValue: false) == true;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark => state == ThemeMode.dark;

  void toggle() {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    _box.put(AppConstants.hiveThemeKey, next == ThemeMode.dark);
    emit(next);
  }
}
