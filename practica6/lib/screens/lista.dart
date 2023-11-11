import 'package:flutter/material.dart';
import 'package:practica6/database/db.dart';
import 'package:practica6/weather_logic.dart';

class listWeatherMarks extends StatefulWidget {
  const listWeatherMarks({super.key});

  @override
  State<listWeatherMarks> createState() => _listWeatherMarksState();
}

class _listWeatherMarksState extends State<listWeatherMarks> {

  late Future<List<Map<String, dynamic>>> locations;

  @override
  void initState() {
    super.initState();
    locations = _getLocations();
  }

  Future<List<Map<String, dynamic>>> _getLocations() async {
    List<Map<String, dynamic>> locationList = await WeatherDB().getAllLocations();

    if (locationList != null) {
      List<Map<String, dynamic>> updatedList = [];

      WeatherLogic weatherLogic = WeatherLogic();

      for (var location in locationList) {
        double temperature = await weatherLogic.getTemperature(location['latitud'], location['longitud']);
        Map<String, dynamic> updatedLocation = {...location, 'temperature': temperature};
        updatedList.add(updatedLocation);
      }

      return updatedList;
    } else {
      return [];  // o un valor por defecto apropiado en tu caso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Ubicaciones'),
      ),
      body: FutureBuilder(
        future: locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> locationList = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: locationList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(locationList[index]['nombre']),
                  subtitle: Text('Latitud: ${locationList[index]['latitud']}, Longitud: ${locationList[index]['longitud']}\nTemperatura: ${locationList[index]['temperature']}°C'),
                  onTap: () {
                    // Navegar a la pantalla de detalles o realizar acciones adicionales
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}