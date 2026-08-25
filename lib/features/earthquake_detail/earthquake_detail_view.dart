import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/design/dimens.dart';
import '../../data/models/earthquake.dart';
import '../../domain/usecases/get_magnitude_color_usecase.dart';

/// Mirrors Quake/Features/Earthquakes/EarthquakesDetailView/EarthquakeDetailView.swift
/// — full earthquake details plus a small map centered on the epicenter.
class EarthquakeDetailView extends StatelessWidget {
  final Earthquake earthquake;
  static final _magnitudeColorUseCase = GetMagnitudeColorUseCase();

  const EarthquakeDetailView({super.key, required this.earthquake});

  @override
  Widget build(BuildContext context) {
    final color = _magnitudeColorUseCase.getMagnitudeColor(earthquake.originalMagnitude);
    final point = LatLng(earthquake.latitude, earthquake.longitude);

    final rows = <(String, String, bool)>[
      ('Place', earthquake.place, false),
      ('Date', earthquake.date, false),
      ('Tsunami', earthquake.tsunami, false),
      ('Coords', earthquake.formattedCoords, false),
      ('Depth', earthquake.depth, false),
      ('Magnitude', earthquake.formattedMagnitude, true),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(earthquake.simplifiedTitle, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.semiLargeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(Dimens.semiLargeMargin),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.mediumMargin),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 96,
                            child: Text(
                              '${row.$1}:',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row.$2,
                              style: row.$3
                                  ? TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 16)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.semiLargeMargin),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
              child: SizedBox(
                height: Dimens.mapDetailHeight,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: point,
                    initialZoom: 8,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.laurazp.quake',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          child: Icon(Icons.location_on, color: color, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
