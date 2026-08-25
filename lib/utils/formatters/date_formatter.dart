import 'package:intl/intl.dart';

/// Mirrors Quake/Utils/Formatters/GetDateFormatter.swift.
class AppDateFormatter {
  /// Formats a USGS epoch-millis timestamp as a medium date + long time
  /// string (e.g. "Jan 23, 2024 at 6:22:43 PM GMT+1").
  String formatEpochMillis(int? epochMillis) {
    final date = toDate(epochMillis);
    return DateFormat('MMM d, y, h:mm:ss a').format(date.toLocal());
  }

  DateTime toDate(int? epochMillis) {
    return DateTime.fromMillisecondsSinceEpoch(epochMillis ?? 0, isUtc: true);
  }

  String simpleFormat(DateTime date) => DateFormat.yMd().format(date);
}
