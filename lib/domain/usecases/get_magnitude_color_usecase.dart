import 'package:flutter/material.dart';
import '../../core/design/app_colors.dart';

/// Mirrors Quake/UseCases/GetMagnitudeColorUseCase.swift — same three
/// magnitude tiers (< 3 green, 3-5 orange, >= 5 red).
class GetMagnitudeColorUseCase {
  Color getMagnitudeColor(double magnitude) => AppColors.magnitudeColor(magnitude);
}
