import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_dependencies.dart';
import 'core/design/app_theme.dart';
import 'core/units_controller.dart';
import 'features/main/main_view.dart';

/// Mirrors Quake/QuakeApp.swift + Quake/ContentView.swift.
class QuakeApp extends StatelessWidget {
  const QuakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AppDependencies()),
        ChangeNotifierProvider(create: (_) => UnitsController()),
      ],
      child: MaterialApp(
        title: 'Quake',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const MainView(),
      ),
    );
  }
}
