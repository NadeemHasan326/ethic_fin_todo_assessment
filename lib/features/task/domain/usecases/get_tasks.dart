import 'package:ethic_fin_todo_assessment/exports.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<TaskEntity>> call() => repository.getTasks();
}
