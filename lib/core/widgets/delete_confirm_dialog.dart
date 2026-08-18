import 'package:ethic_fin_todo_assessment/exports.dart';

class DeleteConfirmDialog {
  static Future<bool> show(BuildContext context) async {
    final colors = AppPalette.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: colors.textPrimary.withValues(alpha: 0.42),
      builder: (ctx) {
        final dialogColors = AppPalette.of(ctx);
        return Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w18, vertical: AppSizes.h24),
          child: AnimatedAppear(
            slide: false,
            scale: true,
            duration: AppDurations.standard,
            child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: dialogColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.r20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: AppSizes.blur24,
                  offset: AppSizes.shadowHuge,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.r20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(AppSizes.w24, AppSizes.h28, AppSizes.w24, AppSizes.h20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          dialogColors.priorityHighBg,
                          dialogColors.surface,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: AppSizes.w72,
                          height: AppSizes.h72,
                          decoration: BoxDecoration(
                            color: dialogColors.surface,
                            borderRadius: BorderRadius.circular(AppSizes.r20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error.withValues(alpha: 0.16),
                                blurRadius: AppSizes.blur16,
                                offset: AppSizes.shadowLg,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: AppSizes.w48,
                              height: AppSizes.h48,
                              decoration: BoxDecoration(
                                color: dialogColors.priorityHighBg,
                                borderRadius: BorderRadius.circular(AppSizes.r14),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: AppSizes.icon26,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.h20),
                        Text(
                          AppStrings.deleteTaskTitle,
                          style: GoogleFonts.inter(
                            fontSize: AppSizes.sp22,
                            fontWeight: FontWeight.w800,
                            color: dialogColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.h8),
                        Text(
                          AppStrings.deleteTaskMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: AppSizes.sp14,
                            height: 1.5,
                            color: dialogColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: AppSizes.h1, color: dialogColors.divider),
                  Padding(
                    padding: EdgeInsets.fromLTRB(AppSizes.w20, AppSizes.h18, AppSizes.w20, AppSizes.h20),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: AppSizes.h52,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                backgroundColor: dialogColors.surface,
                                side: BorderSide(
                                  color: AppColors.primary.withValues(alpha: 0.28),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.r14),
                                ),
                                textStyle: GoogleFonts.inter(
                                  fontSize: AppSizes.sp15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(AppStrings.cancel),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.w12),
                        Expanded(
                          child: Container(
                            height: AppSizes.h52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.r14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.error.withValues(alpha: 0.28),
                                  blurRadius: AppSizes.blur12,
                                  offset: AppSizes.shadowLg,
                                ),
                              ],
                            ),
                            child: FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: AppColors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.r14),
                                ),
                                textStyle: GoogleFonts.inter(
                                  fontSize: AppSizes.sp15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(AppStrings.delete),
                            ),
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
        );
      },
    );
    return result == true;
  }
}
