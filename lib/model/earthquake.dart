
import 'package:latlong2/latlong.dart';

class Earthquake {
  double magnitude;
  String place;
  double? time;
  String url;
  String tsunami;
  String title;
  LatLng originalCoordinates;
  String formattedCoordinates;
  String id;

  Earthquake({
    required this.magnitude,
    required this.place,
    required this.time,
    required this.url,
    required this.tsunami,
    required this.title,
    required this.originalCoordinates,
    required this.formattedCoordinates,
    required this.id,
  });
}

// class Properties {
//     double? mag;
//     String? place;
//     int? time;
//     String url;
//     int? tsunami;
//     String? title;

//     Properties({
//     required this.mag,
//     required this.place,
//     required this.time,
//     required this.url,
//     required this.tsunami,
//     required this.title,
//   });
// }

// class Geometry {
//     List<double> coordinates;

//     Geometry({
//     required this.coordinates,
//   });
// }