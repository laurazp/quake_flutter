import 'package:flutter/material.dart';

/// Static, non-visual configuration — mirrors Quake/Utils/Constants/Constants.swift
/// (the Images enum) plus a few app-wide values that had no direct iOS
/// counterpart (API base URL, feedback recipient, credit links).
abstract class AppConstants {
  // MARK: - Network
  static const String usgsBaseUrl =
      'https://earthquake.usgs.gov/fdsnws/event/1/query';
  static const int defaultPageSize = 20;

  // MARK: - Feedback
  static const String feedbackRecipient = 'luridevlabs@gmail.com';

  // MARK: - Credit links (mirrors AppInfoView)
  static const String usgsCreditUrl =
      'https://www.usgs.gov/programs/earthquake-hazards';
  static const String flaticonSeismicUrl =
      'https://www.flaticon.com/free-icons/seismic';
  static const String flaticonEarthquakeUrl =
      'https://www.flaticon.com/free-icons/earthquake';
  static const String ctFeedbackSwiftUrl =
      'https://github.com/rizumita/CTFeedbackSwift';

  // MARK: - Icons (Material equivalents of the original SF Symbols)
  static const IconData earthquakesListIcon = Icons.vibration_rounded;
  static const IconData mapIcon = Icons.map_rounded;
  static const IconData settingsIcon = Icons.settings_rounded;
  static const IconData earthquakeMapPinIcon = Icons.stacked_line_chart_rounded;
  static const IconData unitsSettingsIcon = Icons.straighten_rounded;
  static const IconData locationSettingsIcon = Icons.location_on_rounded;
  static const IconData infoSettingsIcon = Icons.info_rounded;
  static const IconData faqSettingsIcon = Icons.help_rounded;
  static const IconData feedbackSettingsIcon = Icons.forum_rounded;
  static const IconData centerLocationIcon = Icons.my_location_rounded;
  static const IconData chevronDownIcon = Icons.keyboard_arrow_down_rounded;
  static const IconData chevronRightIcon = Icons.chevron_right_rounded;
  static const IconData locationPermissionsIcon = Icons.location_history_rounded;
  static const IconData arrowUpIcon = Icons.arrow_upward_rounded;
  static const IconData filterEarthquakesIcon = Icons.tune_rounded;
  static const IconData sortEarthquakesIcon = Icons.swap_vert_rounded;
  static const IconData clearFiltersIcon = Icons.close_rounded;
}
