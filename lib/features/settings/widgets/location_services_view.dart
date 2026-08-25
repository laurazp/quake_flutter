import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/dimens.dart';
import '../../../utils/location_permission_manager.dart';

/// Mirrors Quake/Features/Settings/Elements/LocationServicesView.swift.
class LocationServicesView extends StatefulWidget {
  const LocationServicesView({super.key});

  @override
  State<LocationServicesView> createState() => _LocationServicesViewState();
}

class _LocationServicesViewState extends State<LocationServicesView> {
  final LocationPermissionManager _manager = LocationPermissionManager();

  @override
  void initState() {
    super.initState();
    _manager.addListener(() => setState(() {}));
    _manager.refreshStatus();
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthorized = _manager.isAuthorized;
    final isDenied = _manager.isDenied;

    return Scaffold(
      appBar: AppBar(title: const Text('Location Services')),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.hugeMargin),
        child: Column(
          children: [
            const SizedBox(height: Dimens.hugeMargin),
            Icon(
              AppConstants.locationPermissionsIcon,
              size: 80,
              color: AppColors.seismicTeal,
            ),
            const SizedBox(height: Dimens.largeMargin),
            Text(
              isAuthorized ? 'Permission granted' : 'Allow access to your location',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.smallMargin),
            Text(
              isAuthorized
                  ? 'Thanks for allowing location access.'
                  : 'The app needs access to your location to show relevant nearby earthquake data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: Dimens.hugeMargin),
            if (!isAuthorized)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: isDenied
                      ? ElevatedButton.styleFrom(backgroundColor: AppColors.orange)
                      : null,
                  onPressed: isDenied
                      ? Geolocator.openAppSettings
                      : () => _manager.requestPermission(),
                  child: Text(isDenied ? 'Open Settings' : 'Allow access'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
