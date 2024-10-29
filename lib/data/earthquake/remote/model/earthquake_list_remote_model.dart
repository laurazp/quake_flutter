
import 'package:quake_flutter/data/earthquake/remote/model/earthquake_remote_model.dart';

class FeatureCollection {
  List<Feature> features;

  FeatureCollection({
    required this.features,
  });

  factory FeatureCollection.fromMap(Map<String, dynamic> json) =>
      FeatureCollection(
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
      };
}
