import 'package:flutter/material.dart';
import 'package:weather_app/data/weather_repository.dart';
import 'package:weather_app/splash_screen.dart';

void main() {
  final WeatherRepository weatherRepository = WeatherRepository(apiKey: 'YOUR_API_KEY');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: SplashScreen(),
    ),
  );
}
