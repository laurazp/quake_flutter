import 'package:quake_flutter/data/earthquake/remote/earthquakes_remote_impl.dart';
import 'package:quake_flutter/domain/earthquakes_repository.dart';
import 'package:quake_flutter/model/earthquake_list.dart';
// import 'package:quake_flutter/model/feature.dart';

class EarthquakesDataImpl extends EarthquakesRepository {
  final EarthquakesRemoteImpl _remoteApiImpl;

  EarthquakesDataImpl(
      {required EarthquakesRemoteImpl remoteImpl})
      : _remoteApiImpl = remoteImpl;

  @override
  Future<EarthquakeList> getEarthquakeList(String startTime, String endTime, int limit, int offset) {
    return _remoteApiImpl.getEarthquakeList(startTime, endTime, limit, offset);
  }

  // @override
  // Future<List<Feature>> getMapEarthquakeList() {
  //   return _remoteApiImpl.getEarthquakeListForMap(startTime, endTime, limit, offset);
  // }

  // @override
  // Future<Feature> getEarthquakeDetail(String earthquakeId) async {
  //   final remoteEarthquake = await _remoteApiImpl.getEarthquakeDetail(earthquakeId);
  //   return remoteEarthquake;
  // }
}
