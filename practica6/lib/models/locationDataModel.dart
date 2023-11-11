class LocationDataModel {
  int id;
  String nombre;
  double latitud;
  double longitud;

  LocationDataModel({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  factory LocationDataModel.fromMap(Map<String, dynamic> map) {
    return LocationDataModel(
      id: map['idLocation'],
      nombre: map['nombre'],
      latitud: map['latitud'],
      longitud: map['longitud'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idLocation': id,
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}
