import 'package:flutter/material.dart';
import 'package:practica6/screens/lista.dart';
import 'package:practica6/screens/mapScreen.dart';
import 'package:practica6/screens/weatherScreen.dart';

Map<String, WidgetBuilder> getRoutes(){
  return{
    '/map' : (BuildContext context) => MapScreen(),
    '/lista' : (BuildContext context) => listWeatherMarks(),
    '/principal' : (BuildContext context) => WeatherScreen(),
  };
}