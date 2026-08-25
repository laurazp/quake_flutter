import 'package:flutter/material.dart';
import '../core/design/dimens.dart';

/// Mirrors Quake/Widgets/CustomButton.swift — a pill-shaped secondary
/// action button used for the filter/sort/clear-filters controls.
class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isSmall;
  final bool isDestructive;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.isSmall = false,
    this.isDestructive = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = isDestructive ? scheme.error : scheme.onSurfaceVariant;

    return Material(
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.semiLargeMargin),
        side: isDestructive
            ? BorderSide(color: scheme.error.withOpacity(0.5))
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(Dimens.semiLargeMargin),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.semiLargeMargin,
            vertical: Dimens.mediumMargin,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: foreground,
                  fontSize: isSmall ? 13 : 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: Dimens.smallMargin),
                Icon(icon, size: isSmall ? 15 : 18, color: foreground),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
