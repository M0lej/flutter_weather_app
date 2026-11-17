import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/icons/weather_icon.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/themes/extenstions/gradient_theme.dart';
import 'package:weather_app/utils/translations/translation.dart';
import 'package:weather_app/utils/weather_banner/sunset_sunrise.dart';

class WeatherBanner extends StatelessWidget {
  final Daily? dailyForecast;
  final String date;
  const WeatherBanner({
    super.key,
    required this.dailyForecast,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyForecast == null) {
      return SizedBox.shrink();
    }

    Translation translation = GlobalResource.of(
      context,
    ).appTranslation.translations;

    int index = dailyForecast?.time.indexOf(date) ?? 0;
    int weatherCode = dailyForecast?.weatherCode[index] ?? 0;

    String sunrise = DateFormat(
      'hh:mm',
    ).format(DateTime.parse(dailyForecast!.sunrise[index]));
    String sunset = DateFormat(
      'hh:mm',
    ).format(DateTime.parse(dailyForecast!.sunrise[index]));

    return SizedBox(
      height: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: Theme.of(context).extension<GradientTheme>()?.colors ?? [],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Expanded(
                child: Row(
                  spacing: 15,
                  children: [
                    WeatherIcon(
                      icon: getWeatherIcon(
                        weatherCode,
                        isNight(DateTime.now(), dailyForecast),
                      ),
                      size: 40,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            '${dailyForecast!.temperature2mMax[index].round()}°',
                            minFontSize: 20,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                          AutoSizeText(
                            translation.weather.values[weatherCode] ?? "-",
                            maxLines: 2,
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 15,
                children: [
                  SunsetSunrise(sunset: false, time: sunrise),
                  SunsetSunrise(sunset: true, time: sunset),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
