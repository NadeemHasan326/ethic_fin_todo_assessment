import 'package:ethic_fin_todo_assessment/exports.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({
    required Widget page,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppDurations.page,
          reverseTransitionDuration: AppDurations.pageReverse,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: AppMotion.pageSlideBegin,
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}
