import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:quake_flutter/core/formatters/earthquake_coords_formatter.dart';
import 'package:quake_flutter/core/formatters/earthquake_title_formatter.dart';
import 'package:quake_flutter/core/formatters/tsunami_value_formatter.dart';
import 'package:quake_flutter/data/earthquake/remote/model/earthquake_remote_model.dart';
import 'package:quake_flutter/model/earthquake.dart';

class EarthquakeRemoteMapper {
  static Earthquake fromRemote(Feature remoteModel) {
    return Earthquake(
      magnitude: remoteModel.properties.mag ?? 0.0, 
      place: remoteModel.properties.place ?? "Unknown", 
      time: remoteModel.properties.time, 
      url: remoteModel.properties.url, 
      tsunami: TsunamiValueFormatter.getTsunamiValue(remoteModel.properties.tsunami ?? 0), 
      title: EarthquakeTitleFormatter.getSimplifiedTitle(remoteModel.properties.title ?? "", remoteModel.properties.place ?? ""),
      originalCoordinates: LatLng(remoteModel.geometry?.coordinates[1] ?? 0.0, remoteModel.geometry?.coordinates[0] ?? 0.0), //TODO: Manage null coordinates!
      formattedCoordinates: EarthquakeCoordsFormatter.getFormattedCoords(remoteModel.geometry?.coordinates), 
      id: remoteModel.id.toString()); //TODO: Manage id?
  }

  // static Feature toRemote(Earthquake model) {
  //   return Feature(
  //     properties: RemoteProperties(
  //       mag: model.magnitude, 
  //       place: model.place, 
  //       time: model.time, 
  //       url: model.url, 
  //       tsunami: model.tsunami, 
  //       title: model.title ?? ""),
  //     geometry: RemoteGeometry(coordinates: model.coordinates),
  //     id: model.id,
  //     // id: int.parse(model.id),
  //   );
  // }

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

  //TODO: Crear función para formatear magnitud y quitar de aquí
  double roundToTwoDecimals(double? number) {
    return double.parse(NumberFormat('#.00').format(number));

    // double numberToRound = number ?? 0.0;
    // return double.parse((numberToRound).toStringAsFixed(fractionDigits));
  }
}