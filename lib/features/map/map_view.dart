import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/app_dependencies.dart';
import '../../core/constants.dart';
import '../../core/design/dimens.dart';
import '../../data/models/earthquake.dart';
import '../../domain/usecases/get_magnitude_color_usecase.dart';
import '../../utils/location_permission_manager.dart';
import '../../widgets/error_alert_dialog.dart';
import '../../widgets/quake_loader.dart';
import '../earthquake_detail/earthquake_detail_view.dart';
import 'map_view_model.dart';

/// Mirrors Quake/Features/Map/MapView.swift — a full-screen map with a
/// color-coded marker per earthquake, a tap-to-reveal tooltip, and a
/// "center on my location" action (location permission handling included).
class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const _miamiFallback = LatLng(25.7743, -80.1942);
  static final _magnitudeColorUseCase = GetMagnitudeColorUseCase();

  late final MapViewModel _viewModel;
  final LocationPermissionManager _locationManager = LocationPermissionManager();
  final MapController _mapController = MapController();

  List<Earthquake> _earthquakes = [];
  Earthquake? _selectedEarthquake;
  Object? _lastHandledError;

  @override
  void initState() {
    super.initState();
    final deps = context.read<AppDependencies>();
    _viewModel = MapViewModel(getEarthquakesUseCase: deps.getEarthquakesUseCase);
    _viewModel.addListener(_onViewModelChanged);
    _locationManager.refreshStatus();
    if (!_locationManager.isAuthorized && !_locationManager.isDenied) {
      _locationManager.requestPermission();
    }
    _fetchEarthquakes();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _locationManager.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});

    if (_viewModel.error != null && _viewModel.error != _lastHandledError) {
      _lastHandledError = _viewModel.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showErrorLoadingListAlert(
          context: context,
          message: _viewModel.error.toString(),
          onRetry: _fetchEarthquakes,
        );
      });
    } else if (_viewModel.error == null) {
      _lastHandledError = null;
    }
  }

  Future<void> _fetchEarthquakes() async {
    final results = await _viewModel.getEarthquakesMarkers();
    if (!mounted) return;
    setState(() => _earthquakes = results);
  }

  Future<void> _centerOnUser() async {
    await _locationManager.requestPermission();
    if (!_locationManager.isAuthorized) return;
    try {
      final position = await Geolocator.getCurrentPosition();
      _mapController.move(LatLng(position.latitude, position.longitude), 9);
    } catch (_) {
      // Location unavailable — silently ignore, mirrors original best-effort behaviour.
    }
  }

  void _toggleTooltip(Earthquake earthquake) {
    setState(() {
      _selectedEarthquake = _selectedEarthquake?.id == earthquake.id ? null : earthquake;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _viewModel.isLoading && _earthquakes.isEmpty
          ? const QuakeLoader(label: 'Mapping seismic activity…')
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _miamiFallback,
                    initialZoom: 3.2,
                    onTap: (_, __) => setState(() => _selectedEarthquake = null),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.laurazp.quake',
                    ),
                    MarkerLayer(
                      markers: [
                        for (final earthquake in _earthquakes)
                          Marker(
                            point: LatLng(earthquake.latitude, earthquake.longitude),
                            width: 34,
                            height: 34,
                            child: GestureDetector(
                              onTap: () => _toggleTooltip(earthquake),
                              child: _MarkerDot(
                                color: _magnitudeColorUseCase
                                    .getMagnitudeColor(earthquake.originalMagnitude),
                                isSelected: _selectedEarthquake?.id == earthquake.id,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (_selectedEarthquake != null)
                  _Tooltip(
                    earthquake: _selectedEarthquake!,
                    onTap: () {
                      final quake = _selectedEarthquake!;
                      setState(() => _selectedEarthquake = null);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EarthquakeDetailView(earthquake: quake)),
                      );
                    },
                  ),
                if (_locationManager.isDenied)
                  Positioned(
                    left: Dimens.semiLargeMargin,
                    right: Dimens.semiLargeMargin,
                    bottom: Dimens.hugeMargin,
                    child: _PermissionBanner(onOpenSettings: Geolocator.openAppSettings),
                  ),
                Positioned(
                  right: Dimens.semiLargeMargin,
                  bottom: Dimens.semiLargeMargin,
                  child: FloatingActionButton(
                    heroTag: 'centerOnUser',
                    onPressed: _centerOnUser,
                    child: Icon(AppConstants.centerLocationIcon),
                  ),
                ),
              ],
            ),
    );
  }
}

class _MarkerDot extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _MarkerDot({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.5), blurRadius: 6, spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}

class _Tooltip extends StatelessWidget {
  final Earthquake earthquake;
  final VoidCallback onTap;

  const _Tooltip({required this.earthquake, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: Dimens.semiLargeMargin,
      right: Dimens.semiLargeMargin,
      top: Dimens.semiLargeMargin,
      child: SafeArea(
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          elevation: 6,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.mediumMargin),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          earthquake.simplifiedTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Magnitude ${earthquake.formattedMagnitude}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const _PermissionBanner({required this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.semiLargeMargin),
        child: Row(
          children: [
            const Expanded(
              child: Text('To see your location on the map, enable access from Settings.'),
            ),
            TextButton(onPressed: onOpenSettings, child: const Text('Open')),
          ],
        ),
      ),
    );
  }
}
