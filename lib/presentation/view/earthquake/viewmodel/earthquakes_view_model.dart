import 'dart:async';

import 'package:quake_flutter/domain/earthquakes_repository.dart';
import 'package:quake_flutter/model/earthquake_list.dart';
import 'package:quake_flutter/model/earthquake.dart';
import 'package:quake_flutter/presentation/base/base_view_model.dart';
import 'package:quake_flutter/presentation/model/resource_state.dart';

class EarthquakesViewModel extends BaseViewModel {
  final EarthquakesRepository _earthquakesRepository;

  final StreamController<ResourceState<EarthquakeList>> getEarthquakeListState =
      StreamController();
  final StreamController<ResourceState<Earthquake>> getEarthquakeDetailState =
      StreamController();
  final StreamController<ResourceState<List<Earthquake>>>
      getMapEarthquakeListState = StreamController();

  EarthquakesViewModel({required EarthquakesRepository earthquakesRepository})
      : _earthquakesRepository = earthquakesRepository;

  // fetchMapEarthquakeList() {
  //   getMapEarthquakeListState.add(ResourceState.loading());

  //   _earthquakesRepository
  //       .getMapEarthquakeList()
  //       .then((value) =>
  //           getMapEarthquakeListState.add(ResourceState.success(value)))
  //       .catchError(
  //           (error) => getMapEarthquakeListState.add(ResourceState.error(error)));
  // }

  fetchPagingEarthquakeList(String startTime, String endTime, int limit, int offset) {
    getEarthquakeListState.add(ResourceState.loading());

    _earthquakesRepository
        .getEarthquakeList(startTime, endTime, limit, offset)
        .then((value) => getEarthquakeListState.add(ResourceState.success(value)))
        .catchError(
            (error) => getEarthquakeListState.add(ResourceState.error(error)));
  }

  fetchEarthquakeDetail(String earthquakeId) {
    getEarthquakeDetailState.add(ResourceState.loading());

    _earthquakesRepository
        .getEarthquakeDetail(earthquakeId)
        .then(
            (value) => getEarthquakeDetailState.add(ResourceState.success(value)))
        .catchError(
            (error) => getEarthquakeDetailState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getEarthquakeListState.close();
  }
}
