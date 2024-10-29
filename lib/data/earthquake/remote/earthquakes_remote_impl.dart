import 'package:quake_flutter/data/earthquake/remote/mapper/earthquake_list_remote_mapper.dart';
import 'package:quake_flutter/data/earthquake/remote/mapper/earthquake_remote_mapper.dart';
import 'package:quake_flutter/data/earthquake/remote/mapper/paging_earthquake_list_remote_mapper.dart';
import 'package:quake_flutter/data/earthquake/remote/model/earthquake_list_remote_model.dart';
import 'package:quake_flutter/data/earthquake/remote/model/earthquake_remote_model.dart';
import 'package:quake_flutter/data/remote/error/remote_error_mapper.dart';
import 'package:quake_flutter/data/remote/network_client.dart';
import 'package:quake_flutter/data/remote/network_constants.dart';
import 'package:quake_flutter/model/earthquake_list.dart';
import 'package:quake_flutter/model/earthquake.dart';

class EarthquakesRemoteImpl {
  final NetworkClient _networkClient;

  late String startTime;
  late String endTime;
  late int limit;
  late int offset;

  EarthquakesRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<EarthquakeList> getEarthquakeList(String startTime, String endTime, int limit, int offset) async {
    try {
      final response = await _networkClient.dio
          .get(NetworkConstants.EARTHQUAKE_LIST_PATH, queryParameters: {
        "format": "geojson",
        "starttime": startTime,
        "endtime": endTime,
        "limit": limit,
        "offset": offset
      });
      final listResponse = response.data;
      return PagingEarthquakeListRemoteMapper.fromRemote(
          FeatureCollection.fromMap(listResponse));
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }

  Future<List<Earthquake>> getEarthquakeListForMap(String startTime, String endTime, int limit, int offset) async {
    try {
      final response = await _networkClient.dio.get(
          NetworkConstants.EARTHQUAKE_LIST_PATH,
          queryParameters: {
            "format": "geojson",
            "starttime": startTime,
            "endtime": endTime,
            "limit": limit,
            "offset": offset
          });
      final listResponse = response.data;
      FeatureCollection remoteModel =
          FeatureCollection.fromMap(listResponse);
      return EarthquakeListRemoteMapper.fromRemote(remoteModel);
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }

  Future<Earthquake> getEarthquakeDetail(String earthquakeId) async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.EARTHQUAKE_DETAIL_PATH,
        queryParameters: {
          "eventid": earthquakeId,
          "format": "geojson"
        });
      return EarthquakeRemoteMapper.fromRemote(Feature.fromMap(response.data));
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }
}
