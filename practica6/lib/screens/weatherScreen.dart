import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:practica6/screens/lista.dart';
import 'package:practica6/screens/mapScreen.dart';
import 'package:practica6/weather_logic.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  WeatherLogic weatherLogic = WeatherLogic();
  List<Map<String, dynamic>> dailyTemperatures = [];

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  Future<void> _getWeatherData() async {
    List<Map<String, dynamic>> temperatures = await weatherLogic.getWeatherData();
    if (temperatures.isNotEmpty) {
      setState(() {
        dailyTemperatures = temperatures;
      });
    } else {
      // Manejar error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Colors.blueGrey,
        color: Colors.blueGrey.shade100,
        animationDuration: Duration(milliseconds: 600),
        index: 0,
        onTap: (index){
          switch(index){
            case 0:
            break;
            case 1:
              Future.delayed(Duration(milliseconds: 600), () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => MapScreen(),
                    settings: RouteSettings(name: '/map'),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                    transitionDuration: Duration(milliseconds: 0), // Establecer la duración a 0 para desactivar la transición
                  ),
                );
              });
            break;
            case 2:
              Future.delayed(Duration(milliseconds: 600), () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => listWeatherMarks(),
                    settings: RouteSettings(name: '/lista'),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                    transitionDuration: Duration(milliseconds: 0), // Establecer la duración a 0 para desactivar la transición
                  ),
                );
              });
            break;
            default:
            print('nada');
          }
        },
        items: [
          Icon(Icons.home, color: Colors.blueGrey,),
          Icon(Icons.map, color: Colors.blueGrey,),
          Icon(Icons.list, color: Colors.blueGrey,),
        ]
      ),
      body: Center(
        child: dailyTemperatures.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Temperatura actual: ${dailyTemperatures[0]['temperature']}°C'),
                  Text('Ciudad: ${dailyTemperatures.isNotEmpty ? dailyTemperatures[0]['cityName'] : ''}'),
                  Text('Descripción del clima: ${dailyTemperatures[0]['weatherDescription']}'),
                  Image.network('https://openweathermap.org/img/wn/${dailyTemperatures[0]['iconCode']}@2x.png'),
                  SizedBox(height: 20),
                  Text('Temperatura máxima del día actual: ${dailyTemperatures[0]['maxTemperature']}°C'),
                  Text('Temperatura mínima del día actual: ${dailyTemperatures[0]['minTemperature']}°C'),
                  SizedBox(height: 20),
                  Text('Pronóstico para los próximos 5 días:'),
                  Container(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dailyTemperatures.length - 1,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Fecha: ${dailyTemperatures[index + 1]['date']}'),
                                Text('Temperatura: ${dailyTemperatures[index + 1]['temperature']}°C'),
                                Image.network('https://openweathermap.org/img/wn/${dailyTemperatures[index + 1]['iconCode']}@2x.png'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Text('Cargando datos...'),
      ),
    );
  }
}
