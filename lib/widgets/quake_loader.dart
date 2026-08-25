import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/design/app_colors.dart';

/// A seismograph-style animated loader — the modernized, on-theme
/// replacement for Quake/Widgets/QuakeLoader.swift's spinning ring. Draws a
/// scrolling seismic trace instead of a generic spinner.
class QuakeLoader extends StatefulWidget {
  final String? label;

  const QuakeLoader({super.key, this.label});

  @override
  State<QuakeLoader> createState() => _QuakeLoaderState();
}

class _QuakeLoaderState extends State<QuakeLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 140,
            height: 56,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _SeismicTracePainter(
                    progress: _controller.value,
                    color: AppColors.seismicTeal,
                  ),
                );
              },
            ),
          ),
          if (widget.label != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.label!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SeismicTracePainter extends CustomPainter {
  final double progress;
  final Color color;

  _SeismicTracePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final midY = size.height / 2;
    final path = Path()..moveTo(0, midY);

    const step = 4.0;
    final phase = progress * 2 * math.pi;

    for (double x = 0; x <= size.width; x += step) {
      final t = x / size.width;
      // A quake-like burst of amplitude travels left-to-right.
      final burstCenter = (progress * 1.6) % 1.6 - 0.3;
      final distance = (t - burstCenter).abs();
      final envelope = math.exp(-distance * distance * 40) * (size.height * 0.42);
      final wobble = math.sin(x * 0.6 + phase * 3) * envelope;
      path.lineTo(x, midY - wobble);
    }

    canvas.drawPath(path, paint);

    // Baseline
    final basePaint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), basePaint);
  }

  @override
  bool shouldRepaint(covariant _SeismicTracePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
