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
            'https://api.openweathermap.org/data/2.5/forecast?lat=${locationData.latitude}&lon=${locationData.longitude}&lang=es&appid=$apiKey&units=metric'));

            if (response.statusCode == 200) {
              // Parsear datos y obtener solo una temperatura por día
              List<Map<String, dynamic>> dailyTemperatures = [];
              Map<String, dynamic> data = json.decode(response.body);
              List<dynamic> list = data['list'];

              String currentDate = '';
              for (var item in list) {
                String date = item['dt_txt'].toString().substring(0, 10);

                // Solo agregar la temperatura si es un nuevo día
                if (date != currentDate) {
                  currentDate = date;

                  double temperature = item['main']['temp'].toDouble();
                  double maxTemperature = item['main']['temp_max'].toDouble();
                  double minTemperature = item['main']['temp_min'].toDouble();
                  String weatherDescription = item['weather'][0]['description'];
                  String iconCode = item['weather'][0]['icon'];
                  String cityName = data['city']['name'];

                  // Agregar datos al listado
                  dailyTemperatures.add({
                    'date': date,
                    'temperature': temperature,
                    'maxTemperature': maxTemperature,
                    'minTemperature': minTemperature,
                    'weatherDescription': weatherDescription,
                    'iconCode': iconCode,
                    'cityName': cityName,
                  });
                }
              }
          return dailyTemperatures;
        } else {
          print('Error en la solicitud HTTP: ${response.statusCode}');
          throw Exception('Error al cargar datos del pronóstico del tiempo');
        }
      } else {
        throw Exception('Error al obtener la ubicación');
      }
    } catch (e) {
      print('Error general: $e');
      return [];
    }
  }

  Future<double> getTemperature(double latitude, double longitude) async {
    try {
      final apiKey = 'f867dff8c864293f7f3b39d86b7c4250';
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&lang=es&cnt=1&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        double temperature = data['list'][0]['main']['temp'].toDouble();
        return temperature;
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
        throw Exception('Error al cargar datos del pronóstico del tiempo');
      }
    } catch (e) {
      print('Error general: $e');
      return 0.0;
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

  Future<List<Map<String, dynamic>>> getWeatherDetails(lat, lng) async {
    final apiKey = 'f867dff8c864293f7f3b39d86b7c4250';
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lng}&lang=es&appid=$apiKey&units=metric'));
      if (response.statusCode == 200) {
        // Parsear datos y obtener solo una temperatura por día
        List<Map<String, dynamic>> dailyTemperatures = [];
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> list = data['list'];

        String currentDate = '';
        for (var item in list) {
          String date = item['dt_txt'].toString().substring(0, 10);

          // Solo agregar la temperatura si es un nuevo día
          if (date != currentDate) {
            currentDate = date;

            double temperature = item['main']['temp'].toDouble();
            double maxTemperature = item['main']['temp_max'].toDouble();
            double minTemperature = item['main']['temp_min'].toDouble();
            String weatherDescription = item['weather'][0]['description'];
            String iconCode = item['weather'][0]['icon'];
            String cityName = data['city']['name'];

            // Agregar datos al listado
            dailyTemperatures.add({
              'date': date,
              'temperature': temperature,
              'maxTemperature': maxTemperature,
              'minTemperature': minTemperature,
              'weatherDescription': weatherDescription,
              'iconCode': iconCode,
              'cityName': cityName,
            });
          }
        }
      return dailyTemperatures;
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      throw Exception('Error al cargar datos del pronóstico del tiempo');
    }
  }
}
