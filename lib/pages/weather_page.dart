import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/theme_mode_fab.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();

  Future<Weather?> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = _weatherService.getWeather(cityName);
      return weather;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FutureBuilder(
              future: _fetchWeather(),
              builder: (context, snapshot) {
                final bool ready = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                final Weather? weather = snapshot.data;

                return Skeletonizer(
                  enabled: !ready,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Skeleton.keep(child: Icon(Icons.location_pin)),
                          Text(
                            weather?.cityName ?? 'Loading...',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Skeleton.shade(child: Lottie.asset(_weatherService.getWeatherAnimation(weather?.mainCondition))),
                      Column(
                        children: [
                          Text(
                            '${weather?.temperature.round()}°C',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            weather?.mainCondition ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: const ThemeModeFab(),
    );
  }
}
