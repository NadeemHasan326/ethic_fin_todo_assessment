import 'package:ethic_fin_todo_assessment/exports.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(TaskEntity task) => repository.updateTask(task);
}
