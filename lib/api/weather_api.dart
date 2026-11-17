import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/hive/temperature_unit_adapter.dart';
import 'package:weather_app/hive/wind_speed_unit_adapter.dart';
import 'package:weather_app/icons/weather_icons_SVG.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'dart:convert';

class WeatherApi {
  Future<WeatherResponse?> getWeather(
    double latitude,
    double longitude,
    TemperatureUnit temperatureUnit,
    WindSpeedUnit windSpeedUnit,
  ) async {
    final response = await http.get(
      Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max&hourly=temperature_2m,weather_code,wind_speed_10m,rain,wind_direction_10m&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,surface_pressure,wind_speed_10m&timezone=auto&temperature_unit=${temperatureUnit.name}&wind_speed_unit=${windSpeedUnit.name}",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherResponse.fromJson(data);
    } else {
      return null;
    }
  }
}

class WeatherResponse {
  final double latitude;
  final double longitude;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final CurrentUnits currentUnits;
  final Current current;
  final HourlyUnits hourlyUnits;
  final Hourly hourly;
  final DailyUnits dailyUnits;
  final Daily daily;

  WeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.currentUnits,
    required this.current,
    required this.hourlyUnits,
    required this.hourly,
    required this.dailyUnits,
    required this.daily,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      generationtimeMs: (json['generationtime_ms'] as num).toDouble(),
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      elevation: (json['elevation'] as num).toDouble(),
      currentUnits: CurrentUnits.fromJson(json['current_units']),
      current: Current.fromJson(json['current']),
      hourlyUnits: HourlyUnits.fromJson(json['hourly_units']),
      hourly: Hourly.fromJson(json['hourly']),
      dailyUnits: DailyUnits.fromJson(json['daily_units']),
      daily: Daily.fromJson(json['daily']),
    );
  }
}

class CurrentUnits {
  final String time;
  final String interval;
  final String temperature2m;
  final String relativeHumidity2m;
  final String apparentTemperature;
  final String weatherCode;
  final String surfacePressure;
  final String windSpeed10m;

  CurrentUnits({
    required this.time,
    required this.interval,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.surfacePressure,
    required this.windSpeed10m,
  });

  factory CurrentUnits.fromJson(Map<String, dynamic> json) {
    return CurrentUnits(
      time: json['time'],
      interval: json['interval'],
      temperature2m: json['temperature_2m'],
      relativeHumidity2m: json['relative_humidity_2m'],
      apparentTemperature: json['apparent_temperature'],
      weatherCode: json['weather_code'],
      surfacePressure: json['surface_pressure'],
      windSpeed10m: json['wind_speed_10m'],
    );
  }
}

class Current {
  final String time;
  final int interval;
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final int weatherCode;
  final double surfacePressure;
  final double windSpeed10m;

  Current({
    required this.time,
    required this.interval,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.surfacePressure,
    required this.windSpeed10m,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      time: json['time'],
      interval: json['interval'],
      temperature2m: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity2m: json['relative_humidity_2m'],
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      weatherCode: json['weather_code'],
      surfacePressure: (json['surface_pressure'] as num).toDouble(),
      windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
    );
  }
}

class HourlyUnits {
  final String time;
  final String temperature2m;
  final String weatherCode;
  final String windSpeed10m;
  final String rain;
  final String windDirection10m;

  HourlyUnits({
    required this.time,
    required this.temperature2m,
    required this.weatherCode,
    required this.windSpeed10m,
    required this.rain,
    required this.windDirection10m,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return HourlyUnits(
      time: json['time'],
      temperature2m: json['temperature_2m'],
      weatherCode: json['weather_code'],
      windSpeed10m: json['wind_speed_10m'],
      rain: json['rain'],
      windDirection10m: json['wind_direction_10m'],
    );
  }
}

class Hourly {
  final List<String> time;
  final List<double> temperature2m;
  final List<int> weatherCode;
  final List<double> windSpeed10m;
  final List<double> rain;
  final List<int> windDirection10m;

