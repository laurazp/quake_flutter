import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../earthquakes/earthquakes_view.dart';
import '../map/map_view.dart';
import '../settings/settings_view.dart';

/// Mirrors Quake/Features/Main/MainView.swift — the root TabView, ported to
/// a Material 3 [NavigationBar].
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _index = 0;
  final Set<int> _visited = {0};

  static const _builders = <WidgetBuilder>[
    _buildEarthquakes,
    _buildMap,
    _buildSettings,
  ];

  static Widget _buildEarthquakes(BuildContext context) => const EarthquakesView();
  static Widget _buildMap(BuildContext context) => const MapView();
  static Widget _buildSettings(BuildContext context) => const SettingsView();

  @override
  Widget build(BuildContext context) {
    _visited.add(_index);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          for (var i = 0; i < _builders.length; i++)
            _visited.contains(i) ? _builders[i](context) : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: Icon(AppConstants.earthquakesListIcon),
            label: 'Earthquakes',
          ),
          NavigationDestination(
            icon: Icon(AppConstants.mapIcon),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(AppConstants.settingsIcon),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
