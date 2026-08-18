import 'package:ethic_fin_todo_assessment/exports.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppPalette.of(context);
    return AnimatedAppear(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(AppSizes.w28, AppSizes.h24, AppSizes.w28, AppSizes.h100),
        child: Column(
          children: [
            Image.asset(
              AppImages.emptyTasks,
              width: AppSizes.w180,
              height: AppSizes.h180,
              fit: BoxFit.contain,
            ),
            SizedBox(height: AppSizes.h8),
            Text(
              AppStrings.emptyTitle,
              style: TextStyle(
                fontSize: AppSizes.sp22,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h8),
            Text(
              AppStrings.emptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.sp14,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.h22),
            CustomPaint(
              painter: _DashedBorderPainter(
                color: AppColors.primary.withValues(alpha: 0.45),
                radius: AppSizes.r16,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h14),
                decoration: BoxDecoration(
                  color: colors.emptyTipBg,
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, size: AppSizes.icon18, color: AppColors.primary),
                    SizedBox(width: AppSizes.w8),
                    Flexible(
                      child: Text(
                        AppStrings.emptyTip,
                        style: TextStyle(
                          fontSize: AppSizes.sp13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.borderFocus;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final dashWidth = AppSizes.w6;
    final dashSpace = AppSizes.w4;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedAppear(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.w24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppSizes.icon52, color: AppColors.primary.withValues(alpha: 0.6)),
              ),
              SizedBox(height: AppSizes.h20),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppPalette.of(context).textPrimary,
                      fontSize: AppSizes.sp16,
                    ),
              ),
              SizedBox(height: AppSizes.h8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPalette.of(context).textSecondary,
                      fontSize: AppSizes.sp14,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
