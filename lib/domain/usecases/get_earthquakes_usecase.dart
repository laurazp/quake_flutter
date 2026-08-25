import '../../data/models/earthquake.dart';
import '../../data/repositories/earthquakes_repository.dart';
import 'get_time_range_usecase.dart';

/// Mirrors Quake/UseCases/GetEarthquakesUseCase.swift.
class GetEarthquakesUseCase {
  final EarthquakesRepository earthquakesRepository;
  final GetTimeRangeUseCase _timeRangeUseCase = GetTimeRangeUseCase();

  GetEarthquakesUseCase({required this.earthquakesRepository});

  Future<List<Earthquake>> getLatestEarthquakes({
    int days = 30,
    required int offset,
    required int pageSize,
  }) async {
    final range = _timeRangeUseCase.getTimeRange(days: days);
    return earthquakesRepository.getEarthquakes(
      startTime: range.start,
      endTime: range.end,
      offset: offset,
      pageSize: pageSize,
    );
  }

  Future<List<Earthquake>> getEarthquakesBetweenDates({
    DateTime? startDate,
    DateTime? endDate,
    required int offset,
    required int pageSize,
  }) async {
    final range = _timeRangeUseCase.getDateRangeFromDates(
      startDate: startDate,
      endDate: endDate,
    );
    return earthquakesRepository.getEarthquakes(
      startTime: range.start,
      endTime: range.end,
      offset: offset,
      pageSize: pageSize,
    );
  }
}
