import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dimens.dart';

/// App-wide Material 3 theming. Two full themes (light + dark) are
/// provided; the app follows the system brightness by default, matching
/// the original SwiftUI app's automatic light/dark support.
abstract class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seismicTeal,
      brightness: brightness,
      surface: isDark ? AppColors.inkSurface : AppColors.lightSurface,
    );

    final background =
        isDark ? AppColors.inkBackground : AppColors.lightBackground;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: colorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isDark ? AppColors.inkSurface : AppColors.lightSurface,
        indicatorColor: AppColors.seismicTeal.withOpacity(0.18),
        elevation: 0,
        height: 66,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.seismicTeal : colorScheme.outline,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.seismicTeal : colorScheme.outline,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.inkSurface : AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
          side: BorderSide(
            color: isDark ? AppColors.inkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.inkBorder : AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isDark ? AppColors.inkSurfaceRaised : AppColors.lightSurfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.semiLargeMargin,
          vertical: Dimens.mediumMargin,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.seismicTeal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: Dimens.semiLargeMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? AppColors.inkSurfaceRaised : AppColors.lightSurfaceRaised,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
