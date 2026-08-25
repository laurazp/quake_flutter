/// Mirrors Quake/UseCases/GetTimeRangeUseCase.swift.
class GetTimeRangeUseCase {
  static const String _isoFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'";

  /// Returns a (start, end) pair covering the last [days] days, ending now.
  ({String start, String end}) getTimeRange({int days = 30}) {
    final now = DateTime.now().toUtc();
    final start = now.subtract(Duration(hours: days * 24 - 1));
    return (start: _format(start), end: _format(now));
  }

  /// Returns a (start, end) pair spanning the given local dates, expanded
  /// to true midnight -> true end-of-day and converted to UTC — mirrors
  /// Date.trueMidnight / Date.trueEndOfDay.
  ({String start, String end}) getDateRangeFromDates({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final resolvedStart = startDate ?? endDate ?? DateTime.now();
    final resolvedEnd = endDate ?? startDate ?? DateTime.now();

    final trueStart = _trueMidnight(resolvedStart);
    final trueEnd = _trueEndOfDay(resolvedEnd);

    return (start: _format(trueStart), end: _format(trueEnd));
  }

  DateTime _trueMidnight(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    return local.toUtc();
  }

  DateTime _trueEndOfDay(DateTime date) {
    final local = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return local.toUtc();
  }

  String _format(DateTime utcDate) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${utcDate.year}-${two(utcDate.month)}-${two(utcDate.day)}'
        "T${two(utcDate.hour)}:${two(utcDate.minute)}:${two(utcDate.second)}Z";
  }
}
