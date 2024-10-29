import 'package:flutter/material.dart';
import 'package:quake_flutter/di/app_modules.dart';
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
  // final MapController _mapController = MapController();

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
            _earthquake?.title ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: _getContentView());
  }

  Widget _getContentView() {
    // final provider = Provider.of<FavoritesProvider>(context, listen: false);

    // if (_earthquake == null) return Container();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Text(_earthquake?.title ?? "Unknown")
    //             child: Column(
    //               children: [
    //                 Stack(children: [
    //                   ClipRRect(
    //                     borderRadius: BorderRadius.circular(10),
    //                     child: CachedNetworkImage(
    //                       placeholder: (context, url) {
    //                         return const Image(
    //                             image: AssetImage(
    //                                 "assets/images/church_icon.jpeg"));
    //                       },
    //                       errorWidget: (context, url, error) {
    //                         return const Image(
    //                             image: AssetImage(
    //                                 "assets/images/church_icon.jpeg"));
    //                       },
    //                       imageUrl: _earthquake!.image,
    //                       width: double.infinity,
    //                       fit: BoxFit.contain,
    //                     ),
    //                   ),
    //                   Positioned(
    //                     top: 16.0,
    //                     right: 16.0,
    //                     child: FloatingActionButton(
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(30.0),
    //                       ),
    //                       onPressed: () {
    //                         setState(() {
    //                           if (!_earthquake!.isFavorite) {
    //                             _earthquake!.isFavorite = true;
    //                             provider.addToFavorites(_earthquake!);
    //                             provider.getFavorites();
    //                           } else {
    //                             _earthquake!.isFavorite = false;
    //                             provider.deleteFromFavorites(_earthquake!);
    //                             provider.getFavorites();
    //                           }
    //                         });
    //                       },
    //                       child: _earthquake!.isFavorite
    //                           ? const Icon(Icons.favorite, color: Colors.red)
    //                           : const Icon(Icons.favorite_border),
    //                     ),
    //                   ),
    //                 ]),
    //                 Padding(
    //                   padding: const EdgeInsets.all(12.0),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const SizedBox(height: 16),
    //                       const Text(
    //                         "Description: ",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),
    //                       const SizedBox(height: 8),
    //                       Text(_earthquake!.description),
    //                       const SizedBox(height: 16),
    //                       const Text(
    //                         "Style: ",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),
    //                       Text(
    //                         _earthquake!.style.toUpperCase(),
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 3,
    //                       ),
    //                       const SizedBox(height: 16),
    //                       const Text(
    //                         "Opening hours: ",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),
    //                       const SizedBox(height: 8),
    //                       Text(_earthquake!.hours),
    //                       const SizedBox(height: 16),
    //                       const Text(
    //                         "Address: ",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),
    //                       const SizedBox(height: 8),
    //                       Text(_earthquake!.address),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(height: 8),
    //           Card(
    //             elevation: 5,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //             child: Stack(
    //               children: [
    //                 SizedBox(
    //                   height: 400,
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(10),
    //                     child: FlutterMap(
    //                       mapController: _mapController,
    //                       options: MapOptions(
    //                         initialZoom: 17,
    //                         initialCenter: _earthquake?.coords ??
    //                             const LatLng(41.649693, -0.887712),
    //                       ),
    //                       children: [
    //                         TileLayer(
    //                           urlTemplate:
    //                               "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    //                           tileProvider: CancellableNetworkTileProvider(),
    //                         ),
    //                         MarkerLayer(markers: [
    //                           Marker(
    //                             point: _earthquake?.coords ??
    //                                 const LatLng(41.649693, -0.887712),
    //                             child: GestureDetector(
    //                               onTap: () {
    //                                 ScaffoldMessenger.of(context).showSnackBar(
    //                                     SnackBar(
    //                                         content: Text(_earthquake?.title ??
    //                                             "Unknown Monument")));
    //                               },
    //                               child: const Icon(
    //                                 Icons.location_on,
    //                                 color: Colors.pink,
    //                                 size: 40,
    //                               ),
    //                             ),
    //                           )
    //                         ]),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 MyLocationButton(
    //                     location: _earthquake?.coords ??
    //                         const LatLng(41.649693, -0.887712),
    //                     mapController: _mapController),
    //               ],
    //             ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _earthquakesViewModel.dispose();
    super.dispose();
  }
}
