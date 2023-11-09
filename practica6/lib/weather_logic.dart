import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherLogic {
  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      // Obtener ubicación
      LocationData? locationData = await _getLocation();

      if (locationData != null) {
        // Realizar la solicitud HTTP
        final apiKey = 'f867dff8c864293f7f3b39d86b7c4250'; // Reemplaza con tu clave de API
        final response = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=${locationData.latitude}&lon=${locationData.longitude}&lang=es&appid=$apiKey&units=metric'));
        print(locationData.latitude);
        print(locationData.longitude);

        if (response.statusCode == 200) {
          // Parsear datos y obtener temperatura, nombre de la ciudad y descripción del clima
          Map<String, dynamic> data = json.decode(response.body);
          double temperature = data['list'][0]['main']['temp'];
          String cityName = data['city']['name'];
          String weatherDescription = data['list'][0]['weather'][0]['description'];
          String iconCode = data['list'][0]['weather'][0]['icon'];

          return {'temperature': temperature, 'cityName': cityName, 'weatherDescription': weatherDescription, 'iconCode':iconCode};
        } else {
          throw Exception('Error al cargar datos del pronóstico del tiempo');
        }
      } else {
        throw Exception('Error al obtener la ubicación');
      }
    } catch (e) {
      print('Error: $e');
      return {};
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
