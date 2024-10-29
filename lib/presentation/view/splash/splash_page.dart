
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:quake_flutter/presentation/navigation/navigation_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
@override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading_animation.json',
          repeat: true,
          animate: true,
          width: 275,
          height: 275,
        ),
      ),
    );
  }

  _navigateToNextPage() async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        context.go(NavigationRoutes.EARTHQUAKES_ROUTE);
      }
    } catch (e) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred while navigating to the main page.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToNextPage();
              },
              child: const Text('Reload'),
            ),
          ],
        );
      },
    );
  }
}