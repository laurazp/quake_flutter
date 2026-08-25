/// Raw USGS GeoJSON response models — mirrors
/// Quake/Entities/APIResponse.swift and Quake/Entities/Feature.swift.
class ApiResponse {
  final List<Feature> features;

  const ApiResponse({required this.features});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'] as List<dynamic>? ?? [];
    return ApiResponse(
      features: rawFeatures
          .map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Feature {
  final Property properties;
  final Geometry geometry;

  const Feature({required this.properties, required this.geometry});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      properties:
          Property.fromJson(json['properties'] as Map<String, dynamic>? ?? {}),
      geometry:
          Geometry.fromJson(json['geometry'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Property {
  final double? mag;
  final String? place;
  final int? time;
  final int? tsunami;
  final String? title;

  const Property({
    required this.mag,
    required this.place,
    required this.time,
    required this.tsunami,
    required this.title,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      mag: (json['mag'] as num?)?.toDouble(),
      place: json['place'] as String?,
      time: (json['time'] as num?)?.toInt(),
      tsunami: (json['tsunami'] as num?)?.toInt(),
      title: json['title'] as String?,
    );
  }
}

class Geometry {
  /// [longitude, latitude, depthInKm]
  final List<double> coordinates;

  const Geometry({required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    final raw = json['coordinates'] as List<dynamic>? ?? const [0.0, 0.0, 0.0];
    return Geometry(
      coordinates: raw.map((e) => (e as num).toDouble()).toList(),
    );
  }
}
