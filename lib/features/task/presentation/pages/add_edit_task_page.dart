import 'package:ethic_fin_todo_assessment/exports.dart';

class AddEditTaskPage extends StatefulWidget {
  final TaskEntity? task;

  const AddEditTaskPage({super.key, this.task});

  bool get isEditing => task != null;

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskPriority _priority;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _dueDate = widget.task?.dueDate ?? DateTime.now().add(AppDurations.defaultDueIn);
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(AppSizes.w20, AppSizes.h8, AppSizes.w20, AppSizes.h16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel(
                        icon: Icons.title_rounded,
                        label: AppStrings.titleLabel,
                      ),
                      SizedBox(height: AppSizes.h10),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _fieldDecoration(hint: AppStrings.titleHint),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.titleRequired;
                          }
                          if (value.trim().length < AppConstants.titleMinLength) {
                            return AppStrings.titleTooShort(AppConstants.titleMinLength);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h22),
                      _buildSectionLabel(
                        icon: Icons.notes_rounded,
                        label: AppStrings.descriptionLabel,
                      ),
                      SizedBox(height: AppSizes.h10),
                      Stack(
                        children: [
                          TextFormField(
                            controller: _descriptionController,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 5,
                            maxLength: AppConstants.descriptionMaxLength,
                            buildCounter: (
                              context, {
                              required currentLength,
                              required isFocused,
                              maxLength,
                            }) =>
                                const SizedBox.shrink(),
                            decoration: _fieldDecoration(
                              hint: AppStrings.descriptionHint,
                            ).copyWith(
                              contentPadding: EdgeInsets.fromLTRB(AppSizes.w16, AppSizes.h14, AppSizes.w16, AppSizes.h32),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.descriptionRequired;
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            right: AppSizes.w12,
                            bottom: AppSizes.h10,
                            child: Text(
                              '${_descriptionController.text.length}/${AppConstants.descriptionMaxLength}',
                              style: TextStyle(
                                fontSize: AppSizes.sp12,
                                color: AppPalette.of(context).textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h22),
                      _buildSectionLabel(
                        icon: Icons.flag_rounded,
                        label: AppStrings.priorityLabel,
                      ),
                      SizedBox(height: AppSizes.h12),
                      _buildPrioritySelector(),
                      SizedBox(height: AppSizes.h22),
                      _buildSectionLabel(
                        icon: Icons.calendar_month_rounded,
                        label: AppStrings.dueDateLabel,
                      ),
                      SizedBox(height: AppSizes.h10),
                      _buildDatePicker(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(AppSizes.w20, AppSizes.h8, AppSizes.w20, 0),
              child: _buildSubmitButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSizes.w16, AppSizes.h8, AppSizes.w16, AppSizes.h12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: AppSizes.w40,
              height: AppSizes.h40,
              decoration: BoxDecoration(
                color: AppPalette.of(context).iconBg,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primary,
                size: AppSizes.icon22,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: AppSizes.h4),
              child: Column(
                children: [
                    Text(
                      widget.isEditing ? AppStrings.editTask : AppStrings.newTask,
                      style: TextStyle(
                        fontSize: AppSizes.sp22,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.h4),
                    Text(
                      widget.isEditing
                          ? AppStrings.editTaskHint
                          : AppStrings.addTaskHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppSizes.sp13,
                        color: AppPalette.of(context).textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Image.asset(
            AppImages.taskClipboard,
            width: AppSizes.w72,
            height: AppSizes.h72,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: AppSizes.w28,
          height: AppSizes.h28,
          decoration: BoxDecoration(
            color: AppPalette.of(context).iconBg,
            borderRadius: BorderRadius.circular(AppSizes.r8),
          ),
          child: Icon(icon, size: AppSizes.icon16, color: AppColors.primary),
        ),
        SizedBox(width: AppSizes.w8),
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
            color: AppPalette.of(context).textPrimary,
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration({required String hint}) {
    final colors = AppPalette.of(context);
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: colors.surface,
      contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r14),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r14),
        borderSide: BorderSide(color: AppColors.primary, width: AppSizes.borderFocus),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r14),
        borderSide: BorderSide(color: AppColors.error, width: AppSizes.borderFocus),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    final colors = AppPalette.of(context);
    return Row(
      children: TaskPriority.values.map((priority) {
        final isSelected = _priority == priority;
        final color = _getPriorityColor(priority);
        final bgColor = _getPriorityBgColor(priority);
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priority = priority),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              margin: EdgeInsets.only(
                right: priority != TaskPriority.high ? AppSizes.w10 : 0,
              ),
              padding: EdgeInsets.symmetric(vertical: AppSizes.h16),
              decoration: BoxDecoration(
                color: isSelected ? bgColor : colors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(
                  color: isSelected ? color : colors.border,
                  width: isSelected ? AppSizes.borderSelected : AppSizes.border,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: AppSizes.w42,
                    height: AppSizes.h42,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getPriorityIcon(priority),
                      color: color,
                      size: AppSizes.icon22,
                    ),
                  ),
                  SizedBox(height: AppSizes.h8),
                  Text(
                    priority.name[0].toUpperCase() + priority.name.substring(1),
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    final colors = AppPalette.of(context);
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r14),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primary,
              size: AppSizes.icon20,
            ),
            SizedBox(width: AppSizes.w12),
            Expanded(
              child: Text(
                DateFormat(AppConstants.dateFormatWeekday).format(_dueDate),
                style: TextStyle(
                  fontSize: AppSizes.sp14,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.h56,
      child: FilledButton(
        onPressed: _submit,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.w26,
              height: AppSizes.h26,
              decoration: const BoxDecoration(
                color: AppColors.onPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: AppSizes.icon16,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSizes.w10),
            Text(
              widget.isEditing ? AppStrings.updateTask : AppStrings.createTask,
              style: TextStyle(
                fontSize: AppSizes.sp16,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(AppDurations.datePickerPast),
      lastDate: DateTime.now().add(AppDurations.datePickerFuture),
      builder: (context, child) {
        final colors = AppPalette.of(context);
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  surface: colors.surface,
                  onSurface: colors.textPrimary,
                ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: colors.surface,
              headerBackgroundColor: colors.surface,
              surfaceTintColor: Colors.transparent,
              headerForegroundColor: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final task = TaskEntity(
      id: widget.task?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
    );

    if (widget.isEditing) {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
      AppToast.updated(context, taskTitle: task.title);
    } else {
      context.read<TaskBloc>().add(CreateTaskEvent(task));
      AppToast.created(context, taskTitle: task.title);
    }

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

  Color _getPriorityBgColor(TaskPriority priority) {
    final colors = AppPalette.of(context);
    switch (priority) {
      case TaskPriority.high:
        return colors.priorityHighBg;
      case TaskPriority.medium:
        return colors.priorityMediumBg;
      case TaskPriority.low:
        return colors.priorityLowBg;
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Icons.keyboard_double_arrow_up_rounded;
      case TaskPriority.medium:
        return Icons.drag_handle_rounded;
      case TaskPriority.low:
        return Icons.keyboard_double_arrow_down_rounded;
    }
  }
}
