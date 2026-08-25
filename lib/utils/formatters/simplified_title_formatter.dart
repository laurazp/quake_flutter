/// Mirrors Quake/Utils/Formatters/GetSimplifiedTitleFormatter.swift.
class SimplifiedTitleFormatter {
  String simplify({required String titleWithoutFormat, required String place}) {
    if (titleWithoutFormat.contains(' of ')) {
      final parts = titleWithoutFormat.split(' of ');
      return parts.isNotEmpty ? parts.last : 'Unknown';
    } else if (titleWithoutFormat.contains(' - ')) {
      final parts = titleWithoutFormat.split(' - ');
      final last = parts.isNotEmpty ? parts.last : '';
      return last.isNotEmpty ? last : 'Unknown';
    } else {
      return place;
    }
  }
}
