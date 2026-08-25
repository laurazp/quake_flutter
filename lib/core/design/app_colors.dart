import 'package:flutter/material.dart';

/// Seismic-inspired color system.
///
/// The palette leans on a deep "fault line" ink for dark surfaces and a
/// teal/cyan "seismic wave" accent for the brand, while keeping the
/// original app's magnitude semantics (green / amber / red) intact so the
/// data reads exactly the same way it did in the iOS app.
abstract class AppColors {
  // Brand
  static const Color seismicTeal = Color(0xFF16B8B0);
  static const Color seismicTealDark = Color(0xFF0E8A85);
  static const Color seismicAmber = Color(0xFFFFA940);

  // Dark "fault line" surfaces
  static const Color inkBackground = Color(0xFF0A1220);
  static const Color inkSurface = Color(0xFF121C2E);
  static const Color inkSurfaceRaised = Color(0xFF182437);
  static const Color inkBorder = Color(0xFF223047);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF4F7F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFEFF4F5);
  static const Color lightBorder = Color(0xFFE0E7E9);

  // Magnitude scale — mirrors GetMagnitudeColorUseCase (<3 / 3-5 / >=5)
  static const Color magnitudeLow = Color(0xFF2ECC71); // green
  static const Color magnitudeMedium = Color(0xFFFF9F0A); // orange
  static const Color magnitudeHigh = Color(0xFFFF3B30); // red

  static Color magnitudeColor(double magnitude) {
    if (magnitude < 3) return magnitudeLow;
    if (magnitude < 5) return magnitudeMedium;
    return magnitudeHigh;
  }

  // Feedback / settings row accent colors (mirrors Constants.Design.Colors)
  static const Color mint = Color(0xFF17C3B2);
  static const Color orange = Color(0xFFFF9500);
  static const Color red = Color(0xFFFF3B30);
  static const Color blue = Color(0xFF0A84FF);
  static const Color green = Color(0xFF34C759);
}
