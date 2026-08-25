import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/dimens.dart';
import '../../../data/models/earthquake.dart';
import '../../../data/models/length_unit.dart';
import '../../../domain/usecases/get_magnitude_color_usecase.dart';
import '../../../utils/formatters/localized_place_formatter.dart';

/// Mirrors Quake/Features/Earthquakes/EarthquakesView/EarthquakeItemView.swift
/// — an expandable card for one earthquake.
///
/// Redesigned to read less like a plain disclosure row and more like a
/// small seismic "event card": a magnitude-colored edge + gradient wash
/// tie the card's color to its severity, the magnitude badge is a mini
/// gauge instead of flat text, and the expanded details render as a grid
/// of icon chips instead of a label/value list.
class EarthquakeItem extends StatefulWidget {
  final Earthquake earthquake;
  final LengthUnit unit;
  final VoidCallback onSeeDetails;

  const EarthquakeItem({
    super.key,
    required this.earthquake,
    required this.unit,
    required this.onSeeDetails,
  });

  @override
  State<EarthquakeItem> createState() => _EarthquakeItemState();
}

class _EarthquakeItemState extends State<EarthquakeItem> {
  static final _placeFormatter = LocalizedPlaceFormatter();
  static final _magnitudeColorUseCase = GetMagnitudeColorUseCase();

  bool _isExpanded = false;
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final quake = widget.earthquake;
    final color =
        _magnitudeColorUseCase.getMagnitudeColor(quake.originalMagnitude);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.semiLargeMargin,
        vertical: Dimens.extraSmallMargin,
      ),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.seismicTeal.withOpacity(isDark ? 0.22 : 0.13),
                  scheme.surface,
                ],
              ),
              border: Border.all(
                  color: color.withOpacity(_isExpanded ? 0.55 : 0.28)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isDark ? 0.22 : 0.16),
                  blurRadius: _isExpanded ? 18 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimens.semiLargeMargin),
                          child: Row(
                            children: [
                              _MagnitudeGauge(
                                magnitude: quake.originalMagnitude,
                                label: quake.formattedMagnitude,
                                color: color,
                              ),
                              const SizedBox(width: Dimens.mediumMargin),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quake.simplifiedTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Icon(Icons.schedule_rounded,
                                            size: 13, color: scheme.outline),
                                        const SizedBox(width: 4),
                                        Text(
                                          _relativeTimeLabel(
                                              quake.originalDate),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: scheme.outline,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: Dimens.smallMargin),
                              _ChevronButton(
                                  isExpanded: _isExpanded, color: color),
                            ],
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox(width: double.infinity),
                          secondChild: _DetailsGrid(
                            quake: quake,
                            unit: widget.unit,
                            color: color,
                            onSeeDetails: widget.onSeeDetails,
                            formatter: _placeFormatter,
                          ),
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 220),
                          sizeCurve: Curves.easeInOut,
                        ),
                      ],
                    ),
                  ),
                  // Severity edge
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 5, color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "2h ago" / "3d ago" style relative timestamp — gives each card a
/// living, at-a-glance sense of recency instead of a static date string.
String _relativeTimeLabel(DateTime originalDateUtc) {
  final now = DateTime.now().toUtc();
  final diff = now.difference(originalDateUtc);

  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  return '${(diff.inDays / 30).floor()}mo ago';
}

/// A small circular "seismograph gauge": a track ring, a proportional
/// arc sized by magnitude, and a gradient-filled center showing the
/// magnitude value — replaces the old flat colored number.
class _MagnitudeGauge extends StatelessWidget {
  final double magnitude;
  final String label;
  final Color color;

  const _MagnitudeGauge({
    required this.magnitude,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Purely decorative fill proportion — magnitudes realistically sit
    // well under 10, so this keeps the ring readably full without
    // needing to be a literal 0-10 scale.
    final double progress = (magnitude / 8.0).clamp(0.12, 1.0).toDouble();

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(56, 56),
            painter: _GaugePainter(progress: progress, color: color),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, Colors.black, 0.25)!],
              ),
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.45),
                    blurRadius: 10,
                    spreadRadius: 0.5),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;

  _GaugePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 2;

    final track = Paint()
      ..color = color.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, track);

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _ChevronButton extends StatelessWidget {
  final bool isExpanded;
  final Color color;

  const _ChevronButton({required this.isExpanded, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(isExpanded ? 0.22 : 0.12),
      ),
      alignment: Alignment.center,
      child: AnimatedRotation(
        turns: isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 200),
        child: Icon(Icons.expand_more_rounded, color: color, size: 20),
      ),
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  final Earthquake quake;
  final LengthUnit unit;
  final Color color;
  final VoidCallback onSeeDetails;
  final LocalizedPlaceFormatter formatter;

  const _DetailsGrid({
    required this.quake,
    required this.unit,
    required this.color,
    required this.onSeeDetails,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.semiLargeMargin,
        0,
        Dimens.semiLargeMargin,
        Dimens.semiLargeMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoPill(
            icon: Icons.place_rounded,
            label: 'Place',
            value: formatter.format(quake.place, unit),
            color: color,
            fullWidth: true,
          ),
          const SizedBox(height: Dimens.smallMargin),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoPill(
                  icon: Icons.event_rounded,
                  label: 'Date',
                  value: quake.date,
                  color: color,
                ),
              ),
              const SizedBox(width: Dimens.smallMargin),
              Expanded(
                child: _InfoPill(
                  icon: Icons.waves_rounded,
                  label: 'Tsunami',
                  value: quake.tsunami,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.smallMargin),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoPill(
                  icon: Icons.explore_rounded,
                  label: 'Coords',
                  value: quake.formattedCoords,
                  color: color,
                ),
              ),
              const SizedBox(width: Dimens.smallMargin),
              Expanded(
                child: _InfoPill(
                  icon: Icons.layers_rounded,
                  label: 'Depth',
                  value: quake.depth,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.mediumMargin),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onSeeDetails,
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.semiLargeMargin,
                  vertical: Dimens.smallMargin,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.hugeMargin),
                ),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('See details',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool fullWidth;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(Dimens.smallMargin),
      decoration: BoxDecoration(
        color: AppColors.seismicTeal.withOpacity(0.06),
        borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color.withOpacity(0.18), shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: Dimens.smallMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: scheme.outline,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
