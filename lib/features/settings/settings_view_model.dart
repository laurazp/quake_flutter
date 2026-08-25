import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/models/message_type.dart';

/// Mirrors Quake/Features/Settings/SettingsViewModel.swift (the feedback
/// / app-info portion — unit persistence now lives in UnitsController).
class SettingsViewModel extends ChangeNotifier {
  MessageType selectedType = MessageType.request;
  XFile? selectedImage;
  String messageText = '';

  String appName = '';
  String appVersion = '';
  String appBuild = '';
  String deviceModel = '';
  String deviceSystemVersion = '';

  void setSelectedType(MessageType type) {
    selectedType = type;
    notifyListeners();
  }

  void setSelectedImage(XFile? image) {
    selectedImage = image;
    notifyListeners();
  }

  void setMessageText(String text) {
    messageText = text;
  }

  Future<void> loadAppInfo() async {
    deviceModel = Platform.operatingSystem;
    deviceSystemVersion = Platform.operatingSystemVersion;

    try {
      final info = await PackageInfo.fromPlatform();
      appName = info.appName.isNotEmpty ? info.appName : 'Quake';
      appVersion = info.version.isNotEmpty ? info.version : 'N/A';
      appBuild = info.buildNumber.isNotEmpty ? info.buildNumber : 'N/A';
    } catch (_) {
      appName = 'Quake';
      appVersion = 'N/A';
      appBuild = 'N/A';
    }
    notifyListeners();
  }
}
