  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';
  import 'package:store_room/models/store_room.dart';

  class StoreRoomDatabaseHelper {
    static Database? _database;
    static const String _storeRoomTableName = 'store_rooms';

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
            'CREATE TABLE $_storeRoomTableName(id TEXT PRIMARY KEY, title TEXT, fillRate REAL)',
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
        conflictAlgorithm: ConflictAlgorithm.replace, // what does it?
      );
    }

    static Future<List<StoreRoom>> fetchAllStoreRooms() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_storeRoomTableName);
      if (maps.isEmpty) return [];
      return List.generate(maps.length, (i) {
        return StoreRoom(
          id: maps[i]['id'],
          title: maps[i]['title'],
          fillRate: maps[i]['space'],
        );
      });
    }
  }
