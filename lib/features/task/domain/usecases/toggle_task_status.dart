import 'package:ethic_fin_todo_assessment/exports.dart';

class ToggleTaskStatus {
  final TaskRepository repository;

  ToggleTaskStatus(this.repository);

  Future<void> call(String id) => repository.toggleTaskStatus(id);
}
