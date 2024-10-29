import 'package:quake_flutter/data/earthquake/remote/mapper/earthquake_remote_mapper.dart';
import 'package:quake_flutter/data/earthquake/remote/model/earthquake_list_remote_model.dart';
import 'package:quake_flutter/model/earthquake.dart';

class EarthquakeListRemoteMapper {
  static List<Earthquake> fromRemote(FeatureCollection remoteModel) {
    List<Earthquake> earthquakes = remoteModel.features.map<Earthquake>((remoteItem) {
      return EarthquakeRemoteMapper.fromRemote(remoteItem);
    }).toList();

    return earthquakes;
  }
}