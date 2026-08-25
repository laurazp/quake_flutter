import 'package:flutter/material.dart';
import '../../../core/design/dimens.dart';
import '../../../data/models/faq_item.dart';

/// Mirrors Quake/Features/Settings/Elements/FAQView.swift.
class FAQView extends StatelessWidget {
  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(Dimens.semiLargeMargin),
        itemCount: FaqData.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: Dimens.mediumMargin),
        itemBuilder: (context, index) {
          final item = FaqData.items[index];
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimens.semiLargeMargin),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.question,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: Dimens.smallMargin),
                Text(
                  item.answer,
                  style: TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
