import 'package:flutter/foundation.dart';
import '../../data/models/earthquake.dart';
import '../../domain/usecases/get_earthquakes_usecase.dart';

/// Mirrors Quake/Features/Map/MapViewModel.swift.
class MapViewModel extends ChangeNotifier {
  final GetEarthquakesUseCase getEarthquakesUseCase;

  MapViewModel({required this.getEarthquakesUseCase});

  List<Earthquake> earthquakes = [];
  bool isLoading = false;
  Object? error;

  Future<List<Earthquake>> getEarthquakesMarkers() async {
    error = null;
    isLoading = true;
    notifyListeners();

    try {
      earthquakes = await getEarthquakesUseCase.getLatestEarthquakes(offset: 1, pageSize: 2000);
      return earthquakes;
    } catch (e) {
      error = e;
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
