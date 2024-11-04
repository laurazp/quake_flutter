import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      earthquake.magnitude.toString(), //TODO: Manage magnitude color, text size and just 2 decimal points!
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      earthquake.title ?? "Unknown", //TODO: Manage null title with place
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
