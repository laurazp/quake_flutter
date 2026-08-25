import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/dimens.dart';
import '../../../core/units_controller.dart';
import '../../../data/models/length_unit.dart';

/// Mirrors Quake/Features/Settings/Elements/UnitsView.swift.
class UnitsView extends StatelessWidget {
  const UnitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UnitsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Units')),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.semiLargeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Length', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Dimens.mediumMargin),
            SegmentedButton<LengthUnit>(
              segments: const [
                ButtonSegment(value: LengthUnit.kilometers, label: Text('Kilometers')),
                ButtonSegment(value: LengthUnit.miles, label: Text('Miles')),
              ],
              selected: {controller.unit},
              onSelectionChanged: (selection) => controller.setUnit(selection.first),
            ),
          ],
        ),
      ),
    );
  }
}
