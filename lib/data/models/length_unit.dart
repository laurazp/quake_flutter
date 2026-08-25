/// Mirrors Quake/Entities/LengthUnit.swift.
enum LengthUnit {
  kilometers,
  miles;

  String get storageValue => name;

  String get label {
    switch (this) {
      case LengthUnit.kilometers:
        return 'Kilometers';
      case LengthUnit.miles:
        return 'Miles';
    }
  }

  int get selectedIndex => this == LengthUnit.kilometers ? 0 : 1;

  static LengthUnit fromStorageValue(String? value) {
    return LengthUnit.values.firstWhere(
      (u) => u.storageValue == value,
      orElse: () => LengthUnit.kilometers,
    );
  }

  static LengthUnit fromIndex(int index) {
    return index == 0 ? LengthUnit.kilometers : LengthUnit.miles;
  }
}
