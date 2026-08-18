import 'package:ethic_fin_todo_assessment/exports.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<void> call(TaskEntity task) => repository.createTask(task);
}
