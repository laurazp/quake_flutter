import 'package:flutter/material.dart';
import '../core/design/dimens.dart';

/// Mirrors Quake/Widgets/FeedbackCard.swift — a rounded, elevated
/// container used to group related fields in the Feedback form.
class FeedbackCard extends StatelessWidget {
  final List<Widget> children;

  const FeedbackCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimens.semiLargeMargin),
      padding: const EdgeInsets.all(Dimens.semiLargeMargin),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
