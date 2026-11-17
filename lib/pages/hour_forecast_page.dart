import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/utils/day_selector.dart';
import 'package:weather_app/utils/detailed_hour_forecast/detailed_hour_forecast.dart';
import 'package:weather_app/utils/translations/translation.dart';
import 'package:weather_app/utils/weather_banner/weather_banner.dart';

class HourForecastPage extends StatefulWidget {
  final Hourly? hourlyForecast;
  final HourlyUnits? hourlyUnits;
  final Daily? dailyForecast;
  const HourForecastPage({
    super.key,
    required this.hourlyForecast,
    required this.hourlyUnits,
    required this.dailyForecast,
  });

  @override
  State<HourForecastPage> createState() => _HourForecastPageState();
}

class _HourForecastPageState extends State<HourForecastPage> {
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Translation translation = GlobalResource.of(
      context,
    ).appTranslation.translations;
    
    void daySelectorChangeHandler(String date) {
      setState(() {
        selectedDate = date;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translation.hourForecastLabel,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              spacing: 15,
              children: [
                SizedBox(
                  height: 50,
                  child: DaySelector(
                    onChange: daySelectorChangeHandler,
                    selectedDate: selectedDate,
                  ),
                ),
                WeatherBanner(
                  dailyForecast: widget.dailyForecast,
                  date: selectedDate,
                ),
                DetailedHourForecast(
                  hourlyForecast: widget.hourlyForecast,
                  hourlyUnits: widget.hourlyUnits,
                  dailyForecast: widget.dailyForecast,
                  selectedDate: selectedDate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
