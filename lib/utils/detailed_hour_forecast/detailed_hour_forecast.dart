import 'package:flutter/material.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/extensions/two_digit_string.dart';
import 'package:weather_app/icons/weather_icon.dart';
import 'package:weather_app/utils/detailed_hour_forecast/detailed_hour_forecast_top_panel.dart';
import 'dart:math';

class DetailedHourForecast extends StatelessWidget {
  final Hourly? hourlyForecast;
  final HourlyUnits? hourlyUnits;
  final Daily? dailyForecast;
  final String selectedDate;

  const DetailedHourForecast({
    super.key,
    required this.hourlyForecast,
    required this.hourlyUnits,
    required this.dailyForecast,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // convert current date to format yyyy-MM-ddThh:00
    String currentDateTime =
        '${DateTime.now().toIso8601String().substring(0, 14)}00';

    // convert date to format yyyy-MM-dd
    String currentDate = currentDateTime.split('T')[0];

    // get hour data for current date
    String firstSameDateOccurrence = "";

    if (selectedDate == currentDate) {
      firstSameDateOccurrence =
          hourlyForecast?.time.firstWhere((String futureDateTime) {
            return futureDateTime == currentDateTime;
          }) ??
          currentDateTime;
    } else {
      firstSameDateOccurrence =
          hourlyForecast?.time.firstWhere(
            (String futureDateTime) =>
                futureDateTime.split('T')[0] == selectedDate,
          ) ??
          '';
    }

    String lastSameDateOccurrence =
        hourlyForecast?.time.lastWhere(
          (String futureDateTime) =>
              futureDateTime.split('T')[0] == selectedDate,
        ) ??
        currentDateTime;

    int startIndex = hourlyForecast?.time.indexOf(firstSameDateOccurrence) ?? 0;
    int endIndex = hourlyForecast?.time.indexOf(lastSameDateOccurrence) ?? 0;

    int startHour = DateTime.parse(firstSameDateOccurrence).hour;

    List<int> weatherCodes =
        hourlyForecast?.weatherCode
            .getRange(startIndex, endIndex + 1)
            .toList() ??
        [];

    List<double> temps =
        hourlyForecast?.temperature2m
            .getRange(startIndex, endIndex + 1)
            .toList() ??
        [];

    List<double> rainPercentages =
        hourlyForecast?.rain.getRange(startIndex, endIndex + 1).toList() ?? [];

    List<double> windSpeeds =
        hourlyForecast?.windSpeed10m
            .getRange(startIndex, endIndex + 1)
            .toList() ??
        [];
    List<int> windDirections =
        hourlyForecast?.windDirection10m
            .getRange(startIndex, endIndex + 1)
            .toList() ??
        [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: (endIndex - startIndex + 2),
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(thickness: .3),
            );
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              return DetailedHourForecastTopPanel();
            } else {
              double windDirectionRadianAngle =
                  windDirections[index - 1].toDouble() * (pi / 180);
              String windCardinalDirection;

              switch (windDirections[index - 1]) {
                case >= 0 && <= 22:
                  windCardinalDirection = "N";
                  break;

                case >= 23 && <= 67:
                  windCardinalDirection = "NE";
                  break;

                case >= 68 && <= 112:
                  windCardinalDirection = "E";
                  break;

                case >= 113 && <= 157:
                  windCardinalDirection = "SE";
                  break;

                case >= 158 && <= 202:
                  windCardinalDirection = "S";
                  break;

                case >= 203 && <= 247:
                  windCardinalDirection = "SW";
                  break;

                case >= 248 && <= 292:
                  windCardinalDirection = "W";
                  break;

                case >= 293 && <= 337:
                  windCardinalDirection = "NW";
                  break;

                case >= 338 && <= 360:
                  windCardinalDirection = "N";
                  break;

                default:
                  windCardinalDirection = "?";
              }

              DateTime date = DateTime.parse(
                selectedDate,
              ).add(Duration(hours: startHour + index - 1));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${(date.hour).toTwoDigitString()}:00',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-15, 0),
                      child: WeatherIcon(
                        icon: getWeatherIcon(
                          weatherCodes[index - 1],
                          isNight(date, dailyForecast),
                        ),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        spacing: 30,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text('${temps[index - 1].round()}°')],
                      ),
                    ),
                    Expanded(child: Text('${rainPercentages[index - 1]}%')),
                    Expanded(
                      child: Row(
                        spacing: 5,
                        children: [
                          Transform.rotate(
                            angle: windDirectionRadianAngle,
                            child: Icon(Icons.arrow_upward, size: 13),
                          ),
                          Column(
                            children: [
                              Text(
                                '${windSpeeds[index - 1].round()} ${hourlyUnits?.windSpeed10m}',
                              ),
                              Text(windCardinalDirection),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
