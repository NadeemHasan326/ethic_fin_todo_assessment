import 'dart:async';

import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final ToggleTaskStatus toggleTaskStatus;
  final SyncTasks syncTasks;
  final NetworkInfo networkInfo;

  StreamSubscription<bool>? _connectivitySubscription;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskStatus,
    required this.syncTasks,
    required this.networkInfo,
  }) : super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
    on<SearchTasksEvent>(_onSearchTasks);
    on<FilterTasksEvent>(_onFilterTasks);
    on<SortTasksEvent>(_onSortTasks);
    on<SyncTasksEvent>(_onSyncTasks);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);

    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) => add(ConnectivityChangedEvent(isConnected)),
    );
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    await _reloadTasks(emit);
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final allTasks = [event.task, ...state.allTasks];
      _emitTasks(
        emit,
        allTasks,
        filter: TaskFilter.all,
      );
      await createTask(event.task);
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final allTasks = state.allTasks
          .map((task) => task.id == event.task.id ? event.task : task)
          .toList();
      _emitTasks(emit, allTasks);
      await updateTask(event.task);
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final allTasks = state.allTasks.where((task) => task.id != event.taskId).toList();
      _emitTasks(emit, allTasks);
      await deleteTask(event.taskId);
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatusEvent event, Emitter<TaskState> emit) async {
    try {
      final allTasks = state.allTasks.map((task) {
        if (task.id != event.taskId) return task;
        return task.copyWith(isCompleted: !task.isCompleted);
      }).toList();
      _emitTasks(emit, allTasks);
      await toggleTaskStatus(event.taskId);
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      searchQuery: event.query,
      filteredTasks: _applyFilters(state.allTasks, state.currentFilter, state.currentSort, event.query),
    ));
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      currentFilter: event.filter,
      filteredTasks: _applyFilters(state.allTasks, event.filter, state.currentSort, state.searchQuery),
    ));
  }

  void _onSortTasks(SortTasksEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      currentSort: event.sort,
      filteredTasks: _applyFilters(state.allTasks, state.currentFilter, event.sort, state.searchQuery),
    ));
  }

  Future<void> _onSyncTasks(SyncTasksEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(syncStatus: SyncStatus.syncing));
    try {
      await syncTasks();
      emit(state.copyWith(syncStatus: SyncStatus.synced));
      await _reloadTasks(emit);
    } catch (e) {
      emit(state.copyWith(syncStatus: SyncStatus.error));
    }
  }

  void _onConnectivityChanged(ConnectivityChangedEvent event, Emitter<TaskState> emit) {
    final wasOffline = !state.isConnected;
    emit(state.copyWith(isConnected: event.isConnected));
    if (event.isConnected && (wasOffline || state.syncStatus == SyncStatus.idle)) {
      add(SyncTasksEvent());
    }
  }

  List<TaskEntity> _applyFilters(
    List<TaskEntity> tasks,
    TaskFilter filter,
    TaskSort sort,
    String query,
  ) {
    var result = List<TaskEntity>.from(tasks);

    if (query.isNotEmpty) {
      result = result
          .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    switch (filter) {
      case TaskFilter.completed:
        result = result.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.pending:
        result = result.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.all:
        break;
    }

    switch (sort) {
      case TaskSort.dueDate:
        result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSort.priority:
        result.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSort.createdAt:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return result;
  }

  void _emitTasks(
    Emitter<TaskState> emit,
    List<TaskEntity> tasks, {
    TaskFilter? filter,
  }) {
    final currentFilter = filter ?? state.currentFilter;
    emit(state.copyWith(
      status: TaskStatus.loaded,
      allTasks: tasks,
      currentFilter: currentFilter,
      filteredTasks: _applyFilters(
        tasks,
        currentFilter,
        state.currentSort,
        state.searchQuery,
      ),
    ));
  }

  Future<void> _reloadTasks(
    Emitter<TaskState> emit, {
    bool showShimmer = false,
  }) async {
    if (showShimmer) {
      emit(state.copyWith(status: TaskStatus.loading));
    }
    try {
      final tasks = await getTasks();
      emit(state.copyWith(
        status: TaskStatus.loaded,
        allTasks: tasks,
        filteredTasks: _applyFilters(
          tasks,
          state.currentFilter,
          state.currentSort,
          state.searchQuery,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
