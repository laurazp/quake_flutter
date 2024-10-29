import 'package:flutter_map/flutter_map.dart';

class MarkerInfo {
  String title;
  Marker marker;
  String earthquakeId;

  MarkerInfo(
      {required this.title, required this.marker, required this.earthquakeId});
}
