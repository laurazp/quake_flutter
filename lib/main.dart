import 'package:flutter/material.dart';
import 'package:quake_flutter/core/di/app_modules.dart';
import 'package:quake_flutter/presentation/navigation/navigation_routes.dart';

void main() {
  AppModules().setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false, routerConfig: router);
  }
}
