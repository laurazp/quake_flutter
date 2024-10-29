// ignore_for_file: constant_identifier_names

import 'package:go_router/go_router.dart';
import 'package:quake_flutter/presentation/view/earthquake/earthquakes_page.dart';
import 'package:quake_flutter/presentation/view/home/home_page.dart';
import 'package:quake_flutter/presentation/view/map/map_page.dart';
import 'package:quake_flutter/presentation/view/settings/settings_page.dart';
import 'package:quake_flutter/presentation/view/splash/splash_page.dart';

class NavigationRoutes {
  static const INITIAL_ROUTE = "/";
  static const EARTHQUAKES_ROUTE = "/earthquakes";
  static const MAP_ROUTE = "/map";
  static const SETTINGS_ROUTE = "/settings";
  static const EARTHQUAKE_DETAIL_ROUTE =
      "$EARTHQUAKES_ROUTE/$_EARTHQUAKE_DETAIL_PATH";

  static const _EARTHQUAKE_DETAIL_PATH = "earthquake-detail";
}

final GoRouter router =
    GoRouter(initialLocation: NavigationRoutes.INITIAL_ROUTE, routes: [
  GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const SplashPage()),
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomePage(
            navigationShell: navigationShell,
          ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.EARTHQUAKES_ROUTE,
            builder: (context, state) => const EarthquakesPage(),
            /* routes: [
              GoRoute(
                path: NavigationRoutes._EARTHQUAKE_DETAIL_PATH,
                builder: (context, state) => EarthquakeDetailPage(
                  monumentId: state.extra as String,
                ),
              )
            ], */
          ),
        ]), 
         StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.MAP_ROUTE,
            builder: (context, state) => const MapPage(),
          )
        ]), 
         StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.SETTINGS_ROUTE,
            builder: (context, state) => const SettingsPage(),
          )
        ]) 
      ])
]);
