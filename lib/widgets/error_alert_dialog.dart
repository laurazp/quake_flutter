import 'package:flutter/material.dart';

/// Mirrors Quake/Widgets/ErrorLoadingListAlertDialog.swift — shows a retry
/// / dismiss dialog whenever a loading error occurs. Call
/// [showErrorLoadingListAlert] from a `didUpdateWidget`/listener callback
/// whenever a view model's `error` field transitions from null to non-null.
Future<void> showErrorLoadingListAlert({
  required BuildContext context,
  required String message,
  required VoidCallback onRetry,
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error loading list'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      );
    },
  );
}
