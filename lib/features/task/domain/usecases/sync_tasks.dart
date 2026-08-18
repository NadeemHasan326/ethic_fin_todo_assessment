import 'package:ethic_fin_todo_assessment/exports.dart';

class SyncTasks {
  final TaskRepository repository;

  SyncTasks(this.repository);

  Future<void> call() => repository.syncTasks();
}
