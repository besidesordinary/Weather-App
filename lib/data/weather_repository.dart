import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherRepository {
  final String apiKey;
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final bool _isMetric = true;
  List<Weather> forecast = [];
  String currentCity = '';
  PageController? pageController; // Use nullable type for pageController
  int currentPage = 0;

  WeatherRepository({required this.apiKey});

  Future<Weather> getWeather(String city) async {
    final String unit = _isMetric ? 'metric' : 'imperial';
    final String url = '$baseUrl/weather?q=$city&units=$unit&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      final Weather weather = Weather.fromJson(data);
      city = weather.city;
      forecast.add(weather);
      currentPage = forecast.length - 1;
      if (pageController != null && pageController!.hasClients) {
        pageController!.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      return weather;
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<Weather>> getWeatherForecast(String city) async {
    final String unit = _isMetric ? 'metric' : 'imperial';
    final String url = '$baseUrl/forecast?q=$city&units=$unit&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      // Initialize pageController if it's null
      pageController ??= PageController();
      // Clear the forecast list before adding new data
      forecast.clear();
      // Parse the forecast data and append it to the forecast list
      forecast.addAll(Weather.fromForecastJson(data));
      currentPage = 0;
      // Add a check to ensure pageController has attached to a widget tree
      if (pageController!.hasClients) {
        pageController!.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      return forecast;
    } else {
      throw Exception('Failed to fetch weather forecast data');
    }
  }
}
