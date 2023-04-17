# Weather App
![note-logo]




## About The Project

Weather App for fetching weather data from the OpenWeatherMap API. The repository handles API requests for current weather data and weather forecasts based on city names. It uses the http package for making HTTP requests and the jsonDecode function from the dart:convert package for parsing JSON responses.

![screenshot]  ![screenshot1]
### Features

•	Fetches current weather data and weather forecasts from OpenWeatherMap API.

•   Supports both metric and imperial units for temperature.
Stores fetched weather data in a List of Weather objects.

•   Provides a PageController for managing pagination of weather forecast data.

•   Handles error cases and throws exceptions when API requests fail.

![openweather]


### Usage
1. Initialize the WeatherRepository class with an API key from OpenWeatherMap.

2. Call the getWeather() method with a city name to fetch current weather data for that city.

3. Call the getWeatherForecast() method with a city name to fetch weather forecast data for that city.

4. Access the fetched weather data from the forecast list and use it to update the UI or perform other operations.

5. Make sure to handle exceptions thrown by the repository when API requests fail, and update the UI or perform appropriate error handling accordingly.

### Implementation Details

The weather_repository.dart file contains the implementation of the WeatherRepository class, which is responsible for fetching weather data from an API.

Here's an overview of the code:

•   The WeatherRepository class has a required apiKey parameter in its constructor, which is used to authenticate API requests.

•   The _isMetric boolean variable is used to determine whether the weather data should be fetched in metric or imperial units.

•   The forecast list stores the retrieved weather forecast data.

•   The pageController variable is a nullable PageController object that is used to manage the page navigation in the app.

•   The currentPage variable keeps track of the current page in the weather forecast data.

•   The WeatherRepository class provides two methods for fetching weather data:

getWeather(String city): This method fetches current weather data for the specified city. It constructs an API URL with the city name, unit type (metric or imperial), and the API key, and sends an HTTP GET request using the http package. If the response is successful (HTTP status code 200), the method parses the response body as JSON, creates a Weather object from the parsed data using the fromJson method, adds it to the forecast list, updates the currentPage variable, and animates the pageController to the current page. Finally, it returns the retrieved Weather object. If the response is not successful, an exception is thrown with a message indicating that the weather data fetch failed.

getWeatherForecast(String city): This method fetches weather forecast data for the specified city. It constructs an API URL with the city name, unit type, and API key, and sends an HTTP GET request using the http package. If the response is successful, the method parses the response body as JSON, initializes the pageController if it's null, clears the forecast list, and appends the parsed forecast data to the forecast list using the fromForecastJson method. It updates the currentPage variable and animates the pageController to the current page. Finally, it returns the retrieved forecast data as a list of Weather objects. If the response is not successful, an exception is thrown with a message indicating that the weather forecast data fetch failed.

### Weather Class

The Weather class is a model class that represents weather data retrieved from a JSON response. It has several properties including date, city, description, temperature, windSpeed, and humidity, and provides methods for parsing JSON data and creating Weather objects from it. Here's an overview of the code:

The Weather class has the following properties:

date: a DateTime object representing the date and time of the weather data

city: a String representing the name of the city for which the weather data is retrieved

description: a String representing the weather description (e.g. "Clear", "Cloudy", "Rainy")

temperature: a double representing the temperature in the specified unit (metric or imperial)

windSpeed: a double representing the wind speed in the specified unit

humidity: an int representing the humidity percentage


The Weather class provides the following methods:

fromJson(Map<String, dynamic> json, bool isMetric): a factory method that creates a Weather object from a JSON map. It takes the JSON data and a boolean flag indicating whether the temperature unit is metric or imperial. It parses the JSON data and returns a Weather object with the parsed data.
fromForecastJson(Map<String, dynamic> json, bool isMetric): a factory method that creates a list of Weather objects from a JSON map. It takes the JSON data and a boolean flag indicating whether the temperature unit is metric or imperial. It parses the JSON data and returns a list of Weather objects with the parsed forecast data.

### Dependencies
The WeatherRepository class uses the http package for making HTTP requests and the jsonDecode function from the dart:convert package for parsing JSON responses. Make sure to add these dependencies to your pubspec.yaml file:

dependencies:

http: ^0.13.5

lottie: ^1.0.0

geolocator: ^9.0.2

permission_handler: ^10.2.0

### Error Handling
The WeatherRepository class handles error cases and throws exceptions when API requests fail. You should make sure to handle these exceptions in your app and update the UI or perform appropriate error handling accordingly. For example, you can catch the exceptions thrown by the repository when calling the getWeather() and getWeatherForecast() methods, and display an error message to the user or retry the request.

### Conclusion
The Weather Repository is a Dart class that provides an abstraction for fetching weather data from the OpenWeatherMap API. It handles API requests, parses JSON responses, and provides a list of Weather objects representing the retrieved weather data. The repository can be easily integrated into your Flutter app to fetch and display current weather data and weather forecasts for different cities.





## Contact
[![LinkedIn][linkedin-shield]][linkedin-url]








[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/ivan-cilakov-551489168/
[product-screenshot]: images/screenshot.png
[note-logo]: https://i.imgur.com/l5FQe3Db.jpg
[openweather]: https://i.imgur.com/hmU0JBrm.jpg
[screenshot]: https://i.imgur.com/qRozjdzl.png
[screenshot1]: https://i.imgur.com/YFtcKnVl.png




 


# Weather-App
