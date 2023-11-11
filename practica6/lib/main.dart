import 'package:flutter/material.dart';
import 'package:practica6/routes.dart';
import 'package:practica6/screens/weatherScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
      routes: getRoutes(),
    );
  }
}
