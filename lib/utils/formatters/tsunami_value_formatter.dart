/// Mirrors Quake/Utils/Formatters/GetTsunamiValueFormatter.swift.
class TsunamiValueFormatter {
  String format(int? tsunami) {
    switch (tsunami) {
      case 0:
        return 'No';
      case 1:
        return 'Yes';
      default:
        return 'Unknown';
    }
  }
}
