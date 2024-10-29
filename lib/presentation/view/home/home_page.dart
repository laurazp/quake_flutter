
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (value) {
            widget.navigationShell.goBranch(value,
                initialLocation: value == widget.navigationShell.currentIndex);
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.pin_drop_outlined),
                selectedIcon: Icon(Icons.pin_drop_rounded),
                label: "Earthquakes"),
            NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: "Map"),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: "Settings")
          ]),
    );
  }
}