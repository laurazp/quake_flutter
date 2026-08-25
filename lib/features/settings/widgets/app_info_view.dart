import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/design/dimens.dart';
import '../../../widgets/custom_link.dart';

/// Mirrors Quake/Features/Settings/Elements/AppInfoView.swift.
class AppInfoView extends StatelessWidget {
  const AppInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Info')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.semiLargeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('General info', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Dimens.smallMargin),
            const CustomLink(
              text: 'Data source credits belongs to USGS (United States Geological Survey)',
              linkText: 'USGS (United States Geological Survey)',
              linkUrl: AppConstants.usgsCreditUrl,
            ),
            const SizedBox(height: Dimens.largeMargin),
            const Divider(),
            const SizedBox(height: Dimens.largeMargin),
            Text('Credits', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Dimens.smallMargin),
            const CustomLink(
              text: 'Seismic icons created by Freepik - Flaticon',
              linkText: 'Freepik - Flaticon',
              linkUrl: AppConstants.flaticonSeismicUrl,
            ),
            const SizedBox(height: Dimens.mediumMargin),
            const CustomLink(
              text: 'Earthquake icons created by fjstudio - Flaticon',
              linkText: 'fjstudio - Flaticon',
              linkUrl: AppConstants.flaticonEarthquakeUrl,
            ),
            const SizedBox(height: Dimens.mediumMargin),
            const CustomLink(
              text:
                  'Feedback form based on original CTFeedbackSwift Package from rizumita - Github',
              linkText: 'rizumita - Github',
              linkUrl: AppConstants.ctFeedbackSwiftUrl,
            ),
            const SizedBox(height: Dimens.largeMargin),
            const Divider(),
            const SizedBox(height: Dimens.largeMargin),
            Text('Rebuilt in Flutter', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Dimens.smallMargin),
            Text(
              'This app mirrors the original iOS Quake app, rebuilt for Flutter with a '
              'refreshed seismic-themed interface.',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
