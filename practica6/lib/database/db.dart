import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class WeatherDB{
  static final nameDB = 'weatherDB';
  static final versionDB = 1;

  static Database? _database;
  Future<Database?> get database async {
    if(_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async{
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: _createTables
    );
  }

  FutureOr<void> _createTables(Database db, int version){
    String query = '''CREATE TABLE tblWeather(idLocation INTEGER PRIMARY KEY,
                                              nombre varchar(255),
                                              latitud REAL,
                                              longitud REAL
                                              );''';
    db.execute(query);
  }

  Future<int> insertLocation(Map<String, dynamic> data) async {
    var connection = await database;
    return connection!.insert('tblWeather', data);
  }

  Future<int> updateLocation(Map<String, dynamic> data) async {
    var connection = await database;
    return connection!.update('tblWeather', data, where: 'idLocation = ?', whereArgs: [data['idLocation']]);
  }

  Future<int> deleteLocation(int idLocation) async {
    var connection = await database;
    return connection!.delete('tblWeather', where: 'idLocation = ?', whereArgs: [idLocation]);
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    var connection = await database;
    return connection!.query('tblWeather');
  }
}