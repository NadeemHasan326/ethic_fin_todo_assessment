import 'package:ethic_fin_todo_assessment/exports.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String id) => repository.deleteTask(id);
}
