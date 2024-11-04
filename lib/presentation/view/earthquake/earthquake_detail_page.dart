import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:quake_flutter/core/di/app_modules.dart';
import 'package:quake_flutter/core/formatters/magnitude_color_formatter.dart';
import 'package:quake_flutter/model/earthquake.dart';
import 'package:quake_flutter/presentation/model/resource_state.dart';
import 'package:quake_flutter/presentation/view/earthquake/viewmodel/earthquakes_view_model.dart';
import 'package:quake_flutter/presentation/widget/error/error_view.dart';
import 'package:quake_flutter/presentation/widget/loading/loading_view.dart';

class EarthquakeDetailPage extends StatefulWidget {
  const EarthquakeDetailPage({super.key, required this.earthquakeId});

  final String earthquakeId;

  @override
  State<EarthquakeDetailPage> createState() => _EarthquakeDetailPageState();
}

class _EarthquakeDetailPageState extends State<EarthquakeDetailPage> {
  final EarthquakesViewModel _earthquakesViewModel = inject<EarthquakesViewModel>();
  final MapController _mapController = MapController();

  Earthquake? _earthquake;

  @override
  void initState() {
    super.initState();

    _earthquakesViewModel.getEarthquakeDetailState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          setState(() {
            LoadingView.hide();
            _earthquake = state.data;
          });
          break;
        case Status.ERROR:
          debugPrint("Error: ${state.exception.toString()}");
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception.toString(), () {
              _earthquakesViewModel.fetchEarthquakeDetail(widget.earthquakeId);
            });
          });
          break;
      }
    });

    _earthquakesViewModel.fetchEarthquakeDetail(widget.earthquakeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            _earthquake?.title ?? 'Unknown',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: _getContentView());
  }

  Widget _getContentView() {
    if (_earthquake == null) return Container();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            earthquakeInfoDetail("Place", _earthquake?.place ?? "Unknown", false),
                            earthquakeInfoDetail("Time", _earthquake?.time.toString() ?? "time", false), //TODO: Manage
                            earthquakeInfoDetail("Tsunami", _earthquake?.tsunami.toString() ?? "tsunami", false), //TODO: Manage
                            earthquakeInfoDetail("Coords", _earthquake?.formattedCoordinates.toString() ?? "[0.0, 0.0]", false), //TODO: Manage
                            earthquakeInfoDetail("Depth", "depth", false), //TODO: Depth mapper
                            earthquakeInfoDetail("Magnitude", _earthquake?.magnitude.toString() ?? "0.0", true),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // child: const Center(child: Text("Map Card")),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialZoom: 5,
                            initialCenter: _earthquake?.originalCoordinates ?? const LatLng(0.0, 0.0), //TODO: Manage null coordinates
                            // LatLng(0.0, 0.0)
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              tileProvider: CancellableNetworkTileProvider(),
                            ),
                            MarkerLayer(markers: [
                              Marker(
                                point: _earthquake?.originalCoordinates ??
                                    const LatLng(0.0, 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(_earthquake?.title ??
                                                "Unknown")));
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.pink,
                                    size: 40,
                                  ),
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // MyLocationButton(
                    //     location: _earthquake?.coords ??
                    //         const LatLng(41.649693, -0.887712),
                    //     mapController: _mapController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column earthquakeInfoDetail(String title, String description, bool isMagnitude) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "$title: ",
          style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(description,
        style: isMagnitude
            ? MagnitudeColorFormatter.getMagnitudeColor(_earthquake?.magnitude ?? 0.0)
            : null),
      ]
    );
  }

  @override
  void dispose() {
    _earthquakesViewModel.dispose();
    super.dispose();
  }
}
