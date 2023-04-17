import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/data/weather_repository.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/search_city_dialog.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  List<Weather> _forecast = [];
  bool _isMetric = true;
  bool _isLoading = true;
  String _currentCity = '';
  int _currentPage = 0;
  late PageController _pageController;
  late AnimationController _controller;
  bool _isNightTime = false;
  WeatherRepository weatherRepository =
      WeatherRepository(apiKey: 'YOUR_API_KEY');

  // Request location permissions
  void requestLocationPermissions() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted) {
      PermissionStatus result = await Permission.locationWhenInUse.request();
      if (result.isGranted) {
        // Permission granted, handle location access
        _fetchWeatherLocation(); // Call the weather API after getting permission
      } else {
        // Permission denied, handle accordingly
      }
    } else if (status.isGranted) {
      // Location permission already granted, handle location access
      _fetchWeatherLocation(); // Call the weather API if permission is already granted
    }
  }

  void _fetchWeatherLocation() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      double latitude = position.latitude;
      double longitude = position.longitude;
      final String unit = _isMetric ? 'metric' : 'imperial';
      const String apiKey =
          'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
      final String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$unit&appid=$apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        final Weather weather = Weather.fromJson(data);
        setState(() {
          _forecast.clear();
          _currentCity = weather.city; // Update current city
          _forecast.add(weather);
          _isLoading = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to fetch weather data'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Location permission not granted, request it
      requestLocationPermissions();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onPageSelected(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onUnitChanged(bool value) {
    setState(() {
      _isMetric = value;
    });
  }

  void _onSearchPressed() async {
    setState(() {
      _isLoading = true; // Start loading data
    });

    final String city = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchCityDialog();
      },
    );

    // Fetch weather data from repository
    await weatherRepository.getWeather(city);
    await weatherRepository.getWeatherForecast(city);

    // Update state with fetched data
    setState(() {
      _forecast = weatherRepository.forecast;
      _pageController =
          PageController(initialPage: weatherRepository.currentPage);
      _currentCity = city;
      _isLoading = false; // Finish loading data
    });
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermissions();
    _fetchWeatherLocation();
    _controller = AnimationController(vsync: this);
    _pageController =
        PageController(initialPage: weatherRepository.currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: false,
      body: Stack(children: [
        isNightTime()
            ? Image.asset(
                'assets/images/night.jpg', // Replace with the path to your background image
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              )
            : Image.asset(
                'assets/images/day.jpg', // Replace with the path to your background image
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              IconButton(
                icon: Icon(Icons.search_sharp),
                iconSize: 35,
                onPressed: _onSearchPressed,
                color: isNightTime() ? Colors.white : Colors.black,
              ),
              Text(
                _currentCity.isNotEmpty ? '$_currentCity ' : '',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: isNightTime() ? Colors.white : Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _forecast.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (BuildContext context, int index) {
                    final Weather weather = _forecast[index];
                    return _buildWeatherCard(weather);
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: Text(
                  'Metric',
                  style: TextStyle(
                      color: isNightTime() ? Colors.white : Colors.black),
                ),
                value: _isMetric,
                onChanged: _onUnitChanged,
                activeColor: isNightTime() ? Colors.deepPurple : Colors.green,
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ]),
    );
  }

  bool isNightTime() {
    // Get the current time
    DateTime now = DateTime.now();

    // Compare the current time with the threshold time (19:00)
    if (now.hour >= 19 || now.hour < 6 || _isNightTime == true) {
      return true;
    } else {
      return false;
    }
  }

  String _getLottieAnimationPath() {
    // Get the current time
    DateTime now = DateTime.now();

    if (_forecast.isNotEmpty) {
      final Weather weather = _forecast[_currentPage];
      String weatherCondition = weather.weatherCondition.toLowerCase();
      //if the current time is night time, then display different animations
      if (isNightTime()) {
        if (weatherCondition.contains('few clouds')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_sgiztka9.json';
        } else if (weatherCondition.contains('broken clouds')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_5tzqguri.json';
        } else if (weatherCondition.contains('overcast clouds')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_qqhrsksk.json';
        } else if (weatherCondition.contains('light rain')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_3udf8lcw.json';
        } else if (weatherCondition.contains('moderate rain')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_jr9yjlcf.json';
        } else if (weatherCondition.contains('heavy intensity rain')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_22gtsfnq.json';
        } else if (weatherCondition.contains('clear')) {
          return 'https://assets6.lottiefiles.com/private_files/lf30_iugenddu.json';
        } else {
          return 'https://assets6.lottiefiles.com/private_files/lf30_9bptg8sh.json';
        }
      } else {
        if (weatherCondition.contains('few clouds')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_j1g2rpsv.json';
        } else if (weatherCondition.contains('broken clouds')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_ykkzuozu.json';
        } else if (weatherCondition.contains('overcast clouds')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_jvkyx6tg.json';
        } else if (weatherCondition.contains('light rain')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_oj6pxozf.json';
        } else if (weatherCondition.contains('moderate rain')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_rb778uhf.json';
        } else if (weatherCondition.contains('heavy intensity rain')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_kj3arjju.json';
        } else if (weatherCondition.contains('clear')) {
          return 'https://assets10.lottiefiles.com/private_files/lf30_moaf5wp5.json';
        } else {
          return 'https://assets10.lottiefiles.com/private_files/lf30_j1g2rpsv.json';
        }
      }
    } else {
      return 'https://assets10.lottiefiles.com/private_files/lf30_j1g2rpsv.json';
    }
  }

  Widget _buildWeatherCard(Weather weather) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: isNightTime()
            ? Colors.blueAccent.withOpacity(0.2)
            : Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Lottie.network(
              _getLottieAnimationPath(),
              controller: _controller,
              width: 200,
              height: 200,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..repeat(); // Set repeat to true to loop the animation.
              },
            ),
          ),
          Text(
            //            '${weather.weekday}, ${weather.date.day}.${weather.date.month}.${weather.date.year}',
            '${weather.weekday}',
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: isNightTime() ? Colors.white : Colors.black),
          ),
          SizedBox(height: 18.0),
          Text(
            'Temperature: ${weather.temperature} ${_isMetric ? '°C' : '°F'}',
            style: TextStyle(
                fontSize: 21.0,
                color: isNightTime() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.0),
          Text(
            'Weather: ${weather.description}',
            style: TextStyle(
                fontSize: 21.0,
                color: isNightTime() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.0),
          Text(
            'Wind: ${weather.windSpeed} ${_isMetric ? 'm/s' : 'mph'}',
            style: TextStyle(
                fontSize: 21.0,
                color: isNightTime() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.0),
          Text(
            'Humidity: ${weather.humidity}%',
            style: TextStyle(
                fontSize: 21.0,
                color: isNightTime() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 16.0),
          Text(
            'Time: ${weather.time}',
            style: TextStyle(
                fontSize: 21.0,
                color: isNightTime() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400),
          ),
          IconButton(
            icon: Icon(
              Icons.brightness_4,
              color: isNightTime() ? Colors.white : Colors.black,
            ), // use your desired icon for the nighttime/daytime switch
            onPressed: () {
              setState(() {
                _isNightTime = !_isNightTime;
              });
            },
          ),
        ],
      ),
    );
  }
}
