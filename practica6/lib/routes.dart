import 'package:flutter/material.dart';
import 'package:practica6/screens/lista.dart';
//import 'package:practica6/screens/locationDetailScreen.dart';
import 'package:practica6/screens/mapScreen.dart';

Map<String, WidgetBuilder> getRoutes(){
  return{
    '/map' : (BuildContext context) => MapScreen(),
    '/lista' : (BuildContext context) => listWeatherMarks(),
    //'/detalles' : (BuildContext context) => LocationDetailScreen(latitude: ,), 
  };
}