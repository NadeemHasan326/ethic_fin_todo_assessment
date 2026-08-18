import 'package:ethic_fin_todo_assessment/exports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => ToggleTaskStatus(sl()));
  sl.registerLazySingleton(() => SyncTasks(sl()));

  // BLoC
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      toggleTaskStatus: sl(),
      syncTasks: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ThemeCubit(Hive.box(AppConstants.hiveSettingsBox)),
  );
}
