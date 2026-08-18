import 'package:ethic_fin_todo_assessment/exports.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getUnsyncedTasks();
  Future<void> addPendingDelete(String id);
  Future<void> removePendingDelete(String id);
  Future<List<String>> getPendingDeletes();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  Future<Box<TaskModel>> get _box async =>
      Hive.isBoxOpen(AppConstants.hiveTaskBox)
          ? Hive.box<TaskModel>(AppConstants.hiveTaskBox)
          : await Hive.openBox<TaskModel>(AppConstants.hiveTaskBox);

  Future<Box> get _pendingDeletesBox async =>
      Hive.isBoxOpen(AppConstants.hivePendingDeletesBox)
          ? Hive.box(AppConstants.hivePendingDeletesBox)
          : await Hive.openBox(AppConstants.hivePendingDeletesBox);

  @override
  Future<List<TaskModel>> getTasks() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final box = await _box;
    await box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final box = await _box;
    final map = {for (final t in tasks) t.id: t};
    await box.putAll(map);
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    final box = await _box;
    return box.values.where((t) => !t.isSynced).toList();
  }

  @override
  Future<void> addPendingDelete(String id) async {
    final box = await _pendingDeletesBox;
    await box.put(id, id);
  }

  @override
  Future<void> removePendingDelete(String id) async {
    final box = await _pendingDeletesBox;
    await box.delete(id);
  }

  @override
  Future<List<String>> getPendingDeletes() async {
    final box = await _pendingDeletesBox;
    return box.keys.map((key) => key.toString()).toList();
  }
}
