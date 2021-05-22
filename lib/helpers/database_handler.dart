import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  static const String DATABASE_FILENAME = 'currentRide.db';
  static const String SQL_CREATE_SCHEMA =
      'CREATE TABLE IF NOT EXISTS current_ride (ride_ID STRING, bike_ID STRING)';
  static const String SQL_RIDE_INSERT =
      'INSERT INTO current_ride (ride_id, bike_id) VALUES (?, ?)';
  static const String SQL_RIDE_SELECT =
      'SELECT ride_id, bike_id FROM current_ride';
  static const String SQL_RIDE_DELETE = 'DELETE FROM current_ride';

  static DatabaseHandler _instance;

  final Database db;

  DatabaseHandler._({Database database}) : db = database;

  factory DatabaseHandler.getInstance() {
    assert(_instance != null);
    return _instance;
  }

  static Future initialize() async {
    final db = await openDatabase(DATABASE_FILENAME, version: 1,
        onCreate: (Database db, int version) async {
      createTables(db, SQL_CREATE_SCHEMA);
    });
    _instance = DatabaseHandler._(database: db);
  }

  static void createTables(Database db, String sql) async {
    await db.execute(sql);
  }

  Future<void> saveRideState(String rideID, String bikeID) async {
    await db.transaction((txn) async {
      await txn.rawInsert(SQL_RIDE_INSERT, [rideID, bikeID]);
    });
  }

  Future<List<Map>> getRideState() async {
    return db.rawQuery(SQL_RIDE_SELECT);
  }

  void clearRideState() async {
    await db.execute(SQL_RIDE_DELETE);
  }
}
