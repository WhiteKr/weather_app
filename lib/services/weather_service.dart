import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static final String apiKey = dotenv.env['WEATHER_API_KEY']!;

  WeatherService();

  Future<Weather> getWeather(String cityName) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    return Weather.fromJson(jsonDecode(response.body));
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;

    return city ?? '';
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
}
