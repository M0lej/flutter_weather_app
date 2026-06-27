import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/icons/weather_icon.dart';
import 'package:weather_app/icons/weather_icons_SVG.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/utils/translations/translation.dart';

class SunsetSunrise extends StatelessWidget {
  final bool sunset;
  final String time;
  const SunsetSunrise({super.key, required this.sunset, required this.time});

  @override
  Widget build(BuildContext context) {
    Translation translation = GlobalResource.of(context).appTranslation.translations;

    return Row(
      spacing: 10,
      children: [
        WeatherIcon(
          icon: sunset ? WeatherIconsSVG.night : WeatherIconsSVG.day,
          size: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              time,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
            ),
            AutoSizeText(
              sunset ? translation.sunset : translation.sunrise,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight(300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
