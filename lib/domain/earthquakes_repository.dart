import 'package:quake_flutter/model/earthquake_list.dart';

abstract class EarthquakesRepository {
  Future<EarthquakeList> getEarthquakeList(String startTime, String endTime, int limit, int offset);
  // Future<List<Feature>> getMapEarthquakeList();
  // Future<Feature> getEarthquakeDetail(String earthquakeId);
}