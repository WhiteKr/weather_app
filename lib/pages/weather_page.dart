import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/theme_mode_fab.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(dotenv.env['WEATHER_API_KEY']!);

  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (error) {
      print(error);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    const String basePath = 'assets/lotties/weathers';
    if (mainCondition == null) return '$basePath/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return '$basePath/windy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return '$basePath/partly_shower.json';
      case 'thunderstorm':
        return '$basePath/storm.json';
      case 'clear':
        return '$basePath/sunny.json';
      default:
        return '$basePath/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.location_pin),
                    Text(
                      _weather?.cityName ?? 'loading city...',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                Column(
                  children: [
                    Text(
                      '${_weather?.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _weather?.mainCondition ?? '',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ThemeModeFab(),
    );
  }
}
