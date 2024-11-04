import 'package:quake_flutter/data/earthquake/remote/model/earthquake_remote_model.dart';

class DepthValueFormatter {
  
static String getDepthFromCoords(Feature feature) {
  return feature.geometry?.coordinates[2].toString() ?? "Unknown";
}

  // static Measure<UnitLength> depthInSelectedUnits(Feature feature) {
  //   double initialDepthInKms = Double(feature.geometry.coordinates[2]).roundToDecimal(2);
  //   var finalDepth = Measure(value: 0.0, unit: UnitLength.kilometers);
  //   if (unitsUseCase.getSelectedUnit() == "kilometers") {
  //     finalDepth = Measure(value: initialDepthInKms, unit: UnitLength.kilometers);
  //   } else {
  //     finalDepth = Measure(value: (initialDepthInKms * 0.62137), unit: UnitLength.miles);
  //   }
  //   return finalDepth;
  // }
    
  // static Measure<UnitLength> depthInSelectedUnitsFromFloat(double depth) {
  //   let initialDepthInKms = Double(depth);
  //   var finalDepth = Measure(value: 0.0, unit: UnitLength.kilometers);
  //   if (unitsUseCase.getSelectedUnit() == "kilometers") {
  //     finalDepth = Measure(value: initialDepthInKms, unit: UnitLength.kilometers);
  //   } else {
  //     finalDepth = Measure(value: (initialDepthInKms * 0.62137), unit: UnitLength.miles);
  //   }
  //   return finalDepth;
  // }
}