import 'package:ethic_fin_todo_assessment/exports.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity> getTaskById(String id);
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskStatus(String id);
  Future<void> syncTasks();
}
