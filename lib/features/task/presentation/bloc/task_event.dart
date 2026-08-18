import 'package:ethic_fin_todo_assessment/exports.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;
  CreateTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent(this.taskId);
}

class ToggleTaskStatusEvent extends TaskEvent {
  final String taskId;
  ToggleTaskStatusEvent(this.taskId);
}

class SearchTasksEvent extends TaskEvent {
  final String query;
  SearchTasksEvent(this.query);
}

class FilterTasksEvent extends TaskEvent {
  final TaskFilter filter;
  FilterTasksEvent(this.filter);
}

class SortTasksEvent extends TaskEvent {
  final TaskSort sort;
  SortTasksEvent(this.sort);
}

class SyncTasksEvent extends TaskEvent {}

class ConnectivityChangedEvent extends TaskEvent {
  final bool isConnected;
  ConnectivityChangedEvent(this.isConnected);
}
