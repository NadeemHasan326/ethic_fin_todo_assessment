import 'package:ethic_fin_todo_assessment/exports.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark = Color(0xFF4A42DB);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFEF5350);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);

  static const Color priorityHigh = Color(0xFFEF5350);
  static const Color priorityMedium = Color(0xFFFFA726);
  static const Color priorityLow = Color(0xFF66BB6A);

  static const Color syncedColor = Color(0xFF4CAF50);
  static const Color unsyncedColor = Color(0xFFFFA726);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color completeGradientStart = Color(0xFF66BB6A);
  static const Color completeGradientEnd = Color(0xFF43A047);
  static const Color pendingGradientStart = Color(0xFFFFB74D);
  static const Color pendingGradientEnd = Color(0xFFFFA726);
  static const Color decorStar = Color(0xFFD7D3FF);
  static const Color decorStarMuted = Color(0xFFE4E1FF);
}

class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color divider;
  final Color border;
  final Color cardShadow;
  final Color iconBg;
  final Color priorityHighBg;
  final Color priorityMediumBg;
  final Color priorityLowBg;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color shimmerBlock;
  final Color bannerOfflineBg;
  final Color bannerSyncingBg;
  final Color bannerErrorBg;
  final Color bannerSuccessBg;
  final Color bannerSuccessText;
  final Color emptyTipBg;
  final Color headerSubtitle;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.divider,
    required this.border,
    required this.cardShadow,
    required this.iconBg,
    required this.priorityHighBg,
    required this.priorityMediumBg,
    required this.priorityLowBg,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.shimmerBlock,
    required this.bannerOfflineBg,
    required this.bannerSyncingBg,
    required this.bannerErrorBg,
    required this.bannerSuccessBg,
    required this.bannerSuccessText,
    required this.emptyTipBg,
    required this.headerSubtitle,
  });

  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ?? light;
  }

  static const light = AppPalette(
    background: Color(0xFFF7F6FB),
    surface: Colors.white,
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF6B7280),
    textHint: Color(0xFF9CA3AF),
    divider: Color(0xFFE5E7EB),
    border: Color(0xFFE6E8EE),
    cardShadow: Color(0x0A000000),
    iconBg: Color(0xFFEEEDFF),
    priorityHighBg: Color(0xFFFDE8E8),
    priorityMediumBg: Color(0xFFFFF3E0),
    priorityLowBg: Color(0xFFE8F5E9),
    shimmerBase: Color(0xFFE8EAF0),
    shimmerHighlight: Color(0xFFF7F8FB),
    shimmerBlock: Colors.white,
    bannerOfflineBg: Color(0xFFFFF4E5),
    bannerSyncingBg: Color(0xFFEEEDFF),
    bannerErrorBg: Color(0xFFFDECEA),
    bannerSuccessBg: Color(0xFFEAF8EE),
    bannerSuccessText: Color(0xFF2E9B57),
    emptyTipBg: Color(0xFFF3F1FF),
    headerSubtitle: Color(0xFF8B86A8),
  );

  static const dark = AppPalette(
    background: Color(0xFF101018),
    surface: Color(0xFF1C1C28),
    textPrimary: Color(0xFFF4F4F8),
    textSecondary: Color(0xFFA0A3B5),
    textHint: Color(0xFF7A7D8F),
    divider: Color(0xFF2E2E3E),
    border: Color(0xFF3A3A4C),
    cardShadow: Color(0x40000000),
    iconBg: Color(0xFF2A2750),
    priorityHighBg: Color(0xFF3D2224),
    priorityMediumBg: Color(0xFF3D3020),
    priorityLowBg: Color(0xFF1E3324),
    shimmerBase: Color(0xFF2A2A38),
    shimmerHighlight: Color(0xFF3A3A4A),
    shimmerBlock: Color(0xFF2A2A38),
    bannerOfflineBg: Color(0xFF3D2E1A),
    bannerSyncingBg: Color(0xFF2A2750),
    bannerErrorBg: Color(0xFF3D2224),
    bannerSuccessBg: Color(0xFF1A3324),
    bannerSuccessText: Color(0xFF81C784),
    emptyTipBg: Color(0xFF2A2750),
    headerSubtitle: Color(0xFFA0A3B5),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? divider,
    Color? border,
    Color? cardShadow,
    Color? iconBg,
    Color? priorityHighBg,
    Color? priorityMediumBg,
    Color? priorityLowBg,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? shimmerBlock,
    Color? bannerOfflineBg,
    Color? bannerSyncingBg,
    Color? bannerErrorBg,
    Color? bannerSuccessBg,
    Color? bannerSuccessText,
    Color? emptyTipBg,
    Color? headerSubtitle,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      cardShadow: cardShadow ?? this.cardShadow,
      iconBg: iconBg ?? this.iconBg,
      priorityHighBg: priorityHighBg ?? this.priorityHighBg,
      priorityMediumBg: priorityMediumBg ?? this.priorityMediumBg,
      priorityLowBg: priorityLowBg ?? this.priorityLowBg,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      shimmerBlock: shimmerBlock ?? this.shimmerBlock,
      bannerOfflineBg: bannerOfflineBg ?? this.bannerOfflineBg,
      bannerSyncingBg: bannerSyncingBg ?? this.bannerSyncingBg,
      bannerErrorBg: bannerErrorBg ?? this.bannerErrorBg,
      bannerSuccessBg: bannerSuccessBg ?? this.bannerSuccessBg,
      bannerSuccessText: bannerSuccessText ?? this.bannerSuccessText,
      emptyTipBg: emptyTipBg ?? this.emptyTipBg,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      iconBg: Color.lerp(iconBg, other.iconBg, t)!,
      priorityHighBg: Color.lerp(priorityHighBg, other.priorityHighBg, t)!,
      priorityMediumBg: Color.lerp(priorityMediumBg, other.priorityMediumBg, t)!,
      priorityLowBg: Color.lerp(priorityLowBg, other.priorityLowBg, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      shimmerBlock: Color.lerp(shimmerBlock, other.shimmerBlock, t)!,
      bannerOfflineBg: Color.lerp(bannerOfflineBg, other.bannerOfflineBg, t)!,
      bannerSyncingBg: Color.lerp(bannerSyncingBg, other.bannerSyncingBg, t)!,
      bannerErrorBg: Color.lerp(bannerErrorBg, other.bannerErrorBg, t)!,
      bannerSuccessBg: Color.lerp(bannerSuccessBg, other.bannerSuccessBg, t)!,
      bannerSuccessText: Color.lerp(bannerSuccessText, other.bannerSuccessText, t)!,
      emptyTipBg: Color.lerp(emptyTipBg, other.emptyTipBg, t)!,
      headerSubtitle: Color.lerp(headerSubtitle, other.headerSubtitle, t)!,
    );
  }
}
