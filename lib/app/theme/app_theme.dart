import 'package:ethic_fin_todo_assessment/exports.dart';

class AppTheme {
  static ThemeData get lightTheme => _build(AppPalette.light, Brightness.light);

  static ThemeData get darkTheme => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseTextTheme = isDark
        ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [palette],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: palette.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.surface,
      textTheme: baseTextTheme.apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: AppSizes.sp20,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r16),
          side: BorderSide(color: palette.divider.withValues(alpha: 0.5)),
        ),
        color: palette.surface,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r14),
          side: BorderSide(color: palette.border),
        ),
        textStyle: GoogleFonts.inter(color: palette.textPrimary),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.r20)),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: palette.surface,
        headerBackgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        headerForegroundColor: palette.textPrimary,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return palette.textHint;
          return palette.textPrimary;
        }),
        yearForegroundColor: WidgetStatePropertyAll(palette.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColors.primary, width: AppSizes.borderStrong),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h14),
        hintStyle: GoogleFonts.inter(
          color: palette.textHint,
          fontSize: AppSizes.sp14,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r20),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: AppSizes.border,
      ),
      iconTheme: IconThemeData(color: palette.textPrimary),
    );
  }
}
