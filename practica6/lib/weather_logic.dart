import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherLogic {
  Future<List<Map<String, dynamic>>> getWeatherData() async {
    try {
      // Obtener ubicación
      LocationData? locationData = await _getLocation();

      if (locationData != null) {
        // Realizar la solicitud HTTP
        final apiKey = 'f867dff8c864293f7f3b39d86b7c4250';
        final response = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey&units=metric'));

        if (response.statusCode == 200) {
          // Parsear datos y obtener solo una temperatura por día
          List<Map<String, dynamic>> dailyTemperatures = [];
          Map<String, dynamic> data = json.decode(response.body);
          List<dynamic> list = data['list'];

          String currentCity = data['city']['name'];
          String currentDate = '';
          for (var item in list) {
            String date = item['dt_txt'].toString().substring(0, 10);

            if (date != currentDate) {
              // Nueva fecha, agregar temperatura y nombre de la ciudad al listado
              currentDate = date;
              double temperature = item['main']['temp'].toDouble();
              String weatherDescription = item['weather'][0]['description'];
              String iconCode = item['weather'][0]['icon'];

              dailyTemperatures.add({
                'date': date,
                'temperature': temperature,
                'weatherDescription': weatherDescription,
                'iconCode': iconCode,
                'cityName': currentCity, // Agregar el nombre de la ciudad
              });
            }
          }

          return dailyTemperatures;
        } else {
          throw Exception('Error al cargar datos del pronóstico del tiempo');
        }
      } else {
        throw Exception('Error al obtener la ubicación');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<LocationData?> _getLocation() async {
    try {
      var location = Location();
      return await location.getLocation();
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      return null;
    }
  }
}
