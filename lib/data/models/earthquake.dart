/// App-level earthquake model — mirrors Quake/Entities/Earthquake.swift.
class Earthquake {
  final String id;
  final String fullTitle;
  final String simplifiedTitle;
  final String place;
  final String formattedCoords;
  final List<double> originalCoords; // [longitude, latitude, depthKm]
  final String depth;
  final String date;
  final DateTime originalDate;
  final String tsunami;
  final String formattedMagnitude;
  final double originalMagnitude;

  Earthquake({
    required this.id,
    required this.fullTitle,
    required this.simplifiedTitle,
    required this.place,
    required this.formattedCoords,
    required this.originalCoords,
    required this.depth,
    required this.date,
    required this.originalDate,
    required this.tsunami,
    required this.formattedMagnitude,
    required this.originalMagnitude,
  });

  double get longitude => originalCoords.isNotEmpty ? originalCoords[0] : 0;
  double get latitude => originalCoords.length > 1 ? originalCoords[1] : 0;

  /// Sample earthquake used by widget previews, mirrors Earthquake.example.
  static Earthquake example = Earthquake(
    id: 'example-1',
    fullTitle: '32 km N of Petersville, Alaska',
    simplifiedTitle: 'Petersville, Alaska',
    place: '32 km N of Petersville, Alaska',
    formattedCoords: '150.8276W, 62.7884N',
    originalCoords: const [-150.8276, 62.7884, 87.6],
    depth: '87.6km',
    date: '23/01/2024',
    originalDate: DateTime.fromMillisecondsSinceEpoch(1388619763623),
    tsunami: 'No',
    formattedMagnitude: '1.4',
    originalMagnitude: 1.4,
  );
}
