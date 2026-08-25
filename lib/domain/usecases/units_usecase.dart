import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/length_unit.dart';

/// Mirrors Quake/UseCases/UnitsUseCase.swift +
/// Quake/Utils/Extensions/UserDefaults.swift. Backed by SharedPreferences,
/// the Flutter equivalent of UserDefaults.
class UnitsUseCase {
  static const _key = 'Units';

  Future<void> saveSelectedUnit(int selectedSegmentIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final unit = LengthUnit.fromIndex(selectedSegmentIndex);
    await prefs.setString(_key, unit.storageValue);
  }

  Future<String> getSelectedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? LengthUnit.kilometers.storageValue;
  }

  Future<LengthUnit> getSelectedLengthUnit() async {
    final stored = await getSelectedUnit();
    return LengthUnit.fromStorageValue(stored);
  }
}
