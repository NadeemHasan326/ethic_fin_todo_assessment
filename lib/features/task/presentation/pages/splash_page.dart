import 'package:ethic_fin_todo_assessment/exports.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: AppDurations.splashIntro,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: AppDurations.splashPulse,
    )..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _introController, curve: Curves.easeOut);
    _scale = Tween<double>(begin: AppMotion.splashScaleBegin, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutBack),
    );
    _slide = Tween<Offset>(
      begin: AppMotion.splashSlideBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic));

    _introController.forward();
    Future.delayed(AppDurations.splashHold, _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TaskListPage(),
        transitionDuration: AppDurations.splashFade,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Positioned(
              top: -AppSizes.h80,
              right: -AppSizes.w56,
              child: Container(
                width: AppSizes.w220,
                height: AppSizes.h220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -AppSizes.h90,
              left: -AppSizes.w72,
              child: Container(
                width: AppSizes.w240,
                height: AppSizes.h240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          ScaleTransition(
                            scale: _scale,
                            child: Container(
                              width: AppSizes.w108,
                              height: AppSizes.h108,
                              padding: EdgeInsets.all(AppSizes.w10),
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(AppSizes.r28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: AppSizes.blur28,
                                    offset: AppSizes.shadowHuge,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppSizes.r20),
                                child: Image.asset(
                                  AppImages.ethicFinIcon,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.h28),
                          Text(
                            AppConstants.brandName,
                            style: TextStyle(
                              fontSize: AppSizes.sp32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          SizedBox(height: AppSizes.h8),
                          Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: AppSizes.sp14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.6,
                              color: AppColors.onPrimary.withValues(alpha: 0.82),
                            ),
                          ),
                          const Spacer(),
                          FadeTransition(
                            opacity: _pulseController,
                            child: Container(
                              width: AppSizes.w42,
                              height: AppSizes.h4,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(AppSizes.r8),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.h48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
