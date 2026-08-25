import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Mirrors Quake/Utils/LocationPermissionManager.swift.
class LocationPermissionManager extends ChangeNotifier {
  LocationPermission _status = LocationPermission.denied;
  bool _serviceEnabled = true;

  LocationPermission get status => _status;

  bool get isDenied =>
      _status == LocationPermission.denied ||
      _status == LocationPermission.deniedForever ||
      !_serviceEnabled;

  bool get isAuthorized =>
      _status == LocationPermission.whileInUse ||
      _status == LocationPermission.always;

  Future<void> refreshStatus() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    _status = await Geolocator.checkPermission();
    notifyListeners();
  }

  Future<void> requestPermission() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      notifyListeners();
      return;
    }
    _status = await Geolocator.requestPermission();
    notifyListeners();
  }
}
