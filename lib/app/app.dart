import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TaskBloc>()),
        BlocProvider.value(value: sl<ThemeCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: AppSizes.designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                onGenerateRoute: AppRouter.onGenerateRoute,
                initialRoute: AppRouter.splash,
                builder: (context, child) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness:
                          isDark ? Brightness.light : Brightness.dark,
                      statusBarBrightness:
                          isDark ? Brightness.dark : Brightness.light,
                    ),
                  );
                  return GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: child,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
