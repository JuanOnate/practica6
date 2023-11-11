import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:practica6/database/db.dart';
import 'package:practica6/weather_logic.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  MapType _currentMapType = MapType.normal;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  WeatherLogic weatherLogic = WeatherLogic();

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: _currentMapType,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        onTap: _onMapTapped,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _getCurrentLocation(),
        label: const Text('Mi ubicación'),
        icon: const Icon(Icons.my_location),
      ),
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/lista').then((value){setState((){});}),
            icon: const Icon(Icons.list)
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MapType.normal,
                child: Text('Normal'),
              ),
              PopupMenuItem(
                value: MapType.satellite,
                child: Text('Satelite'),
              ),
              PopupMenuItem(
                value: MapType.terrain,
                child: Text('Terreno'),
              ),
              PopupMenuItem(
                value: MapType.hybrid,
                child: Text('Hibrido'),
              ),
            ],
            onSelected: (MapType result){
              setState(() {
                _currentMapType = result;
              });
            },
          )
        ],
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
      _addMarker(currentLocation, currentTemperature, 'Ubicación actual');

      // Centra la cámara en la ubicación actual
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newLatLng(currentLocation));
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  void _addMarker(LatLng position, double currentTemperature, String locationName) {
    setState(() {
      // Utiliza addAll en lugar de asignar un nuevo conjunto de marcadores
      _markers.addAll({
        Marker(
          markerId: MarkerId(locationName),
          position: position,
          infoWindow: InfoWindow(
            title: locationName,
            snippet: 'Temperatura: $currentTemperature°C',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      });
    });
  }

  void _onMapTapped(LatLng point) {
    String locationName = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nuevo marcador'),
          content: Column(
            children: [
              Text('Latitud: ${point.latitude}\nLongitud: ${point.longitude}'),
              TextField(
                onChanged: (value){
                  locationName = value;
                },
                decoration: InputDecoration(labelText: 'Nombre del marcador'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                await _onOkPressed(point, locationName);
                Navigator.of(context).pop();
              }, 
              child: Text('Guardar'),
            )
          ],
        );
      },
    );
  }

  Future<void> _onOkPressed(LatLng point, String locationName) async {
    //guardar en la bd
    var data = {'nombre': locationName, 'latitud': point.latitude, 'longitud': point.longitude};
    await WeatherDB().insertLocation(data);
    //obtener temp actual
    double temperature = await weatherLogic.getTemperature(point.latitude, point.longitude);
    //agregar marcador
    _addMarker(point, temperature, locationName);
  }
}
