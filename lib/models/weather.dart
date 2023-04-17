class Weather {
  final DateTime date;
  final String city;
  final String description;
  final double temperature;
  final double windSpeed;
  final int humidity;

  Weather({
    required this.date,
    required this.city,
    required this.description,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });

  factory Weather.fromJson(dynamic json) {
    if (json == null) {
      return Weather(
        date: DateTime.now(),
        city: 'Unknown',
        description: 'Unknown',
        temperature: 0.0,
        windSpeed: 0.0, // Add windSpeed with default value
        humidity: 0, // Add humidity with default value
      );
    }
    return Weather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      city: json['name'] ?? 'Unknown',
      description: json['weather']?[0]['description'] ?? 'Unknown',
      temperature: json['main']?['temp']?.toDouble() ?? 0.0,
      windSpeed:
          json['wind']?['speed']?.toDouble() ?? 0.0, // Add windSpeed field
      humidity: json['main']?['humidity'] ?? 0, // Add humidity field
    );
  }

  static List<Weather> fromForecastJson(dynamic json) {
    List<Weather> forecast = [];
    List<dynamic> list = json['list'];
    for (var item in list) {
      Weather weather = Weather.fromJson(item);
      forecast.add(weather);
    }
    return forecast;
  }

  String get time {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get weekday {
    return _getWeekdayName(date.weekday); // returns the weekday name
  }

  String get weatherCondition {
    // Define the weatherCondition getter here based on the 'description' field
    // Return the weather condition based on the 'description' field value
    // Example: If 'description' contains 'rain', return 'Rainy'
    // You can modify this logic based on your requirements
    if (description.toLowerCase().contains('light rain')) {
      return 'light rain';
    } else if (description.toLowerCase().contains('moderate rain')) {
      return 'moderate rain';
    } else if (description.toLowerCase().contains('heavy intensity rain')) {
      return 'heavy intensity rain';
    } else if (description.toLowerCase().contains('snow')) {
      return 'Snowy';
    } else if (description.toLowerCase().contains('few clouds')) {
      return 'few clouds';
    } else if (description.toLowerCase().contains('broken clouds') ||
        description.toLowerCase().contains('scattered clouds')) {
      return 'broken clouds';
    } else if (description.toLowerCase().contains('overcast clouds')) {
      return 'overcast clouds';
    } else if (description.toLowerCase().contains('clear')) {
      return 'Clear';
    } else {
      return 'Unknown';
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}
