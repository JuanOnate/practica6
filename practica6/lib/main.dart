import 'package:flutter/material.dart';
import 'weather_logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherLogic weatherLogic = WeatherLogic();
  double? temperature;
  String? cityName;
  String? weatherDescription;
  String? iconCode;

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  Future<void> _getWeatherData() async {
    Map<String, dynamic> weatherData = await weatherLogic.getWeatherData();
    if (weatherData.isNotEmpty) {
      setState(() {
        temperature = weatherData['temperature'];
        cityName = weatherData['cityName'];
        weatherDescription = weatherData['weatherDescription'];
        iconCode = weatherData['iconCode'];
      });
    } else {
      // Manejar error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: temperature != null && cityName != null && weatherDescription != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Temperatura actual: $temperature°C'),
                Text('Ciudad: $cityName'),
                Text('Descripción del clima: $weatherDescription'),
                Image.network('https://openweathermap.org/img/wn/$iconCode@2x.png'),
              ],
            )
          : Text('Cargando datos...'),
    );
  }
}