  Hourly({
    required this.time,
    required this.temperature2m,
    required this.weatherCode,
    required this.windSpeed10m,
    required this.rain,
    required this.windDirection10m,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      time: List<String>.from(json['time']),
      temperature2m: (json['temperature_2m'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      weatherCode: List<int>.from(json['weather_code']),
      windSpeed10m: List<double>.from(json['wind_speed_10m']),
      rain: List<double>.from(json['rain']),
      windDirection10m: List<int>.from(json['wind_direction_10m']),
    );
  }
}

class DailyUnits {
  final String time;
  final String weatherCode;
  final String temperature2mMax;
  final String temperature2mMin;
  final String sunrise;
  final String sunset;
  final String uvIndexMax;

  DailyUnits({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.sunrise,
    required this.sunset,
    required this.uvIndexMax,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) {
    return DailyUnits(
      time: json['time'],
      weatherCode: json['weather_code'],
      temperature2mMax: json['temperature_2m_max'],
      temperature2mMin: json['temperature_2m_min'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      uvIndexMax: json['uv_index_max'],
    );
  }
}

class Daily {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperature2mMax;
  final List<double> temperature2mMin;
  final List<String> sunrise;
  final List<String> sunset;
  final List<double> uvIndexMax;

  Daily({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.sunrise,
    required this.sunset,
    required this.uvIndexMax,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      time: List<String>.from(json['time']),
      weatherCode: List<int>.from(json['weather_code']),
      temperature2mMax: (json['temperature_2m_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      temperature2mMin: (json['temperature_2m_min'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      sunrise: List<String>.from(json['sunrise']),
      sunset: List<String>.from(json['sunset']),
      uvIndexMax: (json['uv_index_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

String decodeWeatherCode(int weatherCode, BuildContext context) {
  return GlobalResource.of(
    context,
  ).appTranslation.translations.weather.values[weatherCode]!;
}

bool isNight(DateTime now, Daily? dailyData) {
  if (dailyData == null) {
    return false;
  }

  String date = DateFormat('yyyy-MM-dd').format(now);

  int dayIndex = dailyData.time.indexOf(date);

  DateTime sunrise = DateTime.parse(dailyData.sunrise[dayIndex]);
  DateTime sunset = DateTime.parse(dailyData.sunset[dayIndex]);

  if (now.compareTo(sunrise) < 0 || now.compareTo(sunset) > 0) {
    return true;
  }

  return false;
}

String getWeatherIcon(int weatherCode, bool isNight) {
  Map<int, String> weatherCodeIcons = isNight
      ? {
          0: WeatherIconsSVG.clearNight,
          1: WeatherIconsSVG.fairNight,
          2: WeatherIconsSVG.cloudyNight1,
          3: WeatherIconsSVG.cloudy,
          45: WeatherIconsSVG.fog,
          48: WeatherIconsSVG.frost,
          51: WeatherIconsSVG.rainy4,
          53: WeatherIconsSVG.rainy5,
          55: WeatherIconsSVG.rainy5,
          56: WeatherIconsSVG.snowy4,
          57: WeatherIconsSVG.snowy5,
          61: WeatherIconsSVG.rainy4,
          63: WeatherIconsSVG.rainy5,
          65: WeatherIconsSVG.rainy6,
          67: WeatherIconsSVG.rainy7,
          71: WeatherIconsSVG.snowy4,
          73: WeatherIconsSVG.snowy5,
          75: WeatherIconsSVG.snowy6,
          77: WeatherIconsSVG.sleet,
          80: WeatherIconsSVG.rainy5,
          81: WeatherIconsSVG.rainy4,
          82: WeatherIconsSVG.rainy5,
          85: WeatherIconsSVG.snowy4,
          86: WeatherIconsSVG.snowy5,
          95: WeatherIconsSVG.thunder,
          96: WeatherIconsSVG.thunder,
          99: WeatherIconsSVG.thunder,
        }
      : {
          0: WeatherIconsSVG.clearDay,
          1: WeatherIconsSVG.fairDay,
          2: WeatherIconsSVG.cloudyDay1,
          3: WeatherIconsSVG.cloudy,
          45: WeatherIconsSVG.fog,
          48: WeatherIconsSVG.frost,
          51: WeatherIconsSVG.rainy2,
          53: WeatherIconsSVG.rainy3,
          55: WeatherIconsSVG.rainy3,
          56: WeatherIconsSVG.snowy2,
          57: WeatherIconsSVG.snowy3,
          61: WeatherIconsSVG.rainy4,
          63: WeatherIconsSVG.rainy5,
          65: WeatherIconsSVG.rainy6,
          67: WeatherIconsSVG.rainy7,
          71: WeatherIconsSVG.snowy4,
          73: WeatherIconsSVG.snowy5,
          75: WeatherIconsSVG.snowy6,
          77: WeatherIconsSVG.sleet,
          80: WeatherIconsSVG.rainy1,
          81: WeatherIconsSVG.rainy2,
          82: WeatherIconsSVG.rainy3,
          85: WeatherIconsSVG.snowy2,
          86: WeatherIconsSVG.snowy3,
          95: WeatherIconsSVG.thunder,
          96: WeatherIconsSVG.thunder,
          99: WeatherIconsSVG.thunder,
        };

  if (!weatherCodeIcons.containsKey(weatherCode)) {
    return WeatherIconsSVG.missingData;
  }

  return weatherCodeIcons[weatherCode]!;
}
