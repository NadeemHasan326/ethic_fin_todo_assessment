import 'package:ethic_fin_todo_assessment/exports.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      buildWhen: (prev, curr) =>
          prev.syncStatus != curr.syncStatus ||
          prev.isConnected != curr.isConnected ||
          prev.allTasks != curr.allTasks,
      builder: (context, state) {
        final hasUnsynced = state.allTasks.any((task) => !task.isSynced);
        final colors = AppPalette.of(context);
        Color bgColor;
        IconData icon;
        String text;
        Color textColor;

        if (!state.isConnected) {
          bgColor = colors.bannerOfflineBg;
          icon = Icons.wifi_off_rounded;
          text = AppStrings.offlineBanner;
          textColor = AppColors.warning;
        } else if (state.syncStatus == SyncStatus.syncing) {
          bgColor = colors.bannerSyncingBg;
          icon = Icons.sync_rounded;
          text = AppStrings.syncingBanner;
          textColor = AppColors.primary;
        } else if (state.syncStatus == SyncStatus.error || hasUnsynced) {
          bgColor = colors.bannerErrorBg;
          icon = Icons.sync_problem_rounded;
          text = AppStrings.syncFailedBanner;
          textColor = AppColors.error;
        } else {
          bgColor = colors.bannerSuccessBg;
          icon = Icons.cloud_done_rounded;
          text = AppStrings.syncedBanner;
          textColor = colors.bannerSuccessText;
        }

        return GestureDetector(
          onTap: () {
            if (state.syncStatus == SyncStatus.error ||
                !state.isConnected ||
                hasUnsynced) {
              context.read<TaskBloc>().add(SyncTasksEvent());
            }
          },
          child: AnimatedContainer(
            duration: AppDurations.banner,
            margin: EdgeInsets.fromLTRB(AppSizes.w20, AppSizes.h8, AppSizes.w20, AppSizes.h4),
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w14, vertical: AppSizes.h12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppSizes.r16),
            ),
            child: Row(
              children: [
                Icon(icon, size: AppSizes.icon18, color: textColor),
                SizedBox(width: AppSizes.w10),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: AppSizes.sp13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: AppSizes.icon20, color: textColor),
              ],
            ),
          ),
        );
      },
    );
  }
}
