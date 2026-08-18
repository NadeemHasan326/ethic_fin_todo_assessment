import 'package:ethic_fin_todo_assessment/exports.dart';

class AppToast {
  static OverlayEntry? _entry;

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required ToastType type,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    hide();

    _entry = OverlayEntry(
      builder: (_) => _ToastCard(
        title: title,
        message: message,
        type: type,
        onDismiss: hide,
      ),
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  static void created(BuildContext context, {required String taskTitle}) {
    show(
      context: context,
      type: ToastType.success,
      title: AppStrings.toastCreatedTitle,
      message: AppStrings.toastCreatedMessage(taskTitle),
    );
  }

  static void updated(BuildContext context, {required String taskTitle}) {
    show(
      context: context,
      type: ToastType.updated,
      title: AppStrings.toastUpdatedTitle,
      message: AppStrings.toastUpdatedMessage(taskTitle),
    );
  }

  static void deleted(BuildContext context) {
    show(
      context: context,
      type: ToastType.deleted,
      title: AppStrings.toastDeletedTitle,
      message: AppStrings.toastDeletedMessage,
    );
  }
}

class _ToastCard extends StatefulWidget {
  final String title;
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastCard({
    required this.title,
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.toastIn,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    Future.delayed(AppDurations.toastHold, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _ToastStyle get _style {
    switch (widget.type) {
      case ToastType.success:
        return const _ToastStyle(
          accent: AppColors.primary,
          icon: Icons.check_rounded,
        );
      case ToastType.updated:
        return const _ToastStyle(
          accent: AppColors.primaryDark,
          icon: Icons.edit_rounded,
        );
      case ToastType.deleted:
        return const _ToastStyle(
          accent: AppColors.error,
          icon: Icons.delete_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final colors = AppPalette.of(context);
    final top = MediaQuery.of(context).padding.top + AppSizes.h12;

    return Positioned(
      top: top,
      left: AppSizes.w16,
      right: AppSizes.w16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.fromLTRB(AppSizes.w14, AppSizes.h14, AppSizes.w16, AppSizes.h14),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r18),
                border: Border.all(color: style.accent.withValues(alpha: 0.12)),
                boxShadow: [
                  BoxShadow(
                    color: style.accent.withValues(alpha: 0.18),
                    blurRadius: AppSizes.blur28,
                    offset: AppSizes.shadowXxl,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: AppSizes.blur16,
                    offset: AppSizes.shadowLg,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: AppSizes.w42,
                    height: AppSizes.h42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          style.accent,
                          style.accent.withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.r14),
                    ),
                    child: Icon(style.icon, color: AppColors.onPrimary, size: AppSizes.icon22),
                  ),
                  SizedBox(width: AppSizes.w12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: AppSizes.sp15,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.h3),
                        Text(
                          widget.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppSizes.sp13,
                            height: 1.3,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
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
}

class _ToastStyle {
  final Color accent;
  final IconData icon;

  const _ToastStyle({
    required this.accent,
    required this.icon,
  });
}
