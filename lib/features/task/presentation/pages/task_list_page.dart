import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppPalette.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SyncIndicator(),
            const FilterSortBar(),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
      floatingActionButton: _AddTaskFab(onPressed: _navigateToAddTask),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSizes.w20, AppSizes.h16, AppSizes.w20, AppSizes.h8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: AppSizes.sp26,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.h4),
                    BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        final total = state.allTasks.length;
                        final completed = state.allTasks.where((t) => t.isCompleted).length;
                        return Text(
                          AppStrings.tasksCompleted(completed, total),
                          style: TextStyle(
                            fontSize: AppSizes.sp14,
                            color: AppPalette.of(context).headerSubtitle,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  final isDark = mode == ThemeMode.dark;
                  return GestureDetector(
                    onTap: () => context.read<ThemeCubit>().toggle(),
                    child: Container(
                      width: AppSizes.w42,
                      height: AppSizes.h42,
                      decoration: BoxDecoration(
                        color: AppPalette.of(context).iconBg,
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: AnimatedSwitcher(
                        duration: AppDurations.standard,
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns: Tween<double>(
                              begin: AppMotion.themeIconTurnsBegin,
                              end: 1,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          key: ValueKey(isDark),
                          color: AppColors.primary,
                          size: AppSizes.icon22,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: AppSizes.w10),
              GestureDetector(
                onTap: () => context.read<TaskBloc>().add(SyncTasksEvent()),
                child: Container(
                  width: AppSizes.w42,
                  height: AppSizes.h42,
                  decoration: BoxDecoration(
                    color: AppPalette.of(context).iconBg,
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: Icon(
                    Icons.sync_rounded,
                    color: AppColors.primary,
                    size: AppSizes.icon22,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h18),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _searchController,
      builder: (context, value, _) {
        final colors = AppPalette.of(context);
        return TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            hintStyle: TextStyle(color: colors.textHint, fontSize: AppSizes.sp14),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary, size: AppSizes.icon22),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    tooltip: AppStrings.clear,
                    onPressed: () {
                      _searchController.clear();
                      context.read<TaskBloc>().add(SearchTasksEvent(''));
                    },
                    icon: Container(
                      width: AppSizes.w22,
                      height: AppSizes.h22,
                      decoration: BoxDecoration(
                        color: colors.border,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: AppSizes.icon14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r28),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r28),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r28),
              borderSide: BorderSide(color: AppColors.primary, width: AppSizes.borderFocus),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h12),
          ),
          onChanged: (query) {
            context.read<TaskBloc>().add(SearchTasksEvent(query));
          },
        );
      },
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        Widget child;
        if (state.status == TaskStatus.loading) {
          child = const TaskListShimmer(key: ValueKey('loading'));
        } else if (state.status == TaskStatus.error) {
          child = KeyedSubtree(
            key: const ValueKey('error'),
            child: _buildErrorState(state.errorMessage),
          );
        } else if (state.filteredTasks.isEmpty) {
          if (state.searchQuery.isNotEmpty) {
            child = const EmptyStateWidget(
              key: ValueKey('empty-search'),
              icon: Icons.search_off_rounded,
              title: AppStrings.noResultsTitle,
              subtitle: AppStrings.noResultsSubtitle,
            );
          } else if (state.currentFilter != TaskFilter.all) {
            child = EmptyStateWidget(
              key: ValueKey('empty-filter-${state.currentFilter}'),
              icon: Icons.filter_list_off_rounded,
              title: AppStrings.noFilterTasks(state.currentFilter.name),
              subtitle: AppStrings.noFilterSubtitle,
            );
          } else {
            child = const HomeEmptyState(key: ValueKey('empty-home'));
          }
        } else {
          child = RefreshIndicator(
            key: const ValueKey('list'),
            color: AppColors.primary,
            onRefresh: () async {
              final bloc = context.read<TaskBloc>();
              bloc.add(LoadTasks());
              await bloc.stream.firstWhere((s) => s.status != TaskStatus.loading);
            },
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(AppSizes.w16, AppSizes.h4, AppSizes.w16, AppSizes.h80),
              itemCount: state.filteredTasks.length,
              itemBuilder: (context, index) {
                final task = state.filteredTasks[index];
                return AnimatedAppear(
                  key: ValueKey(task.id),
                  index: index,
                  child: TaskCard(
                    task: task,
                    onTap: () => _navigateToDetail(task.id),
                    onDelete: () => _confirmDelete(task.id),
                  ),
                );
              },
            ),
          );
        }

        return AnimatedSwitcher(
          duration: AppDurations.standard,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: child,
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.w20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded, size: AppSizes.icon48, color: AppColors.error),
            ),
            SizedBox(height: AppSizes.h16),
            Text(
              AppStrings.somethingWentWrong,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: AppSizes.h8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.of(context).textSecondary,
                  ),
            ),
            SizedBox(height: AppSizes.h24),
            FilledButton.icon(
              onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(AppStrings.retry),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToAddTask() async {
    final didChange = await Navigator.of(context).push<bool>(
      AppPageRoute(page: const AddEditTaskPage()),
    );
    if (!mounted) return;
    if (didChange == true && context.read<TaskBloc>().state.status != TaskStatus.loaded) {
      context.read<TaskBloc>().add(LoadTasks());
    }
  }

  Future<void> _navigateToDetail(String taskId) async {
    await Navigator.of(context).push<bool>(
      AppPageRoute(page: TaskDetailPage(taskId: taskId)),
    );
    if (!mounted) return;
    context.read<TaskBloc>().add(LoadTasks());
  }

  Future<void> _confirmDelete(String taskId) async {
    final confirmed = await DeleteConfirmDialog.show(context);
    if (!confirmed || !mounted) return;

    context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
    AppToast.deleted(context);
  }
}

class _AddTaskFab extends StatefulWidget {
  const _AddTaskFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_AddTaskFab> createState() => _AddTaskFabState();
}

class _AddTaskFabState extends State<_AddTaskFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  late final Animation<double> _scale;
  late final Animation<double> _rotate;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: AppDurations.fabIntro,
    );
    _scale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _intro, curve: Curves.easeOutBack),
    );
    _rotate = Tween<double>(begin: AppMotion.fabIntroTurns, end: 0).animate(
      CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic),
    );
    _intro.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _intro,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Transform.rotate(
            angle: _rotate.value * AppMotion.fullTurnRadians,
            child: child,
          ),
        );
      },
      child: Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? AppMotion.fabPressScale : 1,
          duration: AppDurations.press,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            elevation: 6,
            backgroundColor: AppColors.primary,
            child: AnimatedRotation(
              turns: _pressed ? AppMotion.fabPressTurns : 0,
              duration: AppDurations.fabIcon,
              child: Icon(
                Icons.add_rounded,
                size: AppSizes.icon30,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
