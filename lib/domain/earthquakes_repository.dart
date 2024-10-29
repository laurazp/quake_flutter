import 'package:quake_flutter/model/earthquake.dart';
import 'package:quake_flutter/model/earthquake_list.dart';

abstract class EarthquakesRepository {
  Future<EarthquakeList> getEarthquakeList(String startTime, String endTime, int limit, int offset);
  // Future<List<Feature>> getMapEarthquakeList();
  Future<Earthquake> getEarthquakeDetail(String earthquakeId);
}