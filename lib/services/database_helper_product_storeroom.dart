import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_room/models/product_storeroom.dart';

class ProductStoreroomDatabaseHelper {
  static Database? _database;
  static const String _productStoreroomTableName = 'product_storeroom';
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
      join(path, 'productstorerooms.db'),
      onCreate: (db, version) {
        // Create the table for product_storeroom
        db.execute(
            'CREATE TABLE $_productStoreroomTableName(id TEXT PRIMARY KEY, productId TEXT, storeroomId TEXT)');
        // Create other necessary tables if any
      },
      version: _version,
    );
  }

  static Future<void> insertProductStoreroom(
      ProductStoreroom productStoreroom) async {
    final Database db = await database;
    await db.insert(
      _productStoreroomTableName,
      productStoreroom.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ProductStoreroom>> getAllProductStorerooms() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_productStoreroomTableName);
    return List.generate(maps.length, (i) {
      return ProductStoreroom.fromMap(maps[i]);
    });
  }

static Future<List<String>> getProductIdsByStoreroomId(String storeroomId) async {
  final Database db = await database;
  final List<Map<String, dynamic>> productStoreroomMaps = await db.query(
    _productStoreroomTableName,
    where: 'storeroomId = ?',
    whereArgs: [storeroomId],
  );

  List<String> productIds = [];
  for (final productStoreroomMap in productStoreroomMaps) {
    final String productId = productStoreroomMap['productId'];
    productIds.add(productId);
  }
  return productIds;
}

}
