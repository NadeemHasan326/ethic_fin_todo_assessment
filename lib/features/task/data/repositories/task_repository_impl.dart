import 'dart:async';

import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<TaskEntity>> getTasks() async {
    final localTasks = await localDataSource.getTasks();
    talker.debug('Loaded ${localTasks.length} tasks from local storage');
    return localTasks.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TaskEntity> getTaskById(String id) async {
    final model = await localDataSource.getTaskById(id);
    if (model != null) return model.toEntity();
    talker.error('Task not found: $id');
    throw Exception(AppStrings.taskNotFound);
  }

  @override
  Future<void> createTask(TaskEntity task) async {
    final isOnline = await networkInfo.isConnected;
    final unsyncedTask = task.copyWith(isSynced: false);
    final model = TaskModel.fromEntity(unsyncedTask);

    await localDataSource.saveTask(model);
    talker.info('Task created locally: ${task.title}');

    if (isOnline) {
      unawaited(_pushCreate(model, unsyncedTask));
    }
  }

  Future<void> _pushCreate(TaskModel model, TaskEntity task) async {
    try {
      await remoteDataSource.createTask(model);
      await localDataSource.saveTask(
        TaskModel.fromEntity(task.copyWith(isSynced: true)),
      );
      talker.info('Task synced to Firestore: ${task.title}');
    } catch (e, st) {
      talker.handle(e, st, 'Failed to sync task to Firestore');
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final isOnline = await networkInfo.isConnected;
    final unsyncedTask = task.copyWith(isSynced: false);
    final model = TaskModel.fromEntity(unsyncedTask);

    await localDataSource.saveTask(model);
    talker.info('Task updated locally: ${task.title}');

    if (isOnline) {
      unawaited(_pushUpdate(model, unsyncedTask));
    }
  }

  Future<void> _pushUpdate(TaskModel model, TaskEntity task) async {
    try {
      await remoteDataSource.updateTask(model);
      await localDataSource.saveTask(
        TaskModel.fromEntity(task.copyWith(isSynced: true)),
      );
      talker.info('Task update synced: ${task.title}');
    } catch (e, st) {
      talker.handle(e, st, 'Failed to sync task update');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
    await localDataSource.addPendingDelete(id);
    talker.info('Task deleted locally: $id');

    if (await networkInfo.isConnected) {
      unawaited(_pushDelete(id));
    }
  }

  Future<void> _pushDelete(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      await localDataSource.removePendingDelete(id);
      talker.info('Task deleted from Firestore: $id');
    } catch (e, st) {
      talker.handle(e, st, 'Failed to delete from Firestore');
    }
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    final model = await localDataSource.getTaskById(id);
    if (model == null) return;

    final updated = model.toEntity().copyWith(
          isCompleted: !model.isCompleted,
        );
    talker.info('Task toggled: $id → ${updated.isCompleted ? "completed" : "pending"}');
    await updateTask(updated);
  }

  @override
  Future<void> syncTasks() async {
    if (!await networkInfo.isConnected) {
      talker.warning('Sync skipped — offline');
      return;
    }

    final pendingDeletes = await localDataSource.getPendingDeletes();
    talker.info('Syncing ${pendingDeletes.length} pending deletes');

    for (final id in pendingDeletes) {
      try {
        await remoteDataSource.deleteTask(id);
        await localDataSource.removePendingDelete(id);
        talker.info('Pending delete synced: $id');
      } catch (e, st) {
        talker.handle(e, st, 'Failed to sync pending delete: $id');
      }
    }

    final unsynced = await localDataSource.getUnsyncedTasks();
    talker.info('Syncing ${unsynced.length} unsynced tasks');

    for (final task in unsynced) {
      try {
        await remoteDataSource.createTask(task);
        final synced = TaskModel.fromEntity(
          task.toEntity().copyWith(isSynced: true),
        );
        await localDataSource.saveTask(synced);
        talker.info('Synced task: ${task.title}');
      } catch (e, st) {
        talker.handle(e, st, 'Failed to sync task: ${task.title}');
      }
    }

    try {
      final remoteTasks = await remoteDataSource.getTasks();
      await _mergeRemoteTasks(remoteTasks);
      talker.info('Full sync complete: ${remoteTasks.length} tasks');
    } catch (e, st) {
      talker.handle(e, st, 'Failed to pull remote tasks');
    }
  }

  Future<void> _mergeRemoteTasks(List<TaskModel> remoteTasks) async {
    final pendingDeletes =
        (await localDataSource.getPendingDeletes()).toSet();
    final localTasks = await localDataSource.getTasks();
    final localById = {for (final task in localTasks) task.id: task};
    final merged = <TaskModel>[];

    for (final remote in remoteTasks) {
      if (pendingDeletes.contains(remote.id)) continue;
      final local = localById.remove(remote.id);
      if (local != null && !local.isSynced) {
        merged.add(local);
      } else {
        merged.add(remote);
      }
    }

    merged.addAll(
      localById.values.where((task) => !pendingDeletes.contains(task.id)),
    );
    await localDataSource.saveTasks(merged);
  }
}
