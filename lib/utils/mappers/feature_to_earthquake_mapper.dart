import '../../data/models/earthquake.dart';
import '../../data/models/feature.dart';
import '../../data/models/length_unit.dart';
import '../formatters/date_formatter.dart';
import '../formatters/formatted_coords_formatter.dart';
import '../formatters/simplified_title_formatter.dart';
import '../formatters/tsunami_value_formatter.dart';

/// Mirrors Quake/Utils/Mappers/FeatureToEarthquakeMapper.swift.
///
/// Note: the original iOS mapper read the selected length unit itself
/// (UserDefaults is synchronous). SharedPreferences is async in Dart, so
/// here the resolved [LengthUnit] is passed in by the caller instead —
/// same behaviour, without needing an async mapper.
class FeatureToEarthquakeMapper {
  final _simplifiedTitleFormatter = SimplifiedTitleFormatter();
  final _formattedCoordsFormatter = FormattedCoordsFormatter();
  final _tsunamiValueFormatter = TsunamiValueFormatter();
  final _dateFormatter = AppDateFormatter();

  Earthquake map(Feature feature, {required LengthUnit unit, int? seed}) {
    final props = feature.properties;
    final coords = feature.geometry.coordinates;
    final title = props.title ?? 'Unknown';
    final place = props.place ?? 'Unknown';

    return Earthquake(
      id: '${props.time ?? 0}-${coords.isNotEmpty ? coords[0] : 0}-${seed ?? 0}',
      fullTitle: title,
      simplifiedTitle: _simplifiedTitleFormatter.simplify(
        titleWithoutFormat: title,
        place: place,
      ),
      place: place,
      formattedCoords: _formattedCoordsFormatter.format(coords),
      originalCoords: coords,
      depth: _depthInSelectedUnits(coords, unit),
      date: _dateFormatter.formatEpochMillis(props.time),
      originalDate: _dateFormatter.toDate(props.time),
      tsunami: _tsunamiValueFormatter.format(props.tsunami),
      formattedMagnitude: (props.mag ?? 0).toStringAsFixed(1),
      originalMagnitude: props.mag ?? 0,
    );
  }

  String _depthInSelectedUnits(List<double> coordinates, LengthUnit unit) {
    final depthKm = coordinates.length > 2
        ? _roundToDecimal(coordinates[2], 2)
        : 0.0;

    if (unit == LengthUnit.miles) {
      final miles = depthKm * 0.62137;
      return '${miles.toStringAsFixed(2)}mi';
    }
    return '${depthKm.toStringAsFixed(2)}km';
  }

  double _roundToDecimal(double value, int fractionDigits) {
    final multiplier = _pow10(fractionDigits);
    return (value * multiplier).round() / multiplier;
  }

  double _pow10(int exponent) {
    double result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}
