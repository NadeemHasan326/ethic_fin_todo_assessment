import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final task = state.allTasks.cast<TaskEntity?>().firstWhere(
              (t) => t?.id == taskId,
              orElse: () => null,
            );

        if (task == null) {
          return Scaffold(
            backgroundColor: AppPalette.of(context).background,
            body: const Center(child: Text(AppStrings.taskNotFound)),
          );
        }

        final colors = AppPalette.of(context);
        return Scaffold(
          backgroundColor: colors.background,
          body: Stack(
            children: [
                              const _BottomDecor(),
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context, task),
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(AppSizes.w20, AppSizes.h8, AppSizes.w20, AppSizes.h24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusRow(task),
                            SizedBox(height: AppSizes.h16),
                            Hero(
                              tag: AppConstants.taskTitleHero(task.id),
                              child: Material(
                                type: MaterialType.transparency,
                                child: AnimatedDefaultTextStyle(
                                  duration: AppDurations.standard,
                                  style: TextStyle(
                                    fontSize: AppSizes.sp28,
                                    fontWeight: FontWeight.w800,
                                    color: task.isCompleted
                                        ? colors.textHint
                                        : colors.textPrimary,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: colors.textHint,
                                  ),
                                  child: Text(task.title),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSizes.h20),
                            _buildInfoCard(context, task),
                            SizedBox(height: AppSizes.h24),
                            _buildDescriptionSection(context, task),
                            SizedBox(height: AppSizes.h28),
                            _buildToggleButton(context, task),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TaskEntity task) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSizes.w16, AppSizes.h8, AppSizes.w16, AppSizes.h8),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.edit_rounded,
            onTap: () {
              Navigator.of(context).push(
                AppPageRoute(page: AddEditTaskPage(task: task)),
              );
            },
          ),
          SizedBox(width: AppSizes.w10),
          _HeaderIconButton(
            icon: Icons.delete_outline_rounded,
            iconColor: AppColors.error,
            onTap: () => _confirmDelete(context, task),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(TaskEntity task) {
    final statusColor = task.isCompleted ? AppColors.success : AppColors.warning;
    final priorityColor = _getPriorityColor(task.priority);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: AppDurations.medium,
          child: _StatusChip(
            key: ValueKey(task.isCompleted),
            icon: task.isCompleted
                ? Icons.check_circle_rounded
                : Icons.schedule_rounded,
            label: task.isCompleted ? AppStrings.completed : AppStrings.pending,
            color: statusColor,
          ),
        ),
        SizedBox(width: AppSizes.w8),
        _StatusChip(
          icon: Icons.bar_chart_rounded,
          label: task.priority.name[0].toUpperCase() + task.priority.name.substring(1),
          color: priorityColor,
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              task.isSynced ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              size: AppSizes.icon18,
              color: task.isSynced ? AppColors.syncedColor : AppColors.unsyncedColor,
            ),
            SizedBox(height: AppSizes.h2),
            Text(
              task.isSynced ? AppStrings.synced : AppStrings.pendingSync,
              style: TextStyle(
                fontSize: AppSizes.sp11,
                fontWeight: FontWeight.w600,
                color: task.isSynced ? AppColors.syncedColor : AppColors.unsyncedColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, TaskEntity task) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h6),
      decoration: BoxDecoration(
        color: AppPalette.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: AppSizes.blur18,
            offset: AppSizes.shadowXl,
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_month_rounded,
            label: AppStrings.dueDateLabel,
            value: DateFormatter.formatDate(task.dueDate),
            valueColor: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                ? AppColors.error
                : AppColors.primary,
          ),
          Divider(height: AppSizes.h1, color: AppPalette.of(context).divider),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: AppStrings.createdLabel,
            value: DateFormatter.formatDate(task.createdAt),
          ),
          Divider(height: AppSizes.h1, color: AppPalette.of(context).divider),
          _InfoRow(
            icon: Icons.flag_rounded,
            label: AppStrings.priorityLabel,
            value: task.priority.name[0].toUpperCase() + task.priority.name.substring(1),
            valueColor: _getPriorityColor(task.priority),
            showDot: true,
            dotColor: _getPriorityColor(task.priority),
          ),
          Divider(height: AppSizes.h1, color: AppPalette.of(context).divider),
          _InfoRow(
            icon: task.isSynced ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            label: AppStrings.syncStatusLabel,
            value: task.isSynced ? AppStrings.synced : AppStrings.pendingSync,
            valueColor: task.isSynced ? AppColors.syncedColor : AppColors.unsyncedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, TaskEntity task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.descriptionLabel,
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w800,
            color: AppPalette.of(context).textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.h10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.w16),
          decoration: BoxDecoration(
            color: AppPalette.of(context).surface,
            borderRadius: BorderRadius.circular(AppSizes.r18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: AppSizes.blur18,
                offset: AppSizes.shadowXl,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSizes.w36,
                height: AppSizes.h36,
                decoration: BoxDecoration(
                  color: AppPalette.of(context).iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.primary,
                  size: AppSizes.icon20,
                ),
              ),
              SizedBox(width: AppSizes.w12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSizes.h8),
                  child: Text(
                    task.description.isEmpty ? AppStrings.noDescription : task.description,
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      height: 1.5,
                      color: task.description.isEmpty
                          ? AppPalette.of(context).textHint
                          : AppPalette.of(context).textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(BuildContext context, TaskEntity task) {
    return AnimatedSwitcher(
      duration: AppDurations.standard,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: AppMotion.toggleButtonScaleBegin, end: 1)
                .animate(animation),
            child: child,
          ),
        );
      },
      child: SizedBox(
        key: ValueKey(task.isCompleted),
        width: double.infinity,
        height: AppSizes.h56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.r28),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: task.isCompleted
                  ? const [
                      AppColors.pendingGradientStart,
                      AppColors.pendingGradientEnd,
                    ]
                  : const [
                      AppColors.completeGradientStart,
                      AppColors.completeGradientEnd,
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: (task.isCompleted ? AppColors.warning : AppColors.success)
                    .withValues(alpha: 0.28),
                blurRadius: AppSizes.blur16,
                offset: AppSizes.shadowXl,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSizes.r28),
              onTap: () {
                context.read<TaskBloc>().add(ToggleTaskStatusEvent(task.id));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    key: ValueKey(task.isCompleted),
                    tween: Tween(begin: AppMotion.completeIconScaleBegin, end: 1),
                    duration: AppDurations.iconPop,
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: AppSizes.w24,
                      height: AppSizes.h24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.onPrimary,
                          width: AppSizes.borderSelected,
                        ),
                      ),
                      child: Icon(
                        task.isCompleted ? Icons.undo_rounded : Icons.check_rounded,
                        size: AppSizes.icon14,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.w10),
                  Text(
                    task.isCompleted
                        ? AppStrings.markAsPending
                        : AppStrings.markAsCompleted,
                    style: TextStyle(
                      fontSize: AppSizes.sp16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, TaskEntity task) async {
    final confirmed = await DeleteConfirmDialog.show(context);
    if (!confirmed || !context.mounted) return;

    context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
    AppToast.deleted(context);
    Navigator.pop(context, true);
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.priorityHigh;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.low:
        return AppColors.priorityLow;
    }
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.w42,
        height: AppSizes.h42,
        decoration: BoxDecoration(
          color: AppPalette.of(context).surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.10),
              blurRadius: AppSizes.blur12,
              offset: AppSizes.shadowMd,
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: AppSizes.icon22),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w10, vertical: AppSizes.h6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.r10),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.icon14, color: color),
          SizedBox(width: AppSizes.w5),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.sp12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool showDot;
  final Color? dotColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.showDot = false,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
      child: Row(
        children: [
          Container(
            width: AppSizes.w36,
            height: AppSizes.h36,
            decoration: BoxDecoration(
              color: AppPalette.of(context).iconBg,
              borderRadius: BorderRadius.circular(AppSizes.r10),
            ),
            child: Icon(icon, size: AppSizes.icon18, color: AppColors.primary),
          ),
          SizedBox(width: AppSizes.w12),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.sp14,
              color: AppPalette.of(context).textSecondary,
            ),
          ),
          const Spacer(),
          if (showDot) ...[
            Container(
              width: AppSizes.w8,
              height: AppSizes.h8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSizes.w6),
          ],
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.sp14,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppPalette.of(context).textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomDecor extends StatelessWidget {
  const _BottomDecor();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: AppSizes.h180,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: -AppSizes.h70,
              left: -AppSizes.w40,
              child: Container(
                width: AppSizes.w260,
                height: AppSizes.h160,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSizes.r90),
                ),
              ),
            ),
            Positioned(
              bottom: -AppSizes.h50,
              right: -AppSizes.w30,
              child: Container(
                width: AppSizes.w220,
                height: AppSizes.h140,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSizes.r80),
                ),
              ),
            ),
            Positioned(
              bottom: AppSizes.h70,
              left: AppSizes.w40,
              child: Icon(Icons.star_rounded, size: AppSizes.icon10, color: AppColors.decorStar),
            ),
            Positioned(
              bottom: AppSizes.h48,
              right: AppSizes.w70,
              child: Icon(Icons.star_rounded, size: AppSizes.icon12, color: AppColors.decorStar),
            ),
            Positioned(
              bottom: AppSizes.h90,
              right: AppSizes.w130,
              child: Icon(Icons.star_rounded, size: AppSizes.icon8, color: AppColors.decorStarMuted),
            ),
          ],
        ),
      ),
    );
  }
}
