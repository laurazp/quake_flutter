import 'package:quake_flutter/data/earthquake/remote/model/earthquake_remote_model.dart';
import 'package:quake_flutter/model/earthquake.dart';

class EarthquakeRemoteMapper {
  static Earthquake fromRemote(Feature remoteModel) {
    return Earthquake(
      magnitude: remoteModel.properties.mag, 
      place: remoteModel.properties.place, 
      time: remoteModel.properties.time, 
      url: remoteModel.properties.url, 
      tsunami: remoteModel.properties.tsunami, 
      title: remoteModel.properties.title, 
      coordinates: remoteModel.geometry?.coordinates ?? [0.0, 0.0], //TODO: Manage null coordinates!
      id: remoteModel.id.toString()); //TODO: Manage id?
  }

  static Feature toRemote(Earthquake model) {
    return Feature(
      properties: RemoteProperties(
        mag: model.magnitude, 
        place: model.place, 
        time: model.time, 
        url: model.url, 
        tsunami: model.tsunami, 
        title: model.title),
      geometry: RemoteGeometry(coordinates: model.coordinates),
      id: model.id,
      // id: int.parse(model.id),
    );
  }

  // static Geometry _getCoordsFromGeometry(RemoteGeometry? geometry) {
  //   if (geometry != null) {
  //     return Geometry(coordinates: [geometry.coordinates[1], geometry.coordinates[0]]);
  //   } else {
  //     return Geometry(coordinates: [0.0, 0.0]);
  //   }
  // }

  // static Properties _getPropertiesFromRemote(RemoteProperties properties) {
  //   return Properties(
  //     mag: properties.mag, 
  //     place: properties.place, 
  //     time: properties.time, 
  //     url: properties.url, 
  //     tsunami: properties.tsunami, 
  //     title: properties.title);
  // }
}