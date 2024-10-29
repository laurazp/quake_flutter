
class Earthquake {
  double? magnitude;
  String? place;
  double? time;
  String url;
  int? tsunami;
  String? title;
  List<double> coordinates;
  String id;

  Earthquake({
    required this.magnitude,
    required this.place,
    required this.time,
    required this.url,
    required this.tsunami,
    required this.title,
    required this.coordinates,
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