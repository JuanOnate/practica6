import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:practica6/weather_logic.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  WeatherLogic weatherLogic = WeatherLogic();

  Set<Marker> _markers = {}; // Variable para almacenar los marcadores

  @override
  void initState() {
    super.initState();
    // Al inicio, obtén la ubicación actual y configúrala como la ubicación inicial del mapa.
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Puedes establecer una ubicación inicial por defecto
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _getCurrentLocation(),
        label: const Text('Mi ubicación'),
        icon: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      var location = Location();
      LocationData locationData = await location.getLocation();
      LatLng currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      // Obtiene la temperatura actual
      List<Map<String, dynamic>> temperatures = await weatherLogic.getWeatherData();
      double currentTemperature = temperatures.isNotEmpty ? temperatures[0]['temperature'] : 0.0;

      // Agrega un marcador en la ubicación actual
      _addMarker(currentLocation, currentTemperature);

      // Centra la cámara en la ubicación actual
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newLatLng(currentLocation));
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  void _addMarker(LatLng position, double currentTemperature) {
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('currentLocation'),
          position: position,
          infoWindow: InfoWindow(
            title: 'Ubicación actual',
            snippet: 'Temperatura: $currentTemperature°C',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    });
  }
}
