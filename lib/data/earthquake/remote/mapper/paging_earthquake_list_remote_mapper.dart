import 'package:quake_flutter/data/earthquake/remote/mapper/earthquake_remote_mapper.dart';
import 'package:quake_flutter/data/earthquake/remote/model/earthquake_list_remote_model.dart';
import 'package:quake_flutter/model/earthquake_list.dart';
import 'package:quake_flutter/model/earthquake.dart';

class PagingEarthquakeListRemoteMapper {
  static EarthquakeList fromRemote(FeatureCollection remoteModel) {
    EarthquakeList monumentList = EarthquakeList(
        earthquakes: remoteModel.features.map<Earthquake>((remoteItem) {
          return EarthquakeRemoteMapper.fromRemote(remoteItem);
        }).toList(),
    );

    return monumentList;
  }
}