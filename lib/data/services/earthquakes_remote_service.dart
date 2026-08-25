import '../../core/constants.dart';
import '../../domain/usecases/units_usecase.dart';
import '../../utils/mappers/feature_to_earthquake_mapper.dart';
import '../models/earthquake.dart';
import '../network/network_client.dart';

/// Mirrors Quake/Data/Services/EarthquakesRemoteService.swift.
class EarthquakesRemoteService {
  final NetworkClient networkClient;
  final FeatureToEarthquakeMapper _mapper = FeatureToEarthquakeMapper();
  final UnitsUseCase _unitsUseCase = UnitsUseCase();

  EarthquakesRemoteService({required this.networkClient});

  Future<List<Earthquake>> getEarthquakes({
    required String startTime,
    required String endTime,
    required int offset,
    required int pageSize,
  }) async {
    final selectedPageSize =
        pageSize != AppConstants.defaultPageSize ? pageSize : AppConstants.defaultPageSize;

    final url = '${AppConstants.usgsBaseUrl}'
        '?format=geojson&starttime=$startTime&endtime=$endTime'
        '&limit=$selectedPageSize&offset=$offset';

    final response = await networkClient.get(url);
    final unit = await _unitsUseCase.getSelectedLengthUnit();

    return [
      for (var i = 0; i < response.features.length; i++)
        _mapper.map(response.features[i], unit: unit, seed: offset + i),
    ];
  }
}
