import 'package:flutter/material.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/utils/translations/translation.dart';

class DetailedHourForecastTopPanel extends StatelessWidget {
  const DetailedHourForecastTopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Translation translation = GlobalResource.of(
      context,
    ).appTranslation.translations;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: 5,
              children: [
                const Icon(Icons.access_time_outlined, size: 15),
                Text(
                  translation.hour,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 5,
              children: [
                const Icon(Icons.thermostat_outlined, size: 15),
                Text(
                  translation.temperature,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 5,
              children: [
                const Icon(Icons.water_drop_outlined, size: 15),
                Text(
                  translation.rain,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 5,
              children: [
                const Icon(Icons.wind_power_outlined, size: 15),
                Text(
                  translation.wind,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
