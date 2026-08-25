import '../../data/models/length_unit.dart';

/// Mirrors Quake/Utils/Formatters/GetLocalizedPlaceFormatter.swift — rewrites
/// any "<n> km" distance mentioned inside a USGS place string into the
/// user's selected unit (e.g. "32 km N of Petersville" -> "19.9 mi N of
/// Petersville" when miles are selected).
class LocalizedPlaceFormatter {
  static final RegExp _kmPattern = RegExp(r'(\d+(\.\d+)?)\s*km');

  String format(String place, LengthUnit unit) {
    return place.replaceAllMapped(_kmPattern, (match) {
      final kmValue = double.tryParse(match.group(1) ?? '');
      if (kmValue == null) return match.group(0)!;

      if (unit == LengthUnit.miles) {
        final miles = kmValue * 0.621371;
        return '${miles.toStringAsFixed(1)} mi';
      }
      return '${kmValue.toStringAsFixed(1)} km';
    });
  }
}
