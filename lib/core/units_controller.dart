import 'package:flutter/foundation.dart';
import '../data/models/length_unit.dart';
import '../domain/usecases/units_usecase.dart';

/// App-wide, reactive holder for the user's selected [LengthUnit].
///
/// The original iOS app reads UserDefaults synchronously and re-derives the
/// unit on every SwiftUI body evaluation; SharedPreferences is async in
/// Dart, so this small controller loads the value once and republishes it
/// to every listener (the earthquakes list, the units settings screen)
/// whenever it changes — functionally equivalent, just reactive instead of
/// polled.
class UnitsController extends ChangeNotifier {
  final UnitsUseCase _unitsUseCase;
  LengthUnit _unit = LengthUnit.kilometers;

  UnitsController({UnitsUseCase? unitsUseCase})
      : _unitsUseCase = unitsUseCase ?? UnitsUseCase() {
    _load();
  }

  LengthUnit get unit => _unit;

  Future<void> _load() async {
    _unit = await _unitsUseCase.getSelectedLengthUnit();
    notifyListeners();
  }

  Future<void> setUnit(LengthUnit unit) async {
    if (_unit == unit) return;
    _unit = unit;
    notifyListeners();
    await _unitsUseCase.saveSelectedUnit(unit.index);
  }
}
