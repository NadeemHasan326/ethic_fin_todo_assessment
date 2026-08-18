import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskState {
  final TaskStatus status;
  final List<TaskEntity> allTasks;
  final List<TaskEntity> filteredTasks;
  final TaskFilter currentFilter;
  final TaskSort currentSort;
  final String searchQuery;
  final String errorMessage;
  final SyncStatus syncStatus;
  final bool isConnected;

  const TaskState({
    this.status = TaskStatus.initial,
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.currentFilter = TaskFilter.all,
    this.currentSort = TaskSort.createdAt,
    this.searchQuery = '',
    this.errorMessage = '',
    this.syncStatus = SyncStatus.idle,
    this.isConnected = true,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? allTasks,
    List<TaskEntity>? filteredTasks,
    TaskFilter? currentFilter,
    TaskSort? currentSort,
    String? searchQuery,
    String? errorMessage,
    SyncStatus? syncStatus,
    bool? isConnected,
  }) {
    return TaskState(
      status: status ?? this.status,
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      syncStatus: syncStatus ?? this.syncStatus,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
