extension CoreDoubleExtensions on double {
  double roundToDecimal(int number, int fractionDigits) =>
      double.parse((number).toStringAsFixed(fractionDigits));
}
