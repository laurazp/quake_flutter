import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quake_flutter/core/formatters/magnitude_color_formatter.dart';
import 'package:quake_flutter/model/earthquake.dart';
import 'package:quake_flutter/presentation/navigation/navigation_routes.dart';

class EarthquakeListRow extends StatelessWidget {
  const EarthquakeListRow({super.key, required this.earthquake});

  final Earthquake earthquake;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(NavigationRoutes.EARTHQUAKE_DETAIL_ROUTE,
            extra: earthquake.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    earthquake.magnitude.toStringAsFixed(1),
                    style: MagnitudeColorFormatter.getMagnitudeColor(earthquake.magnitude),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    earthquake.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
