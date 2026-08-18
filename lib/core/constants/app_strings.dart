class AppStrings {
  AppStrings._();

  static const String pageNotFound = 'Page not found';

  static const String searchHint = 'Search tasks...';
  static const String clear = 'Clear';
  static const String sort = 'Sort';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';

  static const String emptyTitle = 'No tasks yet';
  static const String emptySubtitle = 'Stay organized by creating your first task.';
  static const String emptyTip = 'Tap the + button to add a new task';
  static const String noResultsTitle = 'No results found';
  static const String noResultsSubtitle = 'Try a different search term';
  static const String noFilterSubtitle = 'Tasks matching this filter will appear here';
  static const String somethingWentWrong = 'Something went wrong';

  static const String newTask = 'New Task';
  static const String editTask = 'Edit Task';
  static const String createTask = 'Create Task';
  static const String updateTask = 'Update Task';
  static const String addTaskHint = 'Add details to create a new task';
  static const String editTaskHint = 'Update the details of this task';
  static const String titleLabel = 'Title';
  static const String descriptionLabel = 'Description';
  static const String priorityLabel = 'Priority';
  static const String dueDateLabel = 'Due Date';
  static const String createdLabel = 'Created';
  static const String syncStatusLabel = 'Sync Status';
  static const String titleHint = 'Enter task title';
  static const String descriptionHint = 'Enter task description';
  static const String titleRequired = 'Please enter a title';
  static const String descriptionRequired = 'Please enter a description';
  static const String noDescription = 'No description';
  static const String taskNotFound = 'Task not found';

  static const String completed = 'Completed';
  static const String pending = 'Pending';
  static const String synced = 'Synced';
  static const String pendingSync = 'Pending sync';
  static const String markAsCompleted = 'Mark as Completed';
  static const String markAsPending = 'Mark as Pending';

  static const String deleteTaskTitle = 'Delete Task?';
  static const String deleteTaskMessage =
      'This action cannot be undone.\nThe task will be removed from your list.';

  static const String toastCreatedTitle = 'Task created';
  static const String toastUpdatedTitle = 'Task updated';
  static const String toastDeletedTitle = 'Task deleted';
  static const String toastDeletedMessage = 'The task was removed from your list';

  static const String offlineBanner = 'Offline — changes will sync when connected';
  static const String syncingBanner = 'Syncing...';
  static const String syncFailedBanner = 'Sync failed — tap to retry';
  static const String syncedBanner = 'All changes synced';

  static const String sortDateCreated = 'Date Created';
  static const String sortDueDate = 'Due Date';
  static const String sortPriority = 'Priority';

  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String tomorrow = 'Tomorrow';

  static const String serverError = 'Server error occurred';
  static const String cacheError = 'Cache error occurred';
  static const String networkError = 'No internet connection';

  static String tasksCompleted(int completed, int total) =>
      '$completed of $total tasks completed';

  static String noFilterTasks(String filterName) => 'No $filterName tasks';

  static String titleTooShort(int minLength) =>
      'Title must be at least $minLength characters';

  static String toastCreatedMessage(String taskTitle) =>
      '"$taskTitle" was added to your list';

  static String toastUpdatedMessage(String taskTitle) =>
      '"$taskTitle" was saved successfully';

  static String daysAgo(int days) => '$days days ago';

  static String inDays(int days) => 'In $days days';
}
