import 'package:ethic_fin_todo_assessment/exports.dart';

class TaskListShimmer extends StatelessWidget {
  const TaskListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(AppSizes.w16, AppSizes.h4, AppSizes.w16, AppSizes.h80),
      itemCount: 6,
      itemBuilder: (_, _) => const _ShimmerTaskCard(),
    );
  }
}

class _ShimmerTaskCard extends StatelessWidget {
  const _ShimmerTaskCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppPalette.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h10),
      child: Shimmer.fromColors(
        baseColor: colors.shimmerBase,
        highlightColor: colors.shimmerHighlight,
        child: Container(
          padding: EdgeInsets.all(AppSizes.w16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.r16),
            border: Border.all(color: colors.divider.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSizes.h14,
                      decoration: BoxDecoration(
                        color: colors.shimmerBlock,
                        borderRadius: BorderRadius.circular(AppSizes.r6),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.w12),
                  Container(
                    width: AppSizes.w52,
                    height: AppSizes.h18,
                    decoration: BoxDecoration(
                      color: colors.shimmerBlock,
                      borderRadius: BorderRadius.circular(AppSizes.r6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h10),
              Container(
                width: AppSizes.w180,
                height: AppSizes.h12,
                decoration: BoxDecoration(
                  color: colors.shimmerBlock,
                  borderRadius: BorderRadius.circular(AppSizes.r6),
                ),
              ),
              SizedBox(height: AppSizes.h10),
              Container(
                width: AppSizes.w90,
                height: AppSizes.h10,
                decoration: BoxDecoration(
                  color: colors.shimmerBlock,
                  borderRadius: BorderRadius.circular(AppSizes.r6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
