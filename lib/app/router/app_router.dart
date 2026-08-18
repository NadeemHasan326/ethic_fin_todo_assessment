import 'package:ethic_fin_todo_assessment/exports.dart';

class AppRouter {
  static const String splash = '/';
  static const String taskList = '/tasks';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return AppPageRoute(page: const SplashPage(), settings: settings);
      case taskList:
        return AppPageRoute(page: const TaskListPage(), settings: settings);
      default:
        return AppPageRoute(
          page: const Scaffold(
            body: Center(child: Text(AppStrings.pageNotFound)),
          ),
          settings: settings,
        );
    }
  }
}
