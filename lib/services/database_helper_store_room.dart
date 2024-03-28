import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_room2/models/store_room.dart';


class StoreRoomDatabaseHelper {
  static Database? _database;
  static const String _storeRoomTableName = 'store_rooms';
  static const String _productStoreRoomTableName = 'product_storeroom';

  static const int _version = 1;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'store_rooms.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $_storeRoomTableName(id TEXT PRIMARY KEY, roomId TEXT, space TEXT)',
        );
        await db.execute(
          'CREATE TABLE $_productStoreRoomTableName(id INTEGER PRIMARY KEY, productId TEXT, storeroomId TEXT, FOREIGN KEY(productId) REFERENCES $_storeRoomTableName(id), FOREIGN KEY(storeroomId) REFERENCES $_storeRoomTableName(id))',
        );
      },
      version: _version,
    );
  }

  static Future<void> insertStoreRoom(StoreRoom room) async {
    final Database db = await database;
    await db.insert(
      _storeRoomTableName,
      room.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  

  static Future<List<StoreRoom>> fetchAllStoreRooms() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_storeRoomTableName);
    return List.generate(maps.length, (i) {
      return StoreRoom(
        id: maps[i]['id'],
        roomId: maps[i]['roomId'],
        space: maps[i]['space'],
      );
    });
  }

}
