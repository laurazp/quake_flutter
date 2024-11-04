import 'package:quake_flutter/core/formatters/earthquake_coords_formatter.dart';
import 'package:quake_flutter/model/earthquake.dart';

class Feature {
  RemoteProperties properties;
  RemoteGeometry? geometry;
  String id;

  Feature({
    required this.properties,
    required this.geometry,
    required this.id,
  });

  factory Feature.fromMap(Map<String, dynamic> json) =>
      Feature(
        properties: RemoteProperties.fromMap(json["properties"]),
        geometry: json["geometry"] == null
            ? null
            : RemoteGeometry.fromMap(json["geometry"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "properties": properties.toMap(),
        "geometry": geometry?.toMap(),
         "id": id,
      };

  Earthquake toEarthquake() {
    return Earthquake(
      magnitude: properties.mag, 
      place: properties.place, 
      time: properties.time, 
      url: properties.url, 
      tsunami: properties.tsunami.toString(), 
      title: properties.title, 
      coordinates: EarthquakeCoordsFormatter.getFormattedCoords(geometry?.coordinates ?? [0.0, 0.0]), //TODO: Manage null coordinates!
      id: id
    );
  }
}

class RemoteProperties {
  double? mag;
  String? place;
  double? time;
  String url;
  int? tsunami;
  String? title;

  RemoteProperties({
    required this.mag,
    required this.place,
    required this.time,
    required this.url,
    required this.tsunami,
    required this.title,
  });

  factory RemoteProperties.fromMap(Map<String, dynamic> json) => RemoteProperties(
    mag: _toDouble(json["mag"]),
    place: json["place"],
    time: _toDouble(json["time"]),
    url: json["url"],
    tsunami: json["tsunami"],
    title: json["title"],
  );

  Map<String, dynamic> toMap() => {
    "mag": mag,
    "place": place,
    "time": time,
    "url": url,
    "tsunami": tsunami,
    "title": title,
  };

  // Helper function to convert values to double
  static double? _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    }
    return null; // Handle null case if the field is not present
  }
}

class RemoteGeometry {
  List<double> coordinates;

  RemoteGeometry({
    required this.coordinates,
  });

  factory RemoteGeometry.fromMap(Map<String, dynamic> json) => RemoteGeometry(
    coordinates: _toDoubleList(json["coordinates"]),
  );

  Map<String, dynamic> toMap() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };

      // Helper function to ensure all items in the list are doubles
  static List<double> _toDoubleList(List<dynamic> values) {
    return values.map((value) {
      if (value is int) {
        return value.toDouble();
      } else if (value is double) {
        return value;
      }
      return 0.0; // Default to 0.0 if value is null or an unexpected type
    }).toList();
  }
}
