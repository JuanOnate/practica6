import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
                  Text('${dailyTemperatures.isNotEmpty ? dailyTemperatures[0]['cityName'] : ''}',
                  style: TextStyle(
                    color: Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 45,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(3.0, 3.0),
                      )
                    ]
                  ),),
                  LottieBuilder.asset("animation/${dailyTemperatures[0]['iconCode']}.json"),
                  Text('${dailyTemperatures[0]['temperature']}°C',
                  style: TextStyle(
                    color:  Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 40,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(3.0, 3.0),
                      )
                    ]
                  ),),
                  Text('${dailyTemperatures[0]['weatherDescription']}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 15,
                  ),),
                  SizedBox(height: 20),
                  Text('Max: ${dailyTemperatures[0]['maxTemperature']}°C',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 15,
                  ),),
                  Text('Min: ${dailyTemperatures[0]['minTemperature']}°C',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 15,
                  ),),
                  SizedBox(height: 20),
                  const Text('Pronóstico para los próximos 5 días:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 15,
                  ),),
                  Container(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dailyTemperatures.length - 1,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 96, 125, 139).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                          ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${dailyTemperatures[index + 1]['temperature']}°C',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Open Sans',
                                    fontSize: 20,
                                  ),),
                                Text('${dailyTemperatures[index + 1]['date']}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Open Sans',
                                    fontSize: 15,
                                  ),),
                                LottieBuilder.asset("animation/${dailyTemperatures[index + 1]['iconCode']}.json", width: 90,),
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
