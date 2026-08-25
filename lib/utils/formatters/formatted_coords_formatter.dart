/// Mirrors Quake/Utils/Formatters/GetFormattedCoordsFormatter.swift.
class FormattedCoordsFormatter {
  String format(List<double>? coords) {
    final longitude = (coords != null && coords.isNotEmpty) ? coords[0] : 0.0;
    final latitude = (coords != null && coords.length > 1) ? coords[1] : 0.0;

    final longitudeString =
        longitude < 0 ? '${-longitude}W' : '${longitude}E';
    final latitudeString = latitude < 0 ? '${-latitude}S' : '${latitude}N';

    return '$longitudeString, $latitudeString';
  }
}
