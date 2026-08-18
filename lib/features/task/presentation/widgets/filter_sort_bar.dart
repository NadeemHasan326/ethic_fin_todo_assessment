import 'package:ethic_fin_todo_assessment/exports.dart';

class FilterSortBar extends StatefulWidget {
  const FilterSortBar({super.key});

  @override
  State<FilterSortBar> createState() => _FilterSortBarState();
}

class _FilterSortBarState extends State<FilterSortBar> {
  final _scrollController = ScrollController();
  final _chipKeys = {
    for (final filter in TaskFilter.values) filter: GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected(TaskFilter filter) {
    final chipContext = _chipKeys[filter]?.currentContext;
    if (chipContext == null) return;

    Scrollable.ensureVisible(
      chipContext,
      duration: AppDurations.standard,
      curve: Curves.easeOutCubic,
      alignment: filter == TaskFilter.values.last
          ? 1
          : filter == TaskFilter.values.first
              ? 0
              : 0.5,
    );
  }

  void _onFilterTap(TaskFilter filter) {
    context.read<TaskBloc>().add(FilterTasksEvent(filter));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppPalette.of(context);
    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (prev, curr) => prev.currentFilter != curr.currentFilter,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelected(state.currentFilter);
        });
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.fromLTRB(AppSizes.w16, AppSizes.h8, AppSizes.w8, AppSizes.h4),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: TaskFilter.values.map((filter) {
                        final isSelected = state.currentFilter == filter;
                        return Padding(
                          key: _chipKeys[filter],
                          padding: EdgeInsets.only(right: AppSizes.w8),
                          child: GestureDetector(
                            onTap: () => _onFilterTap(filter),
                            child: AnimatedContainer(
                              duration: AppDurations.chip,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.w14,
                                vertical: AppSizes.h10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : colors.surface,
                                borderRadius: BorderRadius.circular(AppSizes.r24),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : colors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _iconFor(filter),
                                    size: AppSizes.icon16,
                                    color: isSelected
                                        ? AppColors.onPrimary
                                        : colors.textSecondary,
                                  ),
                                  SizedBox(width: AppSizes.w6),
                                  Text(
                                    filter.name[0].toUpperCase() +
                                        filter.name.substring(1),
                                    style: TextStyle(
                                      fontSize: AppSizes.sp13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.onPrimary
                                          : colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                PopupMenuButton<TaskSort>(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.primary,
                    size: AppSizes.icon22,
                  ),
                  tooltip: AppStrings.sort,
                  color: colors.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 10,
                  shadowColor: Colors.black.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r14),
                    side: BorderSide(color: colors.border),
                  ),
                  onSelected: (sort) {
                    context.read<TaskBloc>().add(SortTasksEvent(sort));
                  },
                  itemBuilder: (context) => [
                    _buildSortItem(
                      context,
                      TaskSort.createdAt,
                      AppStrings.sortDateCreated,
                      Icons.schedule_rounded,
                      state.currentSort,
                    ),
                    PopupMenuDivider(height: AppSizes.h1),
                    _buildSortItem(
                      context,
                      TaskSort.dueDate,
                      AppStrings.sortDueDate,
                      Icons.calendar_today_rounded,
                      state.currentSort,
                    ),
                    PopupMenuDivider(height: AppSizes.h1),
                    _buildSortItem(
                      context,
                      TaskSort.priority,
                      AppStrings.sortPriority,
                      Icons.flag_rounded,
                      state.currentSort,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return Icons.check_rounded;
      case TaskFilter.completed:
        return Icons.check_circle_outline_rounded;
      case TaskFilter.pending:
        return Icons.schedule_rounded;
    }
  }

  PopupMenuItem<TaskSort> _buildSortItem(
    BuildContext context,
    TaskSort sort,
    String label,
    IconData icon,
    TaskSort currentSort,
  ) {
    final colors = AppPalette.of(context);
    final isSelected = sort == currentSort;
    return PopupMenuItem<TaskSort>(
      value: sort,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.icon18,
            color: isSelected ? AppColors.primary : colors.textSecondary,
          ),
          SizedBox(width: AppSizes.w10),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : colors.textPrimary,
              fontSize: AppSizes.sp14,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check_rounded, size: AppSizes.icon18, color: AppColors.primary),
          ],
        ],
      ),
    );
  }
}
