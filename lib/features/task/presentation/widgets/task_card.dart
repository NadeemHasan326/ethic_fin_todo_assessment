import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final colors = AppPalette.of(context);
    final isOverdue = DateFormatter.isOverdue(task.dueDate) && !task.isCompleted;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h10),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: AppSizes.w24),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(AppSizes.r16),
          ),
          child: Icon(Icons.delete_rounded, color: AppColors.onPrimary, size: AppSizes.icon24),
        ),
        onDismissed: (_) => widget.onDelete(),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? AppMotion.cardPressScale : 1,
            duration: AppDurations.cardPress,
            curve: Curves.easeOut,
            child: Container(
              padding: EdgeInsets.all(AppSizes.w16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(
                  color: isOverdue
                      ? AppColors.error.withValues(alpha: 0.3)
                      : colors.divider.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.cardShadow,
                    blurRadius: AppSizes.blur10,
                    offset: AppSizes.shadowSm,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: AppConstants.taskTitleHero(task.id),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              task.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppSizes.sp15,
                                fontWeight: FontWeight.w600,
                                color: task.isCompleted
                                    ? colors.textHint
                                    : colors.textPrimary,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildPriorityBadge(context),
                    ],
                  ),
                  if (task.description.isNotEmpty) ...[
                    SizedBox(height: AppSizes.h4),
                    Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppSizes.sp13,
                        color: colors.textSecondary,
                        decoration:
                            task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSizes.h8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: AppSizes.icon13,
                        color: isOverdue ? AppColors.error : colors.textHint,
                      ),
                      SizedBox(width: AppSizes.w4),
                      Text(
                        DateFormatter.formatRelative(task.dueDate),
                        style: TextStyle(
                          fontSize: AppSizes.sp12,
                          fontWeight: FontWeight.w500,
                          color: isOverdue ? AppColors.error : colors.textHint,
                        ),
                      ),
                      if (!task.isSynced) ...[
                        SizedBox(width: AppSizes.w10),
                        Icon(
                          Icons.cloud_off_rounded,
                          size: AppSizes.icon13,
                          color: AppColors.unsyncedColor,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final task = widget.task;
    final colors = AppPalette.of(context);
    Color color;
    Color bgColor;
    switch (task.priority) {
      case TaskPriority.high:
        color = AppColors.priorityHigh;
        bgColor = colors.priorityHighBg;
        break;
      case TaskPriority.medium:
        color = AppColors.priorityMedium;
        bgColor = colors.priorityMediumBg;
        break;
      case TaskPriority.low:
        color = AppColors.priorityLow;
        bgColor = colors.priorityLowBg;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w8, vertical: AppSizes.h3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.r6),
      ),
      child: Text(
        task.priority.name[0].toUpperCase() + task.priority.name.substring(1),
        style: TextStyle(
          fontSize: AppSizes.sp11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
