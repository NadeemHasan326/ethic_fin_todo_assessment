import 'package:ethic_fin_todo_assessment/exports.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>(AppConstants.hiveTaskBox);
  await Hive.openBox(AppConstants.hiveSettingsBox);
  await Hive.openBox(AppConstants.hivePendingDeletesBox);
  await initDependencies();

  Bloc.observer = TalkerBlocObserver(talker: talker);

  talker.info('App initialized successfully');

  runApp(const TaskManagerApp());
}
