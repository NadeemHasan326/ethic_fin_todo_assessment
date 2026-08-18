// Task Priority
enum TaskPriority { low, medium, high }

// Task Filter
enum TaskFilter { all, completed, pending }

// Task Sort
enum TaskSort { dueDate, priority, createdAt }

// Task Status (BLoC)
enum TaskStatus { initial, loading, loaded, error }

// Sync Status
enum SyncStatus { idle, syncing, synced, error }

// Toast
enum ToastType { success, updated, deleted }
