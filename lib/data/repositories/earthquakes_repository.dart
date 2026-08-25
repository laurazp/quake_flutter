import '../models/earthquake.dart';
import '../services/earthquakes_remote_service.dart';

/// Mirrors Quake/Data/Repositories/EarthquakesRepository.swift.
class EarthquakesRepository {
  final EarthquakesRemoteService remoteService;

  EarthquakesRepository({required this.remoteService});

  Future<List<Earthquake>> getEarthquakes({
    required String startTime,
    required String endTime,
    required int offset,
    required int pageSize,
  }) async {
    try {
      return await remoteService.getEarthquakes(
        startTime: startTime,
        endTime: endTime,
        offset: offset,
        pageSize: pageSize,
      );
    } catch (error) {
      // ignore: avoid_print
      print(error);
      rethrow;
    }
  }
}
