import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/api/air_quality_api.dart';
import 'package:weather_app/api/geo_api.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/hive/app_settings_adapter.dart';
import 'package:weather_app/hive/geo_result_adapter.dart';
import 'package:weather_app/hive/temperature_unit_adapter.dart';
import 'package:weather_app/hive/wind_speed_unit_adapter.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/pages/location_pick_page.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/themes/app_theme.dart';
import 'package:weather_app/utils/browser_phone_frame.dart';
import 'package:weather_app/utils/loading_screen.dart';
import 'package:weather_app/utils/translations/app_translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(GeoResultAdapter());
  Hive.registerAdapter(TemperatureUnitAdapter());
  Hive.registerAdapter(WindSpeedUnitAdapter());
  Hive.registerAdapter(AppSettingsAdapter());

  await Hive.openBox('appBox');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var box = Hive.box('appBox');

  GeoResult? placeData;
  WeatherResponse? weatherData;
  AirQualityResponse? airQualityData;
  AppSettings? appSettings;
  AppTranslation? appTranslation;
  ThemeMode themeMode = ThemeMode.system;
  bool loading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    GeoResult? storedPlaceData = await box.get("geo_data");
    AppSettings? storedAppSettings = await box.get('app_settings');
    WeatherResponse? fetchedWeatherData;
    AirQualityResponse? fetchedAirQualityData;

    if (storedAppSettings == null) {
      storedAppSettings = AppSettings();

      await box.put('app_settings', appSettings);
    }

    if (storedPlaceData != null) {
      // get weather data if place data is not null
      WeatherApi weatherApi = WeatherApi();
      var weatherResponse = await weatherApi
          .getWeather(
            storedPlaceData.latitude,
            storedPlaceData.longitude,
            storedAppSettings.temperatureUnit,
            storedAppSettings.windSpeedUnit,
          )
          .catchError((e) => throw Exception('Weather api error: $e'));

      if (weatherResponse != null) {
        fetchedWeatherData = weatherResponse;
      } else {
        throw Exception("Failed to fetch weather data.");
      }

      // get air quality data if place data is not null
      AirQualityApi airQualityApi = AirQualityApi();
      var airQualityResponse = await airQualityApi
          .getAirQuality(storedPlaceData.latitude, storedPlaceData.longitude)
          .catchError((e) => throw Exception('Air quality api error: $e'));

      if (airQualityResponse != null) {
        fetchedAirQualityData = airQualityResponse;
      } else {
        throw Exception("Failed to fetch air quality data.");
      }
    }

    setState(() {
      if (fetchedWeatherData != null) {
        themeMode = isNight(DateTime.now(), fetchedWeatherData.daily)
            ? ThemeMode.dark
            : ThemeMode.light;
      }

      placeData = storedPlaceData;
      appSettings = storedAppSettings!;
      appTranslation = AppTranslation(language: storedAppSettings.language);
      weatherData = fetchedWeatherData;
      airQualityData = fetchedAirQualityData;
      loading = false;
    });
  }

  Future<void> changeSettings(AppSettings updatedAppSettings) async {
    await box.put('app_settings', updatedAppSettings);
    setState(() {
      appSettings = updatedAppSettings;
    });
    getWeatherData();
  }

  void changeTranslation(AppTranslation Translation) {
    setState(() {
      appTranslation = Translation;
    });
  }

  Future<void> getWeatherData() async {
    if (placeData == null) return;

    WeatherApi api = WeatherApi();
    var response = await api
        .getWeather(
          placeData!.latitude,
          placeData!.longitude,
          appSettings?.temperatureUnit ?? TemperatureUnit.celsius,
          appSettings?.windSpeedUnit ?? WindSpeedUnit.kmh,
        )
        .catchError((e) => throw Exception('Weather api error: $e'));

    if (response != null) {
      setState(() {
        weatherData = response;
        themeMode = isNight(DateTime.now(), response.daily)
            ? ThemeMode.dark
            : ThemeMode.light;
      });
    } else {
      throw Exception("Failed to fetch weather data.");
    }
  }

  Future<void> getAirQualityData() async {
    if (placeData == null) return;

    AirQualityApi api = AirQualityApi();
    var response = await api
        .getAirQuality(placeData!.latitude, placeData!.longitude)
        .catchError((e) => throw Exception('Air quality api error: $e'));

    if (response != null) {
      setState(() {
        airQualityData = response;
      });
    } else {
      throw Exception("Failed to fetch air quality data.");
    }
  }

  Future<void> changeLocation(GeoResult result) async {
    await box.put("geo_data", result);

    setState(() {
      placeData = result;
    });

    await getWeatherData();
    await getAirQualityData();
  }

  @override
  Widget build(BuildContext context) {
    final Widget appContent = loading
        ? LoadingScreen()
        : placeData != null
        ? HomePage(
            placeData: placeData,
            changeLocation: changeLocation,
            weatherData: weatherData,
            airQualityData: airQualityData,
          )
        : LocationPickPage(changeLocation: changeLocation);

    return GlobalResource(
      appSettings: appSettings ?? AppSettings(),
      appTranslation: appTranslation ?? AppTranslation(),
      changeSettings: changeSettings,
      changeTranslation: changeTranslation,
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final navigator = child ?? const SizedBox.shrink();
          return kIsWeb ? BrowserPhoneFrame(child: navigator) : navigator;
        },
        home: appContent,
      ),
    );
  }
}